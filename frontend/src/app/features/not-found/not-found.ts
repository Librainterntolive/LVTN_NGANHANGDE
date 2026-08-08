import { Component, inject } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { Location } from '@angular/common';
import { Icon } from '../../shared/icon';

// Trang báo đường dẫn không tồn tại.
// Không có trang này thì gõ sai URL sẽ ra màn hình trắng.
@Component({
  selector: 'app-not-found',
  imports: [RouterLink, Icon],
  templateUrl: './not-found.html',
})
export class NotFound {
  private location = inject(Location);
  path = inject(Router).url;

  back() {
    this.location.back();
  }
}
