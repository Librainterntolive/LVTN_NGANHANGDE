-- =====================================================================
-- Hệ thống thi trắc nghiệm trực tuyến - MySQL
-- Giai đoạn 1: chỉ trắc nghiệm (chưa AI)
-- Tên bảng khớp với GORM (chữ thường, số nhiều).
-- Kiểu id/khóa ngoại dùng BIGINT UNSIGNED để khớp kiểu uint của GORM.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS quiz_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE quiz_db;

-- Xóa bảng cũ (nếu chạy lại) - theo thứ tự ngược FK
DROP TABLE IF EXISTS submission_details;
DROP TABLE IF EXISTS submissions;
DROP TABLE IF EXISTS exam_classes;
DROP TABLE IF EXISTS exam_questions;
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS class_students;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS users;

-- ============== 1. USERS ==============
CREATE TABLE users (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(100) NOT NULL UNIQUE,
  email         VARCHAR(150) UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  full_name     VARCHAR(150),
  role          VARCHAR(20)  NOT NULL DEFAULT 'Student', -- Admin/Teacher/Student
  status        VARCHAR(20)  DEFAULT 'active',           -- active/locked
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============== 2. SUBJECTS ==============
CREATE TABLE subjects (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(150) NOT NULL,
  description VARCHAR(255),
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============== 3. CLASSES ==============
CREATE TABLE classes (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  created_by  BIGINT UNSIGNED,           -- giáo viên tạo lớp
  name        VARCHAR(150) NOT NULL,
  description VARCHAR(255),
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_classes_user FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- ============== 4. CLASS_STUDENTS (nhiều-nhiều) ==============
CREATE TABLE class_students (
  class_id   BIGINT UNSIGNED NOT NULL,
  student_id BIGINT UNSIGNED NOT NULL,
  joined_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (class_id, student_id),
  CONSTRAINT fk_cs_class   FOREIGN KEY (class_id)   REFERENCES classes(id) ON DELETE CASCADE,
  CONSTRAINT fk_cs_student FOREIGN KEY (student_id) REFERENCES users(id)   ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============== 5. QUESTIONS (ngân hàng câu hỏi) ==============
CREATE TABLE questions (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  subject_id    BIGINT UNSIGNED,
  created_by    BIGINT UNSIGNED,
  content       TEXT NOT NULL,
  question_type VARCHAR(20) DEFAULT 'single',  -- single/truefalse
  difficulty    VARCHAR(20) DEFAULT 'medium',  -- easy/medium/hard
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_q_subject FOREIGN KEY (subject_id) REFERENCES subjects(id),
  CONSTRAINT fk_q_user    FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- ============== 6. ANSWERS (đáp án) ==============
CREATE TABLE answers (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  question_id BIGINT UNSIGNED NOT NULL,
  label       VARCHAR(5),       -- A/B/C/D
  content     TEXT,
  is_correct  BOOLEAN DEFAULT FALSE,
  order_index INT DEFAULT 0,
  CONSTRAINT fk_a_question FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============== 7. EXAMS (đề thi) ==============
CREATE TABLE exams (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  subject_id  BIGINT UNSIGNED,
  created_by  BIGINT UNSIGNED,
  title       VARCHAR(200) NOT NULL,
  description VARCHAR(500),
  start_time  DATETIME,
  end_time    DATETIME,
  duration    INT,                       -- phút
  pass_score  FLOAT DEFAULT 0,
  shuffle     BOOLEAN DEFAULT FALSE,
  access_type VARCHAR(20) DEFAULT 'private', -- private/public
  status      VARCHAR(20) DEFAULT 'draft',   -- draft/published/closed
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_e_subject FOREIGN KEY (subject_id) REFERENCES subjects(id),
  CONSTRAINT fk_e_user    FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB;

-- ============== 8. EXAM_QUESTIONS (câu hỏi trong đề) ==============
CREATE TABLE exam_questions (
  exam_id     BIGINT UNSIGNED NOT NULL,
  question_id BIGINT UNSIGNED NOT NULL,
  order_index INT DEFAULT 0,
  points      FLOAT DEFAULT 1,
  PRIMARY KEY (exam_id, question_id),
  CONSTRAINT fk_eq_exam     FOREIGN KEY (exam_id)     REFERENCES exams(id)     ON DELETE CASCADE,
  CONSTRAINT fk_eq_question FOREIGN KEY (question_id) REFERENCES questions(id)
) ENGINE=InnoDB;

-- ============== 9. EXAM_CLASSES (giao đề cho lớp) ==============
CREATE TABLE exam_classes (
  exam_id  BIGINT UNSIGNED NOT NULL,
  class_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (exam_id, class_id),
  CONSTRAINT fk_ec_exam  FOREIGN KEY (exam_id)  REFERENCES exams(id)   ON DELETE CASCADE,
  CONSTRAINT fk_ec_class FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============== 10. SUBMISSIONS (lượt làm bài) ==============
CREATE TABLE submissions (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id     BIGINT UNSIGNED,            -- NULL nếu là khách
  guest_name  VARCHAR(150),               -- tên khách (nếu không đăng nhập)
  exam_id     BIGINT UNSIGNED NOT NULL,
  start_time  DATETIME,
  submit_time DATETIME,
  total_score FLOAT DEFAULT 0,
  status      VARCHAR(20) DEFAULT 'in_progress', -- in_progress/submitted/graded
  is_passed   BOOLEAN DEFAULT FALSE,
  CONSTRAINT fk_s_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_s_exam FOREIGN KEY (exam_id) REFERENCES exams(id)
) ENGINE=InnoDB;

-- ============== 11. SUBMISSION_DETAILS (chi tiết trả lời) ==============
CREATE TABLE submission_details (
  id                 BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  submission_id      BIGINT UNSIGNED NOT NULL,
  question_id        BIGINT UNSIGNED NOT NULL,
  selected_answer_id BIGINT UNSIGNED,
  is_correct         BOOLEAN DEFAULT FALSE,
  CONSTRAINT fk_sd_submission FOREIGN KEY (submission_id)      REFERENCES submissions(id) ON DELETE CASCADE,
  CONSTRAINT fk_sd_question   FOREIGN KEY (question_id)        REFERENCES questions(id),
  CONSTRAINT fk_sd_answer     FOREIGN KEY (selected_answer_id) REFERENCES answers(id)
) ENGINE=InnoDB;

-- ============== Dữ liệu mẫu ==============
-- Tài khoản admin mẫu. Đăng nhập: admin / admin123 (hash bcrypt bên dưới).
INSERT INTO users (username, email, password_hash, full_name, role)
VALUES ('admin', 'admin@example.com', '$2b$10$gRY3fXBZW7k.2m/v1umFqONfcBp6DYSo3FC/ZFa9uTbhFUEZ9/A6G', 'Quản trị viên', 'Admin');

INSERT INTO subjects (name, description) VALUES
('Cơ sở dữ liệu', 'Môn học mẫu'),
('Lập trình Web', 'Môn học mẫu');
