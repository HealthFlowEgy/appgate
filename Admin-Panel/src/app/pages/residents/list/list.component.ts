import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { ResidentClient } from '../../../@core/network/resident-client.service';
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
      translation_key: 'RESIDENT.FIELDS.USER.LABEL',
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
      key: 'flat',
      translation_key: 'RESIDENT.FIELDS.FLAT.LABEL',
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
      key: 'building',
      translation_key: 'RESIDENT.FIELDS.BUILDING.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (building) => {
          return building?.title;
        },
      }
    }
  ];
  editPageUrl = 'pages/residents/edit';

  constructor(public client: ResidentClient, public coreService: CoreService, public route: ActivatedRoute) {
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
