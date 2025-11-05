import { Component } from '@angular/core';
import { AppConfigService } from '../../../app-config.service';

@Component({
  selector: 'ngx-footer',
  styleUrls: ['./footer.component.scss'],
  template: `
    <span class="created-by" *ngIf="developerName">
      Created with ♥ by <b><a [href]="developerUrl" target="_blank">{{ developerName }}</a></b> {{year}}
    </span>
  `,
})
export class FooterComponent {
  public developerName;
  public developerUrl;

  constructor(private appConfigService: AppConfigService) {
    this.developerName = appConfigService.getConfig().developerName;
    this.developerUrl = appConfigService.getConfig().developerUrl;
  }
  year = new Date().getFullYear()
}
