import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { PaymentrequestClient } from '../../../@core/network/paymentrequest-client.service';
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
      translation_key: 'PAYMENTREQUEST.FIELDS.TITLE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'duedate',
      translation_key: 'PAYMENTREQUEST.FIELDS.DUEDATE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'status',
      translation_key: 'PAYMENTREQUEST.FIELDS.STATUS.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'project',
      translation_key: 'PAYMENTREQUEST.FIELDS.PROJECT.LABEL',
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
      key: 'flat',
      translation_key: 'PAYMENTREQUEST.FIELDS.FLAT.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (flat) => {
          return flat?.title;
        },
      }
    }
  ];
  editPageUrl = 'pages/paymentrequests/edit';

  constructor(public client: PaymentrequestClient, public coreService: CoreService, public route: ActivatedRoute) {
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
