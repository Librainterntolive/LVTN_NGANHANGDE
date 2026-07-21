import { Component, OnInit, inject, signal } from '@angular/core';
import { StatsService, Overview, ExamStat } from '../../services/stats.service';
import { I18nService } from '../../services/i18n.service';

@Component({
  selector: 'app-stats',
  imports: [],
  templateUrl: './stats.html',
})
export class Stats implements OnInit {
  private service = inject(StatsService);
  protected i18n = inject(I18nService);

  overview = signal<Overview | null>(null);
  examStats = signal<ExamStat[]>([]);

  ngOnInit() {
    this.service.getOverview().subscribe((d) => this.overview.set(d));
    this.service.getExamStats().subscribe((d) => this.examStats.set(d ?? []));
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
}
