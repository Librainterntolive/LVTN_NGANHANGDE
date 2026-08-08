package service

import (
	"reflect"
	"testing"
	"time"

	"quiz-backend/internal/entity"
)

func TestGuestTrialQuestionIDsUsesStableLimitedSet(testingContext *testing.T) {
	questionIDs := make([]uint, 25)
	for questionIndex := range questionIDs {
		questionIDs[questionIndex] = uint(questionIndex + 1)
	}
	exam := &entity.Exam{ID: 42, Shuffle: true}
	first := guestTrialQuestionIDs(exam, questionIDs)
	second := guestTrialQuestionIDs(exam, questionIDs)
	if len(first) != guestQuestionLimit {
		testingContext.Fatalf("expected %d questions, got %d", guestQuestionLimit, len(first))
	}
	if !reflect.DeepEqual(first, second) {
		testingContext.Fatal("guest trial question set must remain stable between take and submit")
	}
	expectedQuestionIDs := make([]uint, 25)
	for questionIndex := range expectedQuestionIDs {
		expectedQuestionIDs[questionIndex] = uint(questionIndex + 1)
	}
	if !reflect.DeepEqual(questionIDs, expectedQuestionIDs) {
		testingContext.Fatal("guest question selection must not modify the original question IDs")
	}
}

func TestRemainingSecondsReturnsZeroForExpiredAttempt(t *testing.T) {
	exam := &entity.Exam{Duration: 1}
	submission := &entity.Submission{StartTime: time.Now().Add(-2 * time.Minute)}
	if remaining := remainingSeconds(exam, submission); remaining != 0 {
		t.Fatalf("remainingSeconds() = %d, want 0", remaining)
	}
}

func TestSubmitResultFromSubmissionRestoresOnlySafeResultFields(t *testing.T) {
	submission := &entity.Submission{ID: 28, TotalScore: 7.5, IsPassed: true}
	result := submitResultFromSubmission(submission, 12)

	if result.SubmissionID != 28 || result.Total != 12 || result.Correct != 9 || result.Score != 7.5 || !result.IsPassed {
		t.Fatalf("unexpected restored result: %+v", result)
	}
}
