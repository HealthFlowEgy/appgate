import { Component, OnInit } from '@angular/core';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { CoreService } from '../../../@core/service/core.service';
import { CommentClient } from '../../../@core/network/comment-client.service';
import { ActivatedRoute } from '@angular/router';
import { formatDate } from '@angular/common';

@Component({
  selector: 'list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
})
export class ListComponent extends BaseListComponent implements OnInit {
  columns = [
    {
      key: 'comment',
      translation_key: 'COMMENT.FIELDS.COMMENT.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false
      },
    },
    {
      key: 'user',
      translation_key: 'COMMENT.FIELDS.USER.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false,
        valuePrepareFunction: (user) => {
          return user?.mobile_number;
        },
      }
    },
    {
      key: 'commentable_id',
      translation_key: 'COMMENT.FIELDS.MEDIA_ID.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false
      }
    },
    {
      key: 'created_at',
      translation_key: 'COMMENT.FIELDS.CREATED_AT.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false,
        valuePrepareFunction: (created_at) => {
          return formatDate(created_at, 'medium', 'en-US');
        },
      }
    }
  ];
  editPageUrl = 'pages/comments/edit';

  constructor(public client: CommentClient, public coreService: CoreService, public route: ActivatedRoute) {
    super(coreService);
    this.actionSettings = {
      actions: {
        columnTitle: 'Action',
        position: 'right',
        add: false,
        edit: false,
      }
    };
  }

  ngOnInit(): void {
    let mediaId = this.route.snapshot.queryParamMap.get('media');

    if (mediaId) {
      super.ngOnInit(this.client.getBaseEndpoint() + '?media_id=' + mediaId);
    } else {
      super.ngOnInit(this.client.getBaseEndpoint());
    }
  }

  delete(event) {
    super.delete(event);
  }
}
