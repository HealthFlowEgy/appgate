import { Component, OnInit } from '@angular/core';
import { LocalDataSource } from 'angular2-smart-table';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { TranslationService } from '../../../@core/service/translation.service';
import { CoreService } from '../../../@core/service/core.service';
import { ListDataSource } from '../../../@core/network/list-data-source';
import { CategoryClient } from '../../../@core/network/category-client.service';
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
      key: 'id',
      translation_key: 'COMMON.ID',
      column: {
        title: "",
        sort: false,
        isFilterable: false,
        type: "string"
      }
    },
    {
      key: 'title',
      translation_key: 'CATEGORY.FIELDS.TITLE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'slug',
      translation_key: 'CATEGORY.FIELDS.SLUG.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'meta',
      translation_key: 'CATEGORY.FIELDS.META_SCOPE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        filter: true,
        valuePrepareFunction: (meta) => {
          return meta.scope;
        },
      }
    }
  ];
  editPageUrl = 'pages/categories/edit';

  constructor(public client: CategoryClient, public coreService: CoreService, public route: ActivatedRoute) {
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
