import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Visitorlog } from '../../../@core/models/visitorlog/visitorlog';
import { VisitorlogRequest } from '../../../@core/models/visitorlog/visitorlog.request';
import { VisitorlogError } from '../../../@core/models/visitorlog/visitorlog.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { VisitorlogClient } from '../../../@core/network/visitorlog-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';
import { ProjectClient } from '../../../@core/network/project-client.service';
import { Project } from '../../../@core/models/project/project';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  visitorlog: Visitorlog = new Visitorlog();
  visitorlogRequest: VisitorlogRequest = new VisitorlogRequest();
  visitorlogError: VisitorlogError = new VisitorlogError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];
  statusList = ['waiting', 'preapproved', 'approved', 'rejected', 'left'];

  constructor(private client: VisitorlogClient, public coreService: CoreService, public route: ActivatedRoute) {
    this.languages = coreService.translationService.languages;
  }

  ngOnInit() {
    this.titleGroupForm = this.coreService.translationService.buildFormGroup(null);

    this.getEditData();
  }

  ngAfterViewInit() {
  }

  getEditData() {
    let id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.editId = id;
      this.getDataById(id).subscribe();
    }
  }

  getDataById(id: string): Observable<Visitorlog> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.visitorlog = response;
        this.visitorlogRequest.status = this.visitorlog.status;

        return response;
      }
      ))
  }

  saveVisitorlog() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('status', this.visitorlogRequest.status);

    let save$ = !this.editId ? this.client.store(formData) : this.client.update(this.editId, formData);

    save$.subscribe(
      res => {
        this.showProgressButton = false;
        this.coreService.toastService.showToast(ToastStatus.SUCCESS, 'Saved', 'Saved successfully!');
        this.back();
      },
      err => {
        this.showProgressButton = false;
        this.coreService.toastService.showToast(ToastStatus.DANGER, 'Failed', err.error.message);
        if (err.error.errors) {
          let errors = err.error.errors;
          this.visitorlogError.status = errors?.status;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }
}
