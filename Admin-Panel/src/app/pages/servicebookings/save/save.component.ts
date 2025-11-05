import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Servicebooking } from '../../../@core/models/servicebooking/servicebooking';
import { ServicebookingRequest } from '../../../@core/models/servicebooking/servicebooking.request';
import { ServicebookingError } from '../../../@core/models/servicebooking/servicebooking.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { ServicebookingClient } from '../../../@core/network/servicebooking-client.service';
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

  servicebooking: Servicebooking = new Servicebooking();
  servicebookingRequest: ServicebookingRequest = new ServicebookingRequest();
  servicebookingError: ServicebookingError = new ServicebookingError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  projects: Array<Project> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];
  statusList = ['pending', 'approved', 'rejected', 'cancelled'];

  constructor(private client: ServicebookingClient, public coreService: CoreService, public route: ActivatedRoute,
    private projectClient: ProjectClient) {
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

  getDataById(id: string): Observable<Servicebooking> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.servicebooking = response;
        this.servicebookingRequest.status = this.servicebooking.status;

        return response;
      }
      ))
  }

  saveServicebooking() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('status', this.servicebookingRequest.status);

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
          this.servicebookingError.status = errors?.status;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }
}
