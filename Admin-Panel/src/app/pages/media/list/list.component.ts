import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { MediaClient } from '../../../@core/network/media-client.service';;
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
})
export class ListComponent extends BaseListComponent implements OnInit {
  columns = [
    {
      key: 'title',
      translation_key: 'MEDIA.FIELDS.TITLE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (title) => {
          title = String(title);
          return title.length < 50 ? title : title.substring(0, 50) + '...';
        },
      }
    },
    {
      key: 'user',
      translation_key: 'MEDIA.FIELDS.USER.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (user) => {
          return user?.name;
        },
      }
    }
  ];
  editPageUrl = 'pages/medias/edit';

  constructor(public client: MediaClient, public coreService: CoreService, public route: ActivatedRoute) {
    super(coreService);
  }

  ngOnInit(): void {
    super.ngOnInit(this.client.getBaseEndpoint() + '?meta[type]=post');
  }
}
