import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { PlanClient } from '../../../@core/network/plan-client.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
})
export class ListComponent extends BaseListComponent implements OnInit {
  columns = [
    {
      key: 'name',
      translation_key: 'PLAN.FIELDS.NAME.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false
      }
    },
    {
      key: 'price',
      translation_key: 'PLAN.FIELDS.PRICE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false
      }
    },
    {
      key: 'duration',
      translation_key: 'PLAN.FIELDS.DURATION.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false
      }
    }
  ];
  editPageUrl = 'pages/plans/edit';

  constructor(public client: PlanClient, public coreService: CoreService, public route: ActivatedRoute) {
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

  delete(event) {
    super.delete(event);
  }
}
