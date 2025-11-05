import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Complaint } from '../../../@core/models/complaint/complaint';
import { ComplaintRequest } from '../../../@core/models/complaint/complaint.request';
import { ComplaintError } from '../../../@core/models/complaint/complaint.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { ComplaintClient } from '../../../@core/network/complaint-client.service';
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

  complaint: Complaint = new Complaint();
  complaintRequest: ComplaintRequest = new ComplaintRequest();
  complaintError: ComplaintError = new ComplaintError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  projects: Array<Project> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];
  statusList = ['new', 'resolved'];

  constructor(private client: ComplaintClient, public coreService: CoreService, public route: ActivatedRoute,
    private projectClient: ProjectClient) {
    this.languages = coreService.translationService.languages;
  }

  ngOnInit() {
    this.titleGroupForm = this.coreService.translationService.buildFormGroup(null);

    this.getEditData();

    this.getProjects().subscribe();
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

  getProjects(): Observable<Array<Project>> {
    return this.projectClient.all(undefined).pipe(
      map(
        (response) => {
          this.projects = response;
          return response;
        },
      ));
  }

  getDataById(id: string): Observable<Complaint> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.complaint = response;
        this.complaintRequest.status = this.complaint.status;

        return response;
      }
      ))
  }

  saveComplaint() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('status', this.complaintRequest.status);

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
          this.complaintError.status = errors?.status;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }
}
