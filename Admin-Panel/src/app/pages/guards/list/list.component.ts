import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { GuardClient } from '../../../@core/network/guard-client.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
})
export class ListComponent extends BaseListComponent implements OnInit {
  columns = [
    {
      key: 'user',
      translation_key: 'GUARD.FIELDS.USER.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (user) => {
          return user?.mobile_number;
        },
      }
    },
    {
      key: 'project',
      translation_key: 'GUARD.FIELDS.PROJECT.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (project) => {
          return project?.title;
        },
      }
    }
  ];
  editPageUrl = 'pages/guards/edit';

  constructor(public client: GuardClient, public coreService: CoreService, public route: ActivatedRoute) {
    super(coreService);
    this.actionSettings = {
      actions: {
        columnTitle: 'Action',
        position: 'right',
        add: false,
      }
    };
  }

  ngOnInit(): void {
    super.ngOnInit(this.client.getBaseEndpoint());
  }
}
