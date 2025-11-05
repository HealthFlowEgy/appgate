import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';

export interface MenuItem {
  title: string;
  icon?: string;
  link?: string;
  children?: MenuItem[];
  data?: any;
  expanded?: boolean;
}

@Component({
  selector: 'ngx-material-menu',
  templateUrl: './material-menu.component.html',
  styleUrls: ['./material-menu.component.scss']
})
export class MaterialMenuComponent {
  @Input() items: MenuItem[] = [];

  constructor(private router: Router) {}

  toggleExpanded(item: MenuItem) {
    if (item.children) {
      item.expanded = !item.expanded;
    }
  }

  navigateTo(item: MenuItem) {
    if (item.link) {
      this.router.navigate([item.link]);
    } else if (item.children) {
      this.toggleExpanded(item);
    }
  }

  isActive(link: string): boolean {
    return this.router.url === link;
  }

  isParentActive(item: MenuItem): boolean {
    if (!item.children) return false;
    return item.children.some(child => child.link && this.router.url === child.link);
  }
}
