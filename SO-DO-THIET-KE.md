# Sơ đồ thiết kế — Hệ thống thi trắc nghiệm trực tuyến

> Giai đoạn 1: CHỈ trắc nghiệm (chưa có AI). DB: MySQL.
> Các bảng AI (`QUESTION_TEMP`, `AI_LOGS`) sẽ thêm ở giai đoạn 2.
>
> Cách chỉnh sửa: copy đoạn code mermaid dán vào https://mermaid.live để xem/sửa trực quan.

---

## 1. Sơ đồ phân rã chức năng (Sitemap)

```mermaid
flowchart TD
    ROOT[HỆ THỐNG THI TRẮC NGHIỆM TRỰC TUYẾN]

    ROOT --> A[1. Quản lý Hệ thống]
    ROOT --> B[2. Quản lý Ngân hàng Câu hỏi]
    ROOT --> C[3. Quản lý Đề thi]
    ROOT --> D[4. Tổ chức Thi trực tuyến]
    ROOT --> E[5. Thống kê - Báo cáo]
    ROOT --> F[6. Tìm kiếm]

    A --> A1[Đăng nhập & phân quyền User]
    A --> A2[Quản lý người dùng - Admin tạo GV/SV]
    A --> A3[Quản lý hồ sơ cá nhân]

    A --> A4[Quản lý lớp/nhóm & gán sinh viên]

    B --> B1[Quản lý môn học]
    B --> B2[Quản lý câu hỏi & đáp án]
    B --> B3[Import câu hỏi - Excel/CSV]

    C --> C1[Thêm/Xóa/Sửa đề thi]
    C --> C2[Chọn câu hỏi vào đề]
    C --> C3[Cài đặt cấu hình: thời gian, điểm đậu, đảo câu...]
    C --> C4[Giao đề cho lớp - private / public]

    D --> D1[SV: Xem danh sách đề được giao]
    D --> D2[SV: Vào làm bài thi]
    D --> D3[SV: Nộp bài]
    D --> D4[Chấm điểm tự động]
    D --> D5[SV: Xem kết quả & lịch sử thi]
    D --> D6[Khách: làm thử - giới hạn 20 câu, có quảng cáo]

    E --> E1[Thống kê điểm theo đề/môn]
    E --> E2[Thống kê tỉ lệ đậu/rớt]
```

---

## 2. Sơ đồ thực thể quan hệ (ERD) — MySQL

```mermaid
erDiagram
    USERS ||--o{ QUESTION_MAIN : "tạo câu hỏi"
    USERS ||--o{ EXAMS : "tạo đề thi"
    USERS ||--o{ SUBMISSIONS : "nộp bài"
    USERS ||--o{ CLASSES : "quản lý lớp"
    USERS ||--o{ CLASS_STUDENTS : "tham gia lớp"

    CLASSES ||--o{ CLASS_STUDENTS : "có học viên"
    CLASSES ||--o{ EXAM_CLASSES : "được giao đề"
    EXAMS ||--o{ EXAM_CLASSES : "giao cho lớp"

    SUBJECTS ||--o{ QUESTION_MAIN : "chứa"
    SUBJECTS ||--o{ EXAMS : "thuộc"

    QUESTION_MAIN ||--o{ ANSWERS : "có đáp án"
    QUESTION_MAIN ||--o{ EXAM_QUESTIONS : "nằm trong"

    EXAMS ||--o{ EXAM_QUESTIONS : "bao gồm"
    EXAMS ||--o{ SUBMISSIONS : "có lượt làm"

    SUBMISSIONS ||--o{ SUBMISSION_DETAILS : "chi tiết"
    QUESTION_MAIN ||--o{ SUBMISSION_DETAILS : "được trả lời"
    ANSWERS ||--o{ SUBMISSION_DETAILS : "được chọn"

    USERS {
        int id PK
        string username
        string email
        string password_hash
        string full_name
        string role "Admin/Teacher/Student"
        string status "active/locked"
        datetime created_at
    }

    SUBJECTS {
        int id PK
        string name
        string description
        datetime created_at
    }

    QUESTION_MAIN {
        int id PK
        int subject_id FK
        int created_by FK
        text content
        string question_type "single/truefalse"
        string difficulty "easy/medium/hard"
        datetime created_at
    }

    ANSWERS {
        int id PK
        int question_id FK
        string label "A/B/C/D"
        text content
        boolean is_correct
        int order_index
    }

    EXAMS {
        int id PK
        int subject_id FK
        int created_by FK
        string title
        string description
        datetime start_time
        datetime end_time
        int duration "phút"
        float pass_score
        boolean shuffle
        string access_type "private/public"
        string status "draft/published/closed"
        datetime created_at
    }

    EXAM_QUESTIONS {
        int exam_id PK,FK
        int question_id PK,FK
        int order_index
        float points
    }

    CLASSES {
        int id PK
        int created_by FK
        string name
        string description
        datetime created_at
    }

    CLASS_STUDENTS {
        int class_id PK,FK
        int student_id PK,FK
        datetime joined_at
    }

    EXAM_CLASSES {
        int exam_id PK,FK
        int class_id PK,FK
    }

    SUBMISSIONS {
        int id PK
        int user_id FK "null nếu là khách"
        string guest_name "tên khách (nếu không đăng nhập)"
        int exam_id FK
        datetime start_time
        datetime submit_time
        float total_score
        string status "in_progress/submitted/graded"
        boolean is_passed
    }

    SUBMISSION_DETAILS {
        int id PK
        int submission_id FK
        int question_id FK
        int selected_answer_id FK
        boolean is_correct
    }
```

