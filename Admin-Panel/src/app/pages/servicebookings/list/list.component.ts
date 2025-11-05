import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { ServicebookingClient } from '../../../@core/network/servicebooking-client.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
})
export class ListComponent extends BaseListComponent implements OnInit {
  columns = [
    {
      key: 'details',
      translation_key: 'SERVICEBOOKING.FIELDS.DETAILS.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'date',
      translation_key: 'SERVICEBOOKING.FIELDS.DATE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'time_from',
      translation_key: 'SERVICEBOOKING.FIELDS.TIME_FROM.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'service',
      translation_key: 'SERVICEBOOKING.FIELDS.SERVICE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (service) => {
          return service?.title;
        },
      }
    },
    {
      key: 'project',
      translation_key: 'SERVICEBOOKING.FIELDS.PROJECT.LABEL',
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
      translation_key: 'SERVICEBOOKING.FIELDS.FLAT.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (flat) => {
          return flat?.title;
        },
      }
    },
    {
      key: 'status',
      translation_key: 'SERVICEBOOKING.FIELDS.STATUS.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
  ];
  editPageUrl = 'pages/servicebookings/edit';

  constructor(public client: ServicebookingClient, public coreService: CoreService, public route: ActivatedRoute) {
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
