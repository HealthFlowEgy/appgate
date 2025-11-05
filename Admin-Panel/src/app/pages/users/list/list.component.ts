import { Component, OnInit } from '@angular/core';
import { LocalDataSource } from 'angular2-smart-table';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { TranslationService } from '../../../@core/service/translation.service';
import { CoreService } from '../../../@core/service/core.service';
import { ListDataSource } from '../../../@core/network/list-data-source';
import { UserClient } from '../../../@core/network/user-client.service';
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
      translation_key: 'USER.NAME.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'email',
      translation_key: 'USER.EMAIL.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    }
  ];
  editPageUrl = 'pages/users/edit';

  constructor(public client: UserClient, public coreService: CoreService, public route: ActivatedRoute) {
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
    if (event.data.id === 1) {
      this.coreService.toastService.showToast(ToastStatus.DANGER, 'Failed', 'Cannot delete administrator');
      this.loading = false;
      return;
    }
    super.delete(event);
  }
}