---

## 3. Những thay đổi so với bản cũ của bạn

- **Bỏ tạm** 2 bảng `QUESTION_TEMP` và `AI_LOGS` (dành cho giai đoạn AI).
- `USERS`: thêm `email`, `full_name`, `status`, `created_at`; đổi `password` → `password_hash` (bảo mật).
- `QUESTION_MAIN`: thêm `question_type` (quyết định cách chấm), `created_by`, `created_at`; bỏ `approved_at/approved_by` (chỉ cần khi có quy trình duyệt AI).
- `ANSWERS`: thêm `label` (A/B/C/D) và `order_index`.
- `EXAMS`: thêm `created_by`, `description`, `shuffle`, `status`.
- `EXAM_QUESTIONS`: thêm `points` (điểm mỗi câu).
- `SUBMISSIONS`: thêm `status`, `is_passed`.
- `SUBMISSION_DETAILS`: thêm khóa chính `id` và **FK rõ ràng** `selected_answer_id → ANSWERS`.
- Bổ sung luồng **Sinh viên** trong sitemap (xem đề → làm bài → nộp → xem kết quả).

## 3b. Sơ đồ Use Case (biểu diễn bằng Mermaid)

> Mermaid không có ký hiệu use case chuẩn UML, nên dùng flowchart mô phỏng:
> hình tròn dẹt = use case, chữ đậm = tác nhân (actor). Có thể vẽ lại trong draw.io theo đúng ký hiệu UML dựa trên nội dung này.

```mermaid
flowchart LR
    %% ===== Tác nhân =====
    GUEST["👤 Khách<br/>(chưa đăng nhập)"]
    SV["👤 Sinh viên"]
    GV["👤 Giảng viên"]
    AD["👤 Quản trị viên"]

    subgraph HT["HỆ THỐNG THI TRẮC NGHIỆM TRỰC TUYẾN"]
        UC1([Xem giới thiệu / môn học])
        UC2([Làm thử đề công khai])
        UC3([Đăng ký / Đăng nhập])

        UC4([Tham gia lớp bằng mã])
        UC5([Làm bài thi được giao])
        UC6([Xem kết quả & lịch sử])
        UC7([Lưu đề vào kho cá nhân])

        UC8([Quản lý môn học])
        UC9([Quản lý ngân hàng câu hỏi])
        UC10([Import câu hỏi từ Excel/CSV])
        UC11([Tạo đề thi - trộn & xáo])
        UC12([Quản lý lớp & giao đề])
        UC13([Xem thống kê - báo cáo])

        UC14([Quản lý người dùng & phân quyền])

        UC15([Chấm điểm tự động]):::sys
    end

    GUEST --> UC1 & UC2 & UC3
    SV --> UC1 & UC4 & UC5 & UC6 & UC7
    GV --> UC8 & UC9 & UC10 & UC11 & UC12 & UC13 & UC7
    AD --> UC14 & UC8 & UC9 & UC11 & UC12 & UC13

    UC5 -. "include" .-> UC15
    UC2 -. "include" .-> UC15
    UC11 -. "extend" .-> UC10

    classDef sys fill:#e3f2fd,stroke:#1976d2;
```

## 4. Cập nhật (theo yêu cầu mới)

- Câu hỏi **chỉ 1 đáp án đúng**: `question_type` còn `single` / `truefalse`.
- Thêm 3 bảng cho lớp/nhóm: **`CLASSES`** (lớp), **`CLASS_STUDENTS`** (sinh viên trong lớp, quan hệ nhiều-nhiều), **`EXAM_CLASSES`** (giao đề cho lớp, nhiều-nhiều).
- `EXAMS.access_type`: `private` = chỉ lớp được giao mới làm; `public` = ai cũng làm được.
- Hỗ trợ **khách (không đăng nhập)**: `SUBMISSIONS.user_id` cho phép NULL + thêm `guest_name`.
- **Lưu ý:** giới hạn "khách chỉ làm 20 câu" và "hiện quảng cáo" là **logic ở code** (kiểm tra khi gọi API), không cần cột trong DB.

