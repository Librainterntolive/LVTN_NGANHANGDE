import { Component, OnInit, inject, signal } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { StatsService, Overview, ExamStat } from '../../services/stats.service';
import { I18nService } from '../../services/i18n.service';
import { ClassService, AppClass } from '../../services/class.service';
import { AssignmentService, ClassSubmissionStat, ClassSubmissionSummary } from '../../services/assignment.service';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';

@Component({
  selector: 'app-stats',
  imports: [FormsModule, RouterLink, DecimalPipe, InfiniteScrollDirective],
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
  examStatsPage = 1;
  examStatsLoading = signal(false);
  classes = signal<AppClass[]>([]);
  classTotal = signal(0);
  classPage = 1;
  classesLoading = signal(false);
  classStats = signal<ClassSubmissionStat[]>([]);
  classStatsTotal = signal(0);
  classStatsSummary = signal<ClassSubmissionSummary | null>(null);
  classStatsPage = 1;
  classStatsLoading = signal(false);
  selectedClassId = 0;

  ngOnInit() {
    this.overviewLoading.set(true);
    this.service.getOverview().subscribe({ next: data => { this.overview.set(data); this.overviewLoading.set(false); }, error: () => { this.overviewLoading.set(false); this.showError('Không tải được số liệu tổng quan.'); } });
    this.loadExamStats();
    this.loadMoreClasses();
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

  loadExamStats(reset = true) {
    if (this.examStatsLoading()) return;
    const page = reset ? 1 : this.examStatsPage + 1;
    if (reset) { this.examStats.set([]); this.examStatsTotal.set(0); }
    this.examStatsLoading.set(true);
    this.service.getExamStatsPaged(page).subscribe({
      next: data => { this.examStats.set(reset ? (data.items ?? []) : [...this.examStats(), ...(data.items ?? [])]); this.examStatsTotal.set(data.total ?? 0); this.examStatsPage = page; this.examStatsLoading.set(false); },
      error: () => { this.examStatsLoading.set(false); this.showError('Không tải được thống kê theo đề thi.'); },
    });
  }

  hasMoreExamStats() { return this.examStats().length < this.examStatsTotal(); }

  loadMoreClasses() {
    if (this.classesLoading() || (this.classTotal() > 0 && this.classes().length >= this.classTotal())) return;
    this.classesLoading.set(true);
    this.classesApi.getPaged(this.classPage, 12).subscribe({
      next: (data) => {
        this.classes.update(items => [...items, ...(data.items ?? [])]);
        this.classTotal.set(data.total ?? 0);
        this.classPage++;
        this.classesLoading.set(false);
      },
      error: () => { this.classesLoading.set(false); this.showError('Không tải được danh sách lớp học.'); },
    });
  }

  loadClassStats(reset = true) {
    if (!this.selectedClassId || this.classStatsLoading()) return;
    const page = reset ? 1 : this.classStatsPage + 1;
    if (reset) { this.classStats.set([]); this.classStatsTotal.set(0); this.classStatsSummary.set(null); }
    this.classStatsLoading.set(true);
    this.assignmentsApi.classStatsPaged(this.selectedClassId, page).subscribe({
      next: result => { this.classStats.set(reset ? (result.items ?? []) : [...this.classStats(), ...(result.items ?? [])]); this.classStatsTotal.set(result.total ?? 0); this.classStatsSummary.set(result.summary ?? null); this.classStatsPage = page; this.classStatsLoading.set(false); },
      error: () => { this.classStatsLoading.set(false); this.showError('Không tải được thống kê lớp học.'); },
    });
  }

  hasMoreClassStats() { return this.classStats().length < this.classStatsTotal(); }

  private showError(message: string) {
    this.error.set(message);
  }
}
