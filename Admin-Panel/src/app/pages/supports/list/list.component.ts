import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { SupportClient } from '../../../@core/network/support-client.service';
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
      translation_key: 'SUPPORT.FIELDS.NAME.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'email',
      translation_key: 'SUPPORT.FIELDS.EMAIL.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'message',
      translation_key: 'SUPPORT.FIELDS.MESSAGE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    }
  ];
  editPageUrl = 'pages/supports/edit';

  constructor(public client: SupportClient, public coreService: CoreService, public route: ActivatedRoute) {
    super(coreService);
    this.actionSettings = {
      actions: {
        columnTitle: 'Action',
        position: 'right',
        add: false,
        edit: false
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
