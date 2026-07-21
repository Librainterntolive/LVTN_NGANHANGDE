import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ClassService, AppClass } from '../../services/class.service';

@Component({
  selector: 'app-my-classes',
  imports: [FormsModule],
  templateUrl: './my-classes.html',
})
export class MyClasses implements OnInit {
  private service = inject(ClassService);

  classes = signal<AppClass[]>([]);
  code = '';
  message = signal<string>('');
  error = signal<string>('');

  ngOnInit() { this.load(); }

  load() {
    this.service.getMyClasses().subscribe({
      next: (d) => this.classes.set(d ?? []),
      error: () => {},
    });
  }

  join() {
    this.message.set(''); this.error.set('');
    if (!this.code.trim()) { this.error.set('Nhập mã lớp'); return; }
    this.service.joinByCode(this.code.trim().toUpperCase()).subscribe({
      next: () => { this.message.set('Tham gia lớp thành công!'); this.code = ''; this.load(); },
      error: (e) => this.error.set(e?.error?.error ?? 'Mã lớp không đúng'),
    });
  }
}
