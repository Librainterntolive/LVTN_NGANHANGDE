package router

import (
	"quiz-backend/internal/controller"
	"quiz-backend/internal/repository"
	"quiz-backend/internal/service"
	"quiz-backend/middleware"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// Setup lắp ráp repository -> service -> controller và khai báo route
func Setup(r *gin.Engine, db *gorm.DB) {
	// ===== Repository =====
	userRepo := repository.NewUserRepository(db)
	subjectRepo := repository.NewSubjectRepository(db)
	questionRepo := repository.NewQuestionRepository(db)
	chapterRepo := repository.NewChapterRepository(db)
	classRepo := repository.NewClassRepository(db)
	examRepo := repository.NewExamRepository(db)
	submissionRepo := repository.NewSubmissionRepository(db)
	statsRepo := repository.NewStatsRepository(db)
	folderRepo := repository.NewFolderRepository(db)
	practiceRepo := repository.NewPracticeRepository(db)

	// ===== Service =====
	authSvc := service.NewAuthService(userRepo)
	userSvc := service.NewUserService(userRepo)
	subjectSvc := service.NewSubjectService(subjectRepo)
	questionSvc := service.NewQuestionService(questionRepo, userRepo, chapterRepo)
	chapterSvc := service.NewChapterService(chapterRepo)
	classSvc := service.NewClassService(classRepo, userRepo)
	examSvc := service.NewExamService(examRepo, questionRepo)
	submissionSvc := service.NewSubmissionService(submissionRepo, examRepo, questionRepo)
	importSvc := service.NewImportService(questionRepo)
	statsSvc := service.NewStatsService(statsRepo)
	folderSvc := service.NewFolderService(folderRepo)
	practiceSvc := service.NewPracticeService(practiceRepo, questionRepo, folderRepo)

	// ===== Controller =====
	authCtl := controller.NewAuthController(authSvc)
	userCtl := controller.NewUserController(userSvc)
	subjectCtl := controller.NewSubjectController(subjectSvc)
	questionCtl := controller.NewQuestionController(questionSvc)
	chapterCtl := controller.NewChapterController(chapterSvc)
	classCtl := controller.NewClassController(classSvc)
	examCtl := controller.NewExamController(examSvc, importSvc)
	submissionCtl := controller.NewSubmissionController(submissionSvc)
	importCtl := controller.NewImportController(importSvc)
	statsCtl := controller.NewStatsController(statsSvc)
	folderCtl := controller.NewFolderController(folderSvc)
	practiceCtl := controller.NewPracticeController(practiceSvc)

	// ===== Routes =====
	r.GET("/api/ping", func(c *gin.Context) { c.JSON(200, gin.H{"message": "pong"}) })

	api := r.Group("/api")

	// --- Công khai ---
	api.POST("/auth/register", authCtl.Register)
	api.POST("/auth/login", authCtl.Login)
	api.GET("/subjects", subjectCtl.GetAll)
	api.GET("/subjects/:id", subjectCtl.GetByID)
	api.GET("/public-exams", examCtl.GetPublic) // đề công khai cho khách dùng thử

	// --- Admin + Teacher ---
	staff := api.Group("")
	staff.Use(middleware.AuthRequired(), middleware.RequireRole("Admin", "Teacher"))
	{
		staff.POST("/subjects", subjectCtl.Create)
		staff.PUT("/subjects/:id", subjectCtl.Update)
		staff.DELETE("/subjects/:id", subjectCtl.Delete)

		staff.GET("/questions", questionCtl.GetAll)
		staff.GET("/questions/:id", questionCtl.GetByID)
		staff.POST("/questions", questionCtl.Create)
		staff.PUT("/questions/:id", questionCtl.Update)
		staff.DELETE("/questions/:id", questionCtl.Delete)
		staff.POST("/questions/import", importCtl.Import)
		staff.GET("/questions/import-template", importCtl.Template)

		// Chương/chủ đề của môn học
		staff.GET("/chapters", chapterCtl.GetAll) // ?subject_id=
		staff.POST("/chapters", chapterCtl.Create)
		staff.PUT("/chapters/:id", chapterCtl.Update)
		staff.DELETE("/chapters/:id", chapterCtl.Delete)

		staff.GET("/classes", classCtl.GetAll)
		staff.GET("/classes/assignable", classCtl.Assignable)
		staff.POST("/classes", classCtl.Create)
		staff.PUT("/classes/:id", classCtl.Update)
		staff.DELETE("/classes/:id", classCtl.Delete)
		staff.GET("/classes/:id/students", classCtl.GetStudents)
		staff.GET("/classes/:id/exams", classCtl.GetExams) // đề đã giao cho lớp
		staff.POST("/classes/:id/students", classCtl.AddStudent)
		staff.DELETE("/classes/:id/students/:studentId", classCtl.RemoveStudent)

		staff.GET("/exams", examCtl.GetAll)
		staff.GET("/exams/:id", examCtl.GetDetail)
		staff.GET("/exams/:id/preview", examCtl.Preview)
		staff.POST("/exams", examCtl.Create)
		staff.POST("/exams/build", examCtl.Build)
		staff.POST("/exams/generate", examCtl.Generate) // sinh đề theo ma trận
		staff.POST("/exams/:id/clone", examCtl.Clone)   // nhân bản đề về của mình
		staff.PUT("/exams/:id", examCtl.Update)
		staff.DELETE("/exams/:id", examCtl.Delete)

		// Thống kê (mục 5)
		staff.GET("/stats/overview", statsCtl.Overview)
		staff.GET("/stats/exams", statsCtl.ExamStats)
	}

	// --- Chỉ Admin ---
	adminOnly := api.Group("")
	adminOnly.Use(middleware.AuthRequired(), middleware.RequireRole("Admin"))
	{
		adminOnly.GET("/users", userCtl.GetAll)
		adminOnly.POST("/users", userCtl.Create)
		adminOnly.PUT("/users/:id", userCtl.Update)
		adminOnly.DELETE("/users/:id", userCtl.Delete)
	}

	// --- Sinh viên đã đăng nhập ---
	stu := api.Group("")
	stu.Use(middleware.AuthRequired())
	{
		stu.GET("/my-exams", submissionCtl.GetMyExams)
		stu.GET("/my-submissions", submissionCtl.GetMySubmissions)
		stu.POST("/join-class", classCtl.Join)     // SV tham gia lớp bằng mã
		stu.GET("/my-classes", classCtl.MyClasses) // lớp SV đã tham gia

		// Kho cá nhân (cây thư mục lưu đề) - mọi người đăng nhập đều có
		stu.GET("/exam-bank", examCtl.GetBank) // ngân hàng đề đã phát hành
		stu.GET("/folders", folderCtl.GetMine)
		stu.POST("/folders", folderCtl.Create)
		stu.PUT("/folders/:id", folderCtl.Rename)
		stu.DELETE("/folders/:id", folderCtl.Delete)
		stu.GET("/folders/:id/exams", folderCtl.GetExams)
		stu.POST("/folders/:id/exams", folderCtl.AddExam)
		stu.DELETE("/folders/:id/exams/:examId", folderCtl.RemoveExam)
		stu.PUT("/folders/:id/exams/:examId/note", folderCtl.SetNote) // ghi chú cá nhân
		stu.GET("/saved-exams", folderCtl.SavedExamIDs)               // id đề đã lưu (badge)

		// Sổ tay câu sai + thống kê góc học tập
		stu.GET("/practice/wrong-questions", practiceCtl.Notebook)
		stu.GET("/practice/wrong-questions/take", practiceCtl.Take)
		stu.POST("/practice/wrong-questions/submit", practiceCtl.Submit)
		stu.GET("/my-stats", practiceCtl.MyStats)
	}

	// --- Làm bài: cho cả khách ---
	open := api.Group("")
	open.Use(middleware.OptionalAuth())
	{
		open.GET("/exams/:id/take", submissionCtl.Take)
		open.POST("/exams/:id/submit", submissionCtl.Submit)
	}
}
