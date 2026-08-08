# Sơ đồ UML – Website quản lý ngân hàng đề thi đại học

Tài liệu này mô tả phạm vi triển khai của đề tài **“Xây dựng website quản lý ngân hàng đề thi”**, tập trung cho học phần bậc đại học. Hệ thống hỗ trợ quản lý nguồn câu hỏi, tạo/in đề, tổ chức lớp học và bài tập; AI là hướng mở rộng, không nằm trong phạm vi hiện tại. Có thể dán từng khối Mermaid vào [Mermaid Live](https://mermaid.live) để chỉnh sửa và xuất PNG/SVG.

## 1. Sơ đồ tuần tự – Đăng nhập

```mermaid
sequenceDiagram
    autonumber
    actor User as Người dùng
    participant FE as Frontend Angular
    participant Auth as Auth Controller
    participant Service as Auth Service
    participant Repo as User Repository
    participant DB as MySQL

    User->>FE: Nhập username và password
    FE->>Auth: POST /api/auth/login
    Auth->>Service: Kiểm tra thông tin đăng nhập
    Service->>Repo: Tìm người dùng theo username
    Repo->>DB: SELECT user
    DB-->>Repo: Thông tin người dùng
    Repo-->>Service: User hoặc không tìm thấy

    alt Tài khoản không tồn tại hoặc bị khóa
        Service-->>Auth: Lỗi đăng nhập
        Auth-->>FE: HTTP 401 + lý do
        FE-->>User: Hiển thị thông báo lỗi
    else Mật khẩu hợp lệ
        Service->>Service: So sánh password hash
        Service->>Service: Tạo JWT token
        Service-->>Auth: Token và thông tin role
        Auth-->>FE: HTTP 200 + token
        FE->>FE: Lưu token vào localStorage
        FE-->>User: Chuyển đến dashboard
    end
```

## 2. Sơ đồ tuần tự – Giáo viên tạo đề từ file và ngân hàng đề

```mermaid
sequenceDiagram
    autonumber
    actor Teacher as Giáo viên
    participant FE as Frontend Angular
    participant ExamCtl as Exam Controller
    participant ImportSvc as Import Service
    participant ExamSvc as Exam Service
    participant QuestionRepo as Question Repository
    participant ExamRepo as Exam Repository
    participant DB as MySQL

    Teacher->>FE: Nhập thông tin đề
    Teacher->>FE: Kéo thả file CSV/XLSX
    Teacher->>FE: Chọn đề nguồn tùy chọn
    Teacher->>FE: Chọn xáo câu và xáo đáp án
    FE->>ExamCtl: POST /api/exams/build

    ExamCtl->>ExamCtl: Kiểm tra quyền và dung lượng file
    ExamCtl->>ImportSvc: Đọc và kiểm tra file
    ImportSvc->>ImportSvc: Kiểm tra định dạng, tiêu đề, từng dòng
    ImportSvc->>QuestionRepo: Lưu câu hỏi hợp lệ của giáo viên
    QuestionRepo->>DB: INSERT questions và answers
    DB-->>QuestionRepo: Danh sách question_id mới
    QuestionRepo-->>ImportSvc: Các câu hỏi đã nhập

    opt Có chọn đề từ ngân hàng
        ExamCtl->>ExamSvc: Lấy câu hỏi của đề nguồn
        ExamSvc->>ExamRepo: Tìm đề và danh sách câu hỏi
        ExamRepo->>DB: SELECT exam_questions
        DB-->>ExamRepo: Câu hỏi của đề nguồn
        ExamRepo-->>ExamSvc: Danh sách câu hỏi ngân hàng
    end

    ExamCtl->>ExamSvc: Gộp câu hỏi từ file và ngân hàng
    ExamSvc->>ExamSvc: Loại câu trùng và tạo cấu hình đề
    ExamSvc->>ExamRepo: Lưu đề và các câu hỏi
    ExamRepo->>DB: INSERT exam, exam_questions, exam_classes
    DB-->>ExamRepo: Đề thi đã tạo
    ExamRepo-->>ExamCtl: Thông tin đề mới
    ExamCtl-->>FE: HTTP 201 + số câu đã gộp
    FE-->>Teacher: Hiển thị preview đề
```

## 3. Sơ đồ tuần tự – Sinh viên làm và nộp bài

```mermaid
sequenceDiagram
    autonumber
    actor Student as Sinh viên
    participant FE as Frontend Angular
    participant SubmitCtl as Submission Controller
    participant SubmitSvc as Submission Service
    participant ExamRepo as Exam Repository
    participant QuestionRepo as Question Repository
    participant DB as MySQL

    Student->>FE: Chọn đề được giao
    FE->>SubmitCtl: GET /api/exams/{id}/take
    SubmitCtl->>SubmitSvc: Kiểm tra quyền truy cập đề
    SubmitSvc->>ExamRepo: Tìm đề và lớp được giao
    ExamRepo->>DB: SELECT exam, exam_classes
    DB-->>ExamRepo: Thông tin đề

    alt Không có quyền làm bài
        SubmitSvc-->>SubmitCtl: Lỗi truy cập
        SubmitCtl-->>FE: HTTP 403
        FE-->>Student: Hiển thị thông báo không được phép
    else Được phép làm bài
        SubmitSvc->>QuestionRepo: Lấy câu hỏi và đáp án
        QuestionRepo->>DB: SELECT exam_questions, answers
        DB-->>QuestionRepo: Dữ liệu câu hỏi
        QuestionRepo-->>SubmitSvc: Câu hỏi không kèm đáp án đúng
        SubmitSvc->>SubmitSvc: Xáo câu và đáp án theo cấu hình
        SubmitCtl-->>FE: HTTP 200 + đề làm bài
        FE-->>Student: Hiển thị câu hỏi và đồng hồ
    end

    Student->>FE: Chọn đáp án và bấm Nộp bài
    FE->>SubmitCtl: POST /api/exams/{id}/submit
    SubmitCtl->>SubmitSvc: Nhận các đáp án đã chọn
    SubmitSvc->>QuestionRepo: Lấy đáp án đúng
    QuestionRepo->>DB: SELECT answers WHERE is_correct = true
    DB-->>QuestionRepo: Đáp án đúng
    SubmitSvc->>SubmitSvc: Chấm điểm và xác định đậu/rớt
    SubmitSvc->>DB: INSERT submission và submission_details
    DB-->>SubmitSvc: Lưu kết quả thành công
    SubmitCtl-->>FE: Điểm, số câu đúng, trạng thái
    FE-->>Student: Hiển thị kết quả
```

## 4. Sơ đồ hoạt động – Tạo đề thi

```mermaid
flowchart TD
    A([Bắt đầu]) --> B[Giáo viên mở chức năng Tạo đề]
    B --> C[Nhập tên, môn, thời gian, điểm đậu]
    C --> D{Có file câu hỏi?}

    D -- Có --> E[Kéo thả hoặc chọn CSV/XLSX]
    E --> F{File đúng định dạng, <= 20MB và <= 2.000 dòng?}
    F -- Không --> G[Thông báo lỗi file]
    G --> E
    F -- Có --> H[Đọc và kiểm tra từng dòng]
    H --> I{Có dòng hợp lệ?}
    I -- Không --> G
    I -- Có --> J[Lưu câu hỏi hợp lệ vào ngân hàng của giáo viên]
    D -- Không --> K[Không có câu từ file]
    J --> L
    K --> L{Có chọn đề từ ngân hàng?}

    L -- Có --> M[Chọn đề nguồn]
    M --> N[Lấy danh sách câu hỏi của đề nguồn]
    N --> O[Gộp câu hỏi từ file và ngân hàng]
    L -- Không --> P[Dùng câu hỏi từ file hoặc kho đã chọn]
    P --> Q
    O --> Q{Bật xáo trộn?}

    Q -- Xáo câu --> R[Lưu cấu hình xáo câu]
    Q -- Không --> S[Giữ thứ tự cấu hình]
    R --> T
    S --> T{Bật xáo đáp án?}
    T -- Có --> U[Lưu cấu hình xáo đáp án]
    T -- Không --> V[Giữ thứ tự đáp án]
    U --> W
    V --> W[Chọn lớp giao đề hoặc công khai]
    W --> X[Lưu đề và liên kết câu hỏi]
    X --> Y[Hiển thị preview đề]
    Y --> Z([Kết thúc])
```

## 5. Sơ đồ hoạt động – Làm bài và chấm điểm

```mermaid
flowchart TD
    A([Bắt đầu]) --> B[Sinh viên hoặc khách chọn đề]
    B --> C{Đề công khai hoặc được giao cho sinh viên?}
    C -- Không --> D[Thông báo không có quyền truy cập]
    D --> Z([Kết thúc])
    C -- Có --> E[Tải câu hỏi, ẩn đáp án đúng]
    E --> F{Đề có xáo trộn?}
    F -- Có --> G[Xáo câu và/hoặc đáp án theo cấu hình]
    F -- Không --> H[Giữ thứ tự đề]
    G --> I[Hiển thị màn hình làm bài]
    H --> I
    I --> J[Khởi động đồng hồ đếm ngược]
    J --> K[Sinh viên chọn đáp án]
    K --> L{Đã hết giờ?}
    L -- Chưa --> M{Sinh viên bấm Nộp bài?}
    M -- Chưa --> K
    M -- Có --> N[Hiển thị cảnh báo câu chưa làm]
    N --> O{Xác nhận nộp?}
    O -- Không --> K
    O -- Có --> P
    L -- Đã hết --> P[Tự động nộp bài]
    P --> Q[Đối chiếu với đáp án đúng]
    Q --> R[Tính điểm theo thang 10]
    R --> S[Lưu lượt thi và chi tiết câu trả lời]
    S --> T[Hiển thị điểm và trạng thái đậu/rớt]
    T --> Z([Kết thúc])
```

## 6. Sơ đồ tuần tự – Nộp bài tập có kiểm tra tệp và mã hóa

```mermaid
sequenceDiagram
    autonumber
    actor Student as Sinh viên
    participant FE as Angular
    participant API as Assignment API
    participant DB as MySQL
    participant Store as Kho tệp mã hóa

    Student->>FE: Chọn tệp bài nộp (tối đa 20 MB)
    FE->>API: Tạo phiên upload: tên, MIME, kích thước
    API->>API: Kiểm tra thành viên lớp, hạn nộp, định dạng
    API->>DB: Lưu phiên upload 24 giờ
    API-->>FE: sessionId, chunkSize 1 MB, totalChunks
    loop Mỗi phần tệp, tự thử lại tối đa 3 lần
        FE->>API: PUT chunk
        API->>Store: Ghi phần tệp tạm
        API-->>FE: Xác nhận phần đã nhận
    end
    FE->>API: Hoàn tất upload
    API->>API: Ghép phần tệp, đối chiếu kích thước và chữ ký tệp
    API->>API: Mã hóa AES-256-GCM
    API->>Store: Lưu tệp mã hóa ngoài web public
    API->>DB: Lưu bài nộp và nhãn đúng hạn/nộp muộn
    API-->>FE: Nộp bài thành công
```

## 7. Sơ đồ tuần tự – Kích hoạt tài khoản bằng OTP

```mermaid
sequenceDiagram
    actor User as Người dùng
    participant FE as Angular
    participant API as Auth API
    participant DB as MySQL
    participant Mail as Gmail SMTP

    User->>FE: Đăng ký tài khoản với email
    FE->>API: POST /auth/register
    API->>DB: Lưu tài khoản pending_verification
    API->>API: Sinh OTP, chỉ lưu hash và thời hạn 10 phút
    API->>Mail: Gửi OTP đến email
    Mail-->>User: Nhận mã xác minh
    User->>FE: Nhập OTP
    FE->>API: POST /auth/verify-otp
    API->>DB: Kiểm tra hash, hết hạn và số lần dùng
    API-->>FE: Kích hoạt tài khoản hoặc báo lỗi
```

## 8. Các bảng bổ sung cần thể hiện trong ERD bản nộp luận văn

```mermaid
erDiagram
    USERS ||--o{ SOURCES : "khai báo nguồn"
    SOURCES ||--o{ QUESTION_MAIN : "trích dẫn"
    CLASSES ||--o{ ASSIGNMENTS : "giao bài"
    ASSIGNMENTS ||--o{ ASSIGNMENT_SUBMISSIONS : "có bài nộp"
    USERS ||--o{ ASSIGNMENT_SUBMISSIONS : "nộp"
    ASSIGNMENTS ||--o{ UPLOAD_SESSIONS : "phiên tải lên"
    USERS ||--o{ EMAIL_OTPS : "xác minh"
    USERS ||--o{ PASSWORD_RESET_REQUESTS : "yêu cầu cấp lại"

    SOURCES { int id PK string title string url string reference_note }
    ASSIGNMENTS { int id PK int class_id FK int created_by FK string title datetime due_at datetime late_until float max_score }
    ASSIGNMENT_SUBMISSIONS { int id PK int assignment_id FK int student_id FK string stored_name string status float score }
    UPLOAD_SESSIONS { string id PK int assignment_id FK int student_id FK int total_chunks datetime expires_at }
    EMAIL_OTPS { int id PK int user_id FK string purpose string code_hash datetime expires_at }
    PASSWORD_RESET_REQUESTS { int id PK int user_id FK string status datetime requested_at }
```

## 9. Gợi ý đưa vào luận văn

- Dùng **Sơ đồ tuần tự 1** cho chức năng đăng nhập và phân quyền.
- Dùng **Sơ đồ tuần tự 2** cho chức năng tạo đề từ file và ngân hàng câu hỏi; đây là điểm nổi bật của đề tài.
- Dùng **Sơ đồ tuần tự 3** cho chức năng tổ chức thi và chấm điểm.
- Dùng **Sơ đồ hoạt động 1** cho quy trình giáo viên tạo đề.
- Dùng **Sơ đồ hoạt động 2** cho quy trình sinh viên làm bài.
- Khi xuất hình, nên dùng khổ ngang, font 12–14px, tiêu đề hình theo dạng: `Hình 3.x. Sơ đồ tuần tự chức năng ...`.
- Cập nhật tên các hình từ “Hệ thống thi trắc nghiệm” thành “Website quản lý ngân hàng đề thi đại học” để thống nhất với tên đề tài đã chốt.

## 10. ERD bám sát database triển khai

> Dùng sơ đồ này thay cho ERD khái niệm khi viết phần thiết kế cơ sở dữ liệu. Tên thực thể trùng với bảng MySQL đang chạy; có thể dán trực tiếp vào Mermaid Live để sửa và xuất hình.

```mermaid
erDiagram
    USERS ||--o{ SOURCES : creates
    USERS ||--o{ QUESTIONS : creates
    USERS ||--o{ EXAMS : creates
    USERS ||--o{ CLASSES : owns
    USERS ||--o{ CLASS_STUDENTS : joins
    USERS ||--o{ CLASS_POSTS : posts
    USERS ||--o{ SUBMISSIONS : submits
    USERS ||--o{ ASSIGNMENT_SUBMISSIONS : uploads
    USERS ||--o{ EMAIL_OTPS : verifies
    USERS ||--o{ PASSWORD_RESET_REQUESTS : requests
    USERS ||--o{ AUDIT_LOGS : acts

    SUBJECTS ||--o{ CHAPTERS : contains
    SUBJECTS ||--o{ QUESTIONS : categorizes
    SUBJECTS ||--o{ EXAMS : categorizes
    CHAPTERS ||--o{ QUESTIONS : groups
    SOURCES ||--o{ QUESTIONS : cites

    QUESTIONS ||--o{ ANSWERS : has
    QUESTIONS ||--o{ EXAM_QUESTIONS : selected
    EXAMS ||--o{ EXAM_QUESTIONS : contains
    EXAMS ||--o{ EXAM_CLASSES : assigns
    CLASSES ||--o{ EXAM_CLASSES : receives
    CLASSES ||--o{ CLASS_STUDENTS : includes
    CLASSES ||--o{ CLASS_POSTS : publishes
    CLASSES ||--o{ ASSIGNMENTS : receives

    EXAMS ||--o{ SUBMISSIONS : attempts
    SUBMISSIONS ||--o{ SUBMISSION_DETAILS : records
    QUESTIONS ||--o{ SUBMISSION_DETAILS : answered
    ANSWERS ||--o{ SUBMISSION_DETAILS : selected

    ASSIGNMENTS ||--o{ ASSIGNMENT_SUBMISSIONS : receives
    ASSIGNMENTS ||--o{ UPLOAD_SESSIONS : prepares

    USERS {
        bigint id PK
        string username
        string email
        string role
        string status
        boolean must_change_password
    }
    SUBJECTS {
        bigint id PK
        string name
        string level
        boolean is_hidden
    }
    CHAPTERS {
        bigint id PK
        bigint subject_id FK
        string name
        int order_index
    }
    SOURCES {
        bigint id PK
        bigint created_by FK
        string title
        string url
        string verification_status
        bigint reviewed_by FK
    }
    QUESTIONS {
        bigint id PK
        bigint subject_id FK
        bigint chapter_id FK
        bigint created_by FK
        bigint source_id FK
        string content_hash
        string status
        string review_status
        string source_ref
    }
    ANSWERS {
        bigint id PK
        bigint question_id FK
        string label
        boolean is_correct
        int order_index
    }
    EXAMS {
        bigint id PK
        bigint subject_id FK
        bigint created_by FK
        string title
        int duration
        string access_type
        string status
        int max_attempts
    }
    EXAM_CLASSES {
        bigint exam_id PK, FK
        bigint class_id PK, FK
    }
    EXAM_QUESTIONS {
        bigint exam_id PK, FK
        bigint question_id PK, FK
        int order_index
        float points
    }
    CLASSES {
        bigint id PK
        bigint created_by FK
        string code
        string name
        boolean is_public
    }
    CLASS_STUDENTS {
        bigint class_id PK, FK
        bigint student_id PK, FK
        datetime joined_at
    }
    CLASS_POSTS {
        bigint id PK
        bigint class_id FK
        bigint created_by FK
        text content
        datetime created_at
    }
    ASSIGNMENTS {
        bigint id PK
        bigint class_id FK
        bigint created_by FK
        string title
        datetime due_at
        datetime late_until
        float max_score
    }
    ASSIGNMENT_SUBMISSIONS {
        bigint id PK
        bigint assignment_id FK
        bigint student_id FK
        string stored_name
        string status
        float score
    }
    UPLOAD_SESSIONS {
        string id PK
        bigint assignment_id FK
        bigint student_id FK
        int total_chunks
        datetime expires_at
    }
    SUBMISSIONS {
        bigint id PK
        bigint exam_id FK
        bigint user_id FK
        string status
        float total_score
        datetime start_time
    }
    SUBMISSION_DETAILS {
        bigint id PK
        bigint submission_id FK
        bigint question_id FK
        bigint selected_answer_id FK
        boolean is_correct
    }
    EMAIL_OTPS {
        bigint id PK
        bigint user_id FK
        string purpose
        datetime expires_at
        int attempts
    }
    PASSWORD_RESET_REQUESTS {
        bigint id PK
        bigint user_id FK
        string status
        datetime approved_at
    }
    AUDIT_LOGS {
        bigint id PK
        bigint actor_user_id FK
        string action
        string entity_type
        bigint entity_id
    }
```

## 11. Hoạt động: kiểm chứng nguồn trước khi phát hành đề

```mermaid
flowchart TD
    A([Giảng viên có tài liệu thật]) --> B[Khai báo tên tài liệu, URL và vị trí tham chiếu]
    B --> C{URL là HTTP/HTTPS hợp lệ?}
    C -- Không --> D[Thông báo lỗi và yêu cầu nhập lại]
    D --> B
    C -- Có --> E[Nguồn ở trạng thái chờ xác thực]
    E --> F[Soạn hoặc import câu hỏi gắn nguồn]
    F --> G[Câu hỏi ở trạng thái nháp hoặc chờ duyệt]
    G --> H{Admin xác thực nguồn?}
    H -- Từ chối --> I[Ghi nhận từ chối, không cho phát hành]
    H -- Xác thực --> J{Admin duyệt câu hỏi?}
    J -- Từ chối --> K[Giữ câu hỏi không dùng được]
    J -- Duyệt --> L[Câu hỏi active và approved]
    L --> M[Giảng viên chọn câu để tạo đề]
    M --> N{Mọi câu đều có nguồn verified và approved?}
    N -- Không --> O[Chặn phát hành, yêu cầu bổ sung nguồn hoặc duyệt lại]
    O --> F
    N -- Có --> P[Phát hành đề private hoặc public]
    P --> Q([Sinh viên/khách có thể làm đề])
```
