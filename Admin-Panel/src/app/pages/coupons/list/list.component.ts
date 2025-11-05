import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { ActivatedRoute } from '@angular/router';
import { CouponClient } from '../../../@core/network/coupon-client.service';

@Component({
  selector: 'list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
})
export class ListComponent extends BaseListComponent implements OnInit {
  columns = [
    {
      key: 'code',
      translation_key: 'COUPON.FIELDS.CODE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false
      }
    },
    {
      key: 'type',
      translation_key: 'COUPON.FIELDS.TYPE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false
      }
    }
  ];
  editPageUrl = 'pages/coupons/edit';

  constructor(public client: CouponClient, public coreService: CoreService, public route: ActivatedRoute) {
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
