import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { VisitorlogClient } from '../../../@core/network/visitorlog-client.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
})
export class ListComponent extends BaseListComponent implements OnInit {
  columns = [
    {
      key: 'type',
      translation_key: 'VISITORLOG.FIELDS.TYPE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'name',
      translation_key: 'VISITORLOG.FIELDS.NAME.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'contact',
      translation_key: 'VISITORLOG.FIELDS.CONTACT.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'project',
      translation_key: 'VISITORLOG.FIELDS.PROJECT.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (project) => {
          return project?.title;
        },
      }
    },
    {
      key: 'user',
      translation_key: 'VISITORLOG.FIELDS.USER.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (user) => {
          return user?.mobile_number;
        },
      }
    }
  ];
  editPageUrl = 'pages/visitorlogs/edit';

  constructor(public client: VisitorlogClient, public coreService: CoreService, public route: ActivatedRoute) {
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
