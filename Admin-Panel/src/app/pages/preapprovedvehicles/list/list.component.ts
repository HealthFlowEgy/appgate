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
      key: 'vehicle_number',
      translation_key: 'VISITORLOG.FIELDS.VEHICLE_NUMBER.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'flat',
      translation_key: 'VISITORLOG.FIELDS.FLAT.LABEL',
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
    }
  ];
  editPageUrl = 'pages/preapprovedvehicles/edit';

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
