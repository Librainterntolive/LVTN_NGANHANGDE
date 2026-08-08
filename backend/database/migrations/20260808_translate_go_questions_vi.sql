-- Dich 20 cau hoi go.dev sang tieng Viet.
--
-- Nguyen tac dich: giu nguyen moi thuat ngu va ma dinh danh theo nguyen ban
-- tieng Anh (module, package, slice, map, rune, defer, zero value, token...),
-- chi dich phan dien dat sang tieng Viet. Vi thuat ngu khong bi dich nen
-- khong can nguon dich rieng; dan chung chinh la trang tai lieu goc go.dev.
--
-- Doi chieu theo content_original chu khong theo id de chay dung tren may khac.
-- content_hash duoc tinh lai theo noi dung moi de chuc nang chong trung van dung.

START TRANSACTION;

-- Which command initializes a new Go module named example/hello?
UPDATE questions SET content = 'Lệnh nào khởi tạo một Go module mới có tên example/hello?', content_hash = SHA2(LOWER('Lệnh nào khởi tạo một Go module mới có tên example/hello?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/doc/tutorial/getting-started' WHERE content_original = 'Which command initializes a new Go module named example/hello?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go mod init example/hello' WHERE qq.content_original = 'Which command initializes a new Go module named example/hello?' AND a.content_original = 'go mod init example/hello';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go init example/hello' WHERE qq.content_original = 'Which command initializes a new Go module named example/hello?' AND a.content_original = 'go init example/hello';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go create module example/hello' WHERE qq.content_original = 'Which command initializes a new Go module named example/hello?' AND a.content_original = 'go create module example/hello';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go module new example/hello' WHERE qq.content_original = 'Which command initializes a new Go module named example/hello?' AND a.content_original = 'go module new example/hello';

-- Which standard-library package is imported in the official Hello World example to format and print text?
UPDATE questions SET content = 'Package nào của thư viện chuẩn được import trong ví dụ Hello World chính thức để định dạng và in văn bản?', content_hash = SHA2(LOWER('Package nào của thư viện chuẩn được import trong ví dụ Hello World chính thức để định dạng và in văn bản?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/doc/tutorial/getting-started' WHERE content_original = 'Which standard-library package is imported in the official Hello World example to format and print text?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'fmt' WHERE qq.content_original = 'Which standard-library package is imported in the official Hello World example to format and print text?' AND a.content_original = 'fmt';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'io' WHERE qq.content_original = 'Which standard-library package is imported in the official Hello World example to format and print text?' AND a.content_original = 'io';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'os' WHERE qq.content_original = 'Which standard-library package is imported in the official Hello World example to format and print text?' AND a.content_original = 'os';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'math' WHERE qq.content_original = 'Which standard-library package is imported in the official Hello World example to format and print text?' AND a.content_original = 'math';

-- When the main package is run, which function is executed by default?
UPDATE questions SET content = 'Khi chạy package main, hàm nào được thực thi mặc định?', content_hash = SHA2(LOWER('Khi chạy package main, hàm nào được thực thi mặc định?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/doc/tutorial/getting-started' WHERE content_original = 'When the main package is run, which function is executed by default?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'main' WHERE qq.content_original = 'When the main package is run, which function is executed by default?' AND a.content_original = 'main';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'start' WHERE qq.content_original = 'When the main package is run, which function is executed by default?' AND a.content_original = 'start';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'run' WHERE qq.content_original = 'When the main package is run, which function is executed by default?' AND a.content_original = 'run';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'init' WHERE qq.content_original = 'When the main package is run, which function is executed by default?' AND a.content_original = 'init';

-- Which command runs the current module in the official getting-started tutorial?
UPDATE questions SET content = 'Theo hướng dẫn getting-started chính thức, lệnh nào chạy module hiện tại?', content_hash = SHA2(LOWER('Theo hướng dẫn getting-started chính thức, lệnh nào chạy module hiện tại?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/doc/tutorial/getting-started' WHERE content_original = 'Which command runs the current module in the official getting-started tutorial?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go run .' WHERE qq.content_original = 'Which command runs the current module in the official getting-started tutorial?' AND a.content_original = 'go run .';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go build .' WHERE qq.content_original = 'Which command runs the current module in the official getting-started tutorial?' AND a.content_original = 'go build .';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go execute .' WHERE qq.content_original = 'Which command runs the current module in the official getting-started tutorial?' AND a.content_original = 'go execute .';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go start .' WHERE qq.content_original = 'Which command runs the current module in the official getting-started tutorial?' AND a.content_original = 'go start .';

-- Which command lists available Go commands?
UPDATE questions SET content = 'Lệnh nào liệt kê các lệnh Go hiện có?', content_hash = SHA2(LOWER('Lệnh nào liệt kê các lệnh Go hiện có?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/doc/tutorial/getting-started' WHERE content_original = 'Which command lists available Go commands?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go help' WHERE qq.content_original = 'Which command lists available Go commands?' AND a.content_original = 'go help';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go list' WHERE qq.content_original = 'Which command lists available Go commands?' AND a.content_original = 'go list';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go commands' WHERE qq.content_original = 'Which command lists available Go commands?' AND a.content_original = 'go commands';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'go info' WHERE qq.content_original = 'Which command lists available Go commands?' AND a.content_original = 'go info';

-- Which Go statement specifies repeated execution of a block?
UPDATE questions SET content = 'Câu lệnh nào trong Go chỉ định việc thực thi lặp lại một khối lệnh?', content_hash = SHA2(LOWER('Câu lệnh nào trong Go chỉ định việc thực thi lặp lại một khối lệnh?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'Which Go statement specifies repeated execution of a block?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'for' WHERE qq.content_original = 'Which Go statement specifies repeated execution of a block?' AND a.content_original = 'for';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'repeat' WHERE qq.content_original = 'Which Go statement specifies repeated execution of a block?' AND a.content_original = 'repeat';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'loop' WHERE qq.content_original = 'Which Go statement specifies repeated execution of a block?' AND a.content_original = 'loop';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'while' WHERE qq.content_original = 'Which Go statement specifies repeated execution of a block?' AND a.content_original = 'while';

-- What value does a variable have before it has been assigned a value?
UPDATE questions SET content = 'Một biến mang giá trị gì trước khi được gán giá trị?', content_hash = SHA2(LOWER('Một biến mang giá trị gì trước khi được gán giá trị?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'What value does a variable have before it has been assigned a value?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Zero value ứng với kiểu của biến' WHERE qq.content_original = 'What value does a variable have before it has been assigned a value?' AND a.content_original = 'The zero value for its type';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Luôn là null' WHERE qq.content_original = 'What value does a variable have before it has been assigned a value?' AND a.content_original = 'Always null';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Luôn là undefined' WHERE qq.content_original = 'What value does a variable have before it has been assigned a value?' AND a.content_original = 'Always undefined';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Giá trị của biến trước đó' WHERE qq.content_original = 'What value does a variable have before it has been assigned a value?' AND a.content_original = 'The value of the previous variable';

-- When ranging over a map with two variables, what is assigned first?
UPDATE questions SET content = 'Khi duyệt một map bằng range với hai biến, giá trị nào được gán trước?', content_hash = SHA2(LOWER('Khi duyệt một map bằng range với hai biến, giá trị nào được gán trước?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'When ranging over a map with two variables, what is assigned first?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Key' WHERE qq.content_original = 'When ranging over a map with two variables, what is assigned first?' AND a.content_original = 'The key';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Value' WHERE qq.content_original = 'When ranging over a map with two variables, what is assigned first?' AND a.content_original = 'The value';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Độ dài của map' WHERE qq.content_original = 'When ranging over a map with two variables, what is assigned first?' AND a.content_original = 'The map length';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Địa chỉ của map' WHERE qq.content_original = 'When ranging over a map with two variables, what is assigned first?' AND a.content_original = 'The address of the map';

-- What is for { } equivalent to according to the Go specification?
UPDATE questions SET content = 'Theo Go specification, for { } tương đương với dạng nào?', content_hash = SHA2(LOWER('Theo Go specification, for { } tương đương với dạng nào?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'What is for { } equivalent to according to the Go specification?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'for true { }' WHERE qq.content_original = 'What is for { } equivalent to according to the Go specification?' AND a.content_original = 'for true { }';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'for false { }' WHERE qq.content_original = 'What is for { } equivalent to according to the Go specification?' AND a.content_original = 'for false { }';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'while true { }' WHERE qq.content_original = 'What is for { } equivalent to according to the Go specification?' AND a.content_original = 'while true { }';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'repeat { }' WHERE qq.content_original = 'What is for { } equivalent to according to the Go specification?' AND a.content_original = 'repeat { }';

-- For a slice range with two variables, what does the first variable receive?
UPDATE questions SET content = 'Khi duyệt một slice bằng range với hai biến, biến đầu tiên nhận giá trị gì?', content_hash = SHA2(LOWER('Khi duyệt một slice bằng range với hai biến, biến đầu tiên nhận giá trị gì?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'For a slice range with two variables, what does the first variable receive?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Index của phần tử' WHERE qq.content_original = 'For a slice range with two variables, what does the first variable receive?' AND a.content_original = 'The index';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Chỉ giá trị của phần tử' WHERE qq.content_original = 'For a slice range with two variables, what does the first variable receive?' AND a.content_original = 'The element value only';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Capacity của slice' WHERE qq.content_original = 'For a slice range with two variables, what does the first variable receive?' AND a.content_original = 'The slice capacity';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Địa chỉ bộ nhớ' WHERE qq.content_original = 'For a slice range with two variables, what does the first variable receive?' AND a.content_original = 'The memory address';

-- Which token is used for a Go short variable declaration?
UPDATE questions SET content = 'Token nào được dùng cho short variable declaration trong Go?', content_hash = SHA2(LOWER('Token nào được dùng cho short variable declaration trong Go?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'Which token is used for a Go short variable declaration?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = ':=' WHERE qq.content_original = 'Which token is used for a Go short variable declaration?' AND a.content_original = ':=';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = '=' WHERE qq.content_original = 'Which token is used for a Go short variable declaration?' AND a.content_original = '=';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = '::=' WHERE qq.content_original = 'Which token is used for a Go short variable declaration?' AND a.content_original = '::=';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = '=>' WHERE qq.content_original = 'Which token is used for a Go short variable declaration?' AND a.content_original = '=>';

-- Where may Go short variable declarations appear?
UPDATE questions SET content = 'Short variable declaration trong Go được phép xuất hiện ở đâu?', content_hash = SHA2(LOWER('Short variable declaration trong Go được phép xuất hiện ở đâu?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'Where may Go short variable declarations appear?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Chỉ bên trong hàm' WHERE qq.content_original = 'Where may Go short variable declarations appear?' AND a.content_original = 'Only inside functions';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Chỉ ở cấp package' WHERE qq.content_original = 'Where may Go short variable declarations appear?' AND a.content_original = 'Only at package level';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Chỉ bên trong khai báo struct' WHERE qq.content_original = 'Where may Go short variable declarations appear?' AND a.content_original = 'Only inside struct declarations';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Bất cứ nơi nào có tên biến' WHERE qq.content_original = 'Where may Go short variable declarations appear?' AND a.content_original = 'Anywhere a variable name appears';

-- When is a function call scheduled with defer invoked?
UPDATE questions SET content = 'Lời gọi hàm được đăng ký bằng defer sẽ được thực thi khi nào?', content_hash = SHA2(LOWER('Lời gọi hàm được đăng ký bằng defer sẽ được thực thi khi nào?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'When is a function call scheduled with defer invoked?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Ngay trước khi hàm bao quanh trả về' WHERE qq.content_original = 'When is a function call scheduled with defer invoked?' AND a.content_original = 'Immediately before the surrounding function returns';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Khi bắt đầu hàm bao quanh' WHERE qq.content_original = 'When is a function call scheduled with defer invoked?' AND a.content_original = 'At the start of the surrounding function';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Ở chu kỳ garbage collection kế tiếp' WHERE qq.content_original = 'When is a function call scheduled with defer invoked?' AND a.content_original = 'At the next garbage collection cycle';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Chỉ sau khi chương trình kết thúc' WHERE qq.content_original = 'When is a function call scheduled with defer invoked?' AND a.content_original = 'Only after program termination';

-- In what order are multiple deferred function calls invoked?
UPDATE questions SET content = 'Nhiều lời gọi hàm được defer sẽ được thực thi theo thứ tự nào?', content_hash = SHA2(LOWER('Nhiều lời gọi hàm được defer sẽ được thực thi theo thứ tự nào?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'In what order are multiple deferred function calls invoked?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Ngược với thứ tự các câu lệnh defer' WHERE qq.content_original = 'In what order are multiple deferred function calls invoked?' AND a.content_original = 'Reverse order of defer statements';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Theo thứ tự trong file mã nguồn' WHERE qq.content_original = 'In what order are multiple deferred function calls invoked?' AND a.content_original = 'Source-file order';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Theo thứ tự bảng chữ cái của tên hàm' WHERE qq.content_original = 'In what order are multiple deferred function calls invoked?' AND a.content_original = 'Alphabetical function-name order';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Thứ tự ngẫu nhiên' WHERE qq.content_original = 'In what order are multiple deferred function calls invoked?' AND a.content_original = 'Random order';

-- What is true about the contents of a Go string after it is created?
UPDATE questions SET content = 'Điều nào đúng về nội dung của một string trong Go sau khi đã được tạo?', content_hash = SHA2(LOWER('Điều nào đúng về nội dung của một string trong Go sau khi đã được tạo?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'What is true about the contents of a Go string after it is created?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Không thể thay đổi được nữa' WHERE qq.content_original = 'What is true about the contents of a Go string after it is created?' AND a.content_original = 'They cannot be changed';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Có thể thay đổi từng byte một' WHERE qq.content_original = 'What is true about the contents of a Go string after it is created?' AND a.content_original = 'They can be changed one byte at a time';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Luôn chỉ chứa các rune Unicode' WHERE qq.content_original = 'What is true about the contents of a Go string after it is created?' AND a.content_original = 'They always contain Unicode runes only';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Luôn kết thúc bằng một byte null' WHERE qq.content_original = 'What is true about the contents of a Go string after it is created?' AND a.content_original = 'They always end with a null byte';

-- Which character encoding is required for Go source text?
UPDATE questions SET content = 'Mã nguồn Go bắt buộc phải dùng bảng mã ký tự nào?', content_hash = SHA2(LOWER('Mã nguồn Go bắt buộc phải dùng bảng mã ký tự nào?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'Which character encoding is required for Go source text?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'UTF-8' WHERE qq.content_original = 'Which character encoding is required for Go source text?' AND a.content_original = 'UTF-8';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'UTF-16' WHERE qq.content_original = 'Which character encoding is required for Go source text?' AND a.content_original = 'UTF-16';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Chỉ ASCII' WHERE qq.content_original = 'Which character encoding is required for Go source text?' AND a.content_original = 'ASCII only';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'ISO-8859-1' WHERE qq.content_original = 'Which character encoding is required for Go source text?' AND a.content_original = 'ISO-8859-1';

-- Which prefix denotes a binary integer literal in Go?
UPDATE questions SET content = 'Tiền tố nào biểu thị một binary integer literal trong Go?', content_hash = SHA2(LOWER('Tiền tố nào biểu thị một binary integer literal trong Go?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'Which prefix denotes a binary integer literal in Go?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = '0b hoặc 0B' WHERE qq.content_original = 'Which prefix denotes a binary integer literal in Go?' AND a.content_original = '0b or 0B';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = '0d hoặc 0D' WHERE qq.content_original = 'Which prefix denotes a binary integer literal in Go?' AND a.content_original = '0d or 0D';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = '0n hoặc 0N' WHERE qq.content_original = 'Which prefix denotes a binary integer literal in Go?' AND a.content_original = '0n or 0N';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'b0' WHERE qq.content_original = 'Which prefix denotes a binary integer literal in Go?' AND a.content_original = 'b0';

-- What default type does the untyped integer constant have in i := 0?
UPDATE questions SET content = 'Trong i := 0, hằng số nguyên untyped có kiểu mặc định là gì?', content_hash = SHA2(LOWER('Trong i := 0, hằng số nguyên untyped có kiểu mặc định là gì?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'What default type does the untyped integer constant have in i := 0?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'int' WHERE qq.content_original = 'What default type does the untyped integer constant have in i := 0?' AND a.content_original = 'int';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'int64' WHERE qq.content_original = 'What default type does the untyped integer constant have in i := 0?' AND a.content_original = 'int64';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'float64' WHERE qq.content_original = 'What default type does the untyped integer constant have in i := 0?' AND a.content_original = 'float64';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'byte' WHERE qq.content_original = 'What default type does the untyped integer constant have in i := 0?' AND a.content_original = 'byte';

-- In a range over a string with two iteration variables, what does the second variable receive?
UPDATE questions SET content = 'Khi duyệt một string bằng range với hai biến lặp, biến thứ hai nhận giá trị gì?', content_hash = SHA2(LOWER('Khi duyệt một string bằng range với hai biến lặp, biến thứ hai nhận giá trị gì?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'In a range over a string with two iteration variables, what does the second variable receive?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Một rune' WHERE qq.content_original = 'In a range over a string with two iteration variables, what does the second variable receive?' AND a.content_original = 'A rune';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Chỉ là byte offset' WHERE qq.content_original = 'In a range over a string with two iteration variables, what does the second variable receive?' AND a.content_original = 'A byte offset only';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Một string slice' WHERE qq.content_original = 'In a range over a string with two iteration variables, what does the second variable receive?' AND a.content_original = 'A string slice';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Capacity của string' WHERE qq.content_original = 'In a range over a string with two iteration variables, what does the second variable receive?' AND a.content_original = 'The string capacity';

-- How many iterations does a range loop perform over a nil slice?
UPDATE questions SET content = 'Vòng lặp range duyệt một nil slice sẽ chạy bao nhiêu lần lặp?', content_hash = SHA2(LOWER('Vòng lặp range duyệt một nil slice sẽ chạy bao nhiêu lần lặp?'), 256), translation_status = 'translated', original_language = 'en', translation_refs = 'Giu nguyen thuat ngu va ma dinh danh theo nguyen ban tieng Anh, chi dich phan dien dat.
Nguyen ban: https://go.dev/ref/spec' WHERE content_original = 'How many iterations does a range loop perform over a nil slice?';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Không lần nào' WHERE qq.content_original = 'How many iterations does a range loop perform over a nil slice?' AND a.content_original = 'Zero';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Một lần' WHERE qq.content_original = 'How many iterations does a range loop perform over a nil slice?' AND a.content_original = 'One';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Bằng capacity của slice' WHERE qq.content_original = 'How many iterations does a range loop perform over a nil slice?' AND a.content_original = 'The slice capacity';
UPDATE answers a JOIN questions qq ON qq.id = a.question_id SET a.content = 'Panic trước khi kịp lặp' WHERE qq.content_original = 'How many iterations does a range loop perform over a nil slice?' AND a.content_original = 'It panics before iterating';

COMMIT;
