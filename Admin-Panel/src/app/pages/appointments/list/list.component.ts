import { Component, OnInit } from '@angular/core';
import { LocalDataSource } from 'angular2-smart-table';
import { BaseListComponent } from '../../../@core/components/base-list.component';
import { TranslationService } from '../../../@core/service/translation.service';
import { CoreService } from '../../../@core/service/core.service';
import { ListDataSource } from '../../../@core/network/list-data-source';
import { AppointmentClient } from '../../../@core/network/appointment-client.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { ActivatedRoute } from '@angular/router';
import { Constants } from '../../../@core/models/constants.model';

@Component({
  selector: 'list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
})
export class ListComponent extends BaseListComponent implements OnInit {
  columns = [
    {
      key: 'id',
      translation_key: 'APPOINTMENT.FIELDS.ID.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        isFilterable: false,
      }
    },
    {
      key: 'resident',
      translation_key: 'APPOINTMENT.FIELDS.USER.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (resident) => {
          return resident?.user?.mobile_number;
        },
      }
    },
    {
      key: 'amenity',
      translation_key: 'APPOINTMENT.FIELDS.PROVIDER.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string",
        valuePrepareFunction: (amenity) => {
          return amenity?.title;
        },
      }
    },
    {
      key: 'date',
      translation_key: 'APPOINTMENT.FIELDS.DATE.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'status',
      translation_key: 'APPOINTMENT.FIELDS.STATUS.LABEL',
      column: {
        title: "",
        sort: false,
        type: "string"
      }
    },
    {
      key: 'amount',
      translation_key: 'APPOINTMENT.FIELDS.AMOUNT.LABEL',
      column: {
        title: "",
        sort: false,
        isFilterable: false,
        type: "string"
      }
    }
  ];
  editPageUrl = 'pages/appointments/edit';

  constructor(public client: AppointmentClient, public coreService: CoreService, public route: ActivatedRoute) {
    super(coreService);
  }

  ngOnInit(): void {
    super.ngOnInit(this.client.getBaseEndpoint());
  }
}
