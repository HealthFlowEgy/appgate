import { CoreService } from '../service/core.service';
import { ListDataSource } from '../network/list-data-source';
import { ToastStatus } from '../service/toast.service';
import { Component } from '@angular/core';

@Component({
    selector: 'ngx-base-component',
    template: '<div></div>'
  })
export abstract class BaseListComponent {
    abstract columns;
    abstract editPageUrl;
    abstract client;

    public source: ListDataSource;
    public loading = false;
    public settings: any = {};
    public commonSettings: any = {
        edit: {
            editButtonContent: '<i class="nb-edit"></i>',
        },
        delete: {
            deleteButtonContent: '<i class="nb-trash"></i>',
            confirmDelete: true,
        },
        mode: 'external',
        pager: {
            perPage: 15,
        },
        hideSubHeader: false
    };
    public actionSettings: any = {
        actions: {
            columnTitle: 'Action',
            position: 'right',
            add: false,
        }
    };

    constructor(public coreService: CoreService) {
    }

    ngOnInit(endpoint: string): void {
        this.coreService.translationService.transformColumns(this.columns).subscribe(_ => {
            this.loadSettings();
            this.loadColumns();
        });

        //this.source = new ListDataSource(this.coreService.http, this.coreService.authService, endpoint);
        this.source = new ListDataSource(this.coreService.http, this.coreService.authService, endpoint);
    }

    onDeleteConfirm(event): void {
        if (window.confirm('Are you sure you want to delete?')) {
            this.delete(event);
        }
    }

    edit(event) {
        this.coreService.router.navigate([this.editPageUrl, event.data.id]);
    }

    delete(event) {
        this.loading = true;
        this.client.delete(event.data.id).subscribe(
            res => {
                this.loading = false;
                this.coreService.toastService.showToast(ToastStatus.SUCCESS, 'Deleted', 'Deleted successfully!');
                this.source.remove(event.data);
            },
            err => {
                this.loading = false;
                this.coreService.toastService.showToast(ToastStatus.DANGER, 'Failed',
                    err.error.message ? err.error.message : 'Unable to delete');
            },
        );
    }

    loadColumns() {
        for (let i = 0; i < this.columns.length; i++) {
            this.settings.columns[this.columns[i].key] = this.columns[i].column;
        }
    }

    loadSettings() {
        this.settings = {
            ...this.commonSettings,
            ...this.actionSettings,
            columns: {}
        };
    }
}