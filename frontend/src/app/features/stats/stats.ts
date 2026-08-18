import { Component, OnInit, inject, signal } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { StatsService, Overview, ExamStat } from '../../services/stats.service';
import { I18nService } from '../../services/i18n.service';
import { ClassService, AppClass } from '../../services/class.service';
import { AssignmentService, ClassSubmissionStat, ClassSubmissionSummary } from '../../services/assignment.service';
import { Paginator } from '../../shared/paginator';
import { SearchableSelect } from '../../shared/searchable-select';
import { Icon } from '../../shared/icon';

@Component({
  selector: 'app-stats',
  imports: [FormsModule, DecimalPipe, Paginator, SearchableSelect, Icon],
  templateUrl: './stats.html',
})
export class Stats implements OnInit {
  private service = inject(StatsService);
  private classesApi = inject(ClassService);
  private assignmentsApi = inject(AssignmentService);
  protected i18n = inject(I18nService);

  overview = signal<Overview | null>(null);
  overviewLoading = signal(false);
  error = signal('');
  examStats = signal<ExamStat[]>([]);
  examStatsTotal = signal(0);
  examStatsPage = signal(1);
  examStatsLimit = signal(10);
  examStatsLoading = signal(false);
  selectedClassName = signal('');
  classStats = signal<ClassSubmissionStat[]>([]);
  classStatsTotal = signal(0);
  classStatsSummary = signal<ClassSubmissionSummary | null>(null);
  classStatsPage = signal(1);
  classStatsLimit = signal(10);
  classStatsLoading = signal(false);
  selectedClassId = 0;

  ngOnInit() {
    this.overviewLoading.set(true);
    this.service.getOverview().subscribe({ next: data => { this.overview.set(data); this.overviewLoading.set(false); }, error: () => { this.overviewLoading.set(false); this.showError('Không tải được số liệu tổng quan.'); } });
    this.loadExamStats();
  }

  round(n: number): number {
    return Math.round(n * 10) / 10;
  }

  // tối đa 10 đề gần nhất cho biểu đồ cột
  bars(): ExamStat[] {
    return this.examStats().slice(0, 10);
  }

  // chiều cao cột theo điểm TB (thang 10 -> tối đa 150px)
  barH(s: ExamStat): number {
    return Math.max(4, (s.avg_score / 10) * 150);
  }

  loadExamStats() {
    if (this.examStatsLoading()) return;
    this.examStatsLoading.set(true);
    this.service.getExamStatsPaged(this.examStatsPage(), this.examStatsLimit()).subscribe({
      next: data => {
        this.examStats.set(data.items ?? []);
        this.examStatsTotal.set(data.total ?? 0);
        this.examStatsLoading.set(false);
      },
      error: () => { this.examStatsLoading.set(false); this.showError('Không tải được thống kê theo đề thi.'); },
    });
  }

  goToExamStatsPage(page: number) { this.examStatsPage.set(page); this.loadExamStats(); }
  setExamStatsLimit(limit: number) { this.examStatsLimit.set(limit); this.examStatsPage.set(1); this.loadExamStats(); }

  // Combobox lop hoc goi thang API theo tu khoa nen khong phu thuoc so luong lop.
  fetchClasses = (keyword: string, page: number, limit: number) =>
    this.classesApi.getPaged(page, limit, keyword);

  onClassChange() {
    this.classStatsPage.set(1);
    this.classStats.set([]);
    this.classStatsTotal.set(0);
    this.classStatsSummary.set(null);
    this.loadClassStats();
  }

  loadClassStats() {
    if (!this.selectedClassId || this.classStatsLoading()) return;
    this.classStatsLoading.set(true);
    this.assignmentsApi.classStatsPaged(this.selectedClassId, this.classStatsPage(), this.classStatsLimit()).subscribe({
      next: result => {
        this.classStats.set(result.items ?? []);
        this.classStatsTotal.set(result.total ?? 0);
        this.classStatsSummary.set(result.summary ?? null);
        this.classStatsLoading.set(false);
      },
      error: () => { this.classStatsLoading.set(false); this.showError('Không tải được thống kê lớp học.'); },
    });
  }

  goToClassStatsPage(page: number) { this.classStatsPage.set(page); this.loadClassStats(); }
  setClassStatsLimit(limit: number) { this.classStatsLimit.set(limit); this.classStatsPage.set(1); this.loadClassStats(); }

  private showError(message: string) {
    this.error.set(message);
  }
}
