import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { WalletClient } from '../../../@core/network/wallet-client.service';
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
      key: 'user',
      translation_key: 'TRANSACTION.FIELDS.USER.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false,
        valuePrepareFunction: (user) => {
          return user.email;
        },
      }
    },
    {
      key: 'type',
      translation_key: 'TRANSACTION.FIELDS.TYPE.LABEL',
      column: {
        isFilterable: false,
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'meta',
      translation_key: 'TRANSACTION.FIELDS.META.LABEL',
      column: {
        isFilterable: false,
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (meta) => {
          return meta?.description;
        },
      }
    },
    {
      key: 'amount',
      translation_key: 'TRANSACTION.FIELDS.AMOUNT.LABEL',
      column: {
        isFilterable: false,
        title: "",
        sort: false,
        type: "string"
      }
    }
  ];
  editPageUrl = 'pages/transactions/edit';

  constructor(public client: WalletClient, public coreService: CoreService, public route: ActivatedRoute) {
    super(coreService);
    this.actionSettings = {
      actions: {
        columnTitle: 'Action',
        position: 'right',
        add: false,
        edit: false,
        delete: false
      }
    };
  }

  ngOnInit(): void {
    super.ngOnInit(this.client.getBaseEndpoint() + '/transactions');
  }

  delete(event) {
    super.delete(event);
  }
}
