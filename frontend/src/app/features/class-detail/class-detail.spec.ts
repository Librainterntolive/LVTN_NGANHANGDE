import { Assignment } from '../../services/assignment.service';
import { assignmentFormError } from './class-detail';

describe('assignmentFormError', () => {
  const validAssignment: Assignment = {
    class_id: 1,
    title: 'Bài tập tuần 1',
    due_at: '2026-08-20T10:00',
    late_until: '2026-08-21T10:00',
    max_score: 10,
  };

  it('rejects a late deadline that is not after the due date', () => {
    expect(assignmentFormError({ ...validAssignment, late_until: '2026-08-20T10:00' }))
      .toBe('Thời điểm nộp muộn phải sau hạn nộp.');
  });

  it('accepts a complete assignment form', () => {
    expect(assignmentFormError(validAssignment)).toBeNull();
  });
});
