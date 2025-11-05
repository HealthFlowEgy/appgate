import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Paymentrequest } from '../../../@core/models/paymentrequest/paymentrequest';
import { PaymentrequestRequest } from '../../../@core/models/paymentrequest/paymentrequest.request';
import { PaymentrequestError } from '../../../@core/models/paymentrequest/paymentrequest.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { PaymentrequestClient } from '../../../@core/network/paymentrequest-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';
import { ProjectClient } from '../../../@core/network/project-client.service';
import { Project } from '../../../@core/models/project/project';
import { BuildingClient } from '../../../@core/network/building-client.service';
import { Building } from '../../../@core/models/building/building';
import { FlatClient } from '../../../@core/network/flat-client.service';
import { Flat } from '../../../@core/models/flat/flat';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  paymentrequest: Paymentrequest = new Paymentrequest();
  paymentrequestRequest: PaymentrequestRequest = new PaymentrequestRequest();
  paymentrequestError: PaymentrequestError = new PaymentrequestError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  projects: Array<Project> = [];
  buildings: Array<Building> = [];
  flats: Array<Flat> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];
  statusList = ['pending', 'paid', 'failed'];

  constructor(private client: PaymentrequestClient, public coreService: CoreService, public route: ActivatedRoute,
    private projectClient: ProjectClient, private buildingClient: BuildingClient,
    private flatClient: FlatClient) {
    this.languages = coreService.translationService.languages;
  }

  ngOnInit() {
    this.titleGroupForm = this.coreService.translationService.buildFormGroup(null);

    this.getProjects().subscribe(_ => {
      this.getEditData();
    });
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

  getBuildings(project): Observable<Array<Building>> {
    return this.buildingClient.all(project).pipe(
      map(
        (response) => {
          this.buildings = response;
          return response;
        },
      ));
  }

  getFlats(building): Observable<Array<Flat>> {
    return this.flatClient.all(building).pipe(
      map(
        (response) => {
          this.flats = response;
          return response;
        },
      ));
  }

  getDataById(id: string): Observable<Paymentrequest> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.paymentrequest = response;
        this.paymentrequestRequest.title = this.paymentrequest.title;
        this.paymentrequestRequest.amount = this.paymentrequest.amount;
        this.paymentrequestRequest.duedate = this.paymentrequest.duedate;
        this.paymentrequestRequest.status = this.paymentrequest.status;
        this.paymentrequestRequest.project_id = this.paymentrequest.project_id;
        this.paymentrequestRequest.flat_id = this.paymentrequest.flat_id;
        this.paymentrequestRequest.meta = this.paymentrequest.meta;
        this.getBuildings(this.paymentrequest.project_id).subscribe(_ => {
          this.getFlats(this.paymentrequest.flat.building_id).subscribe();
        });
        return response;
      }
      ))
  }

  savePaymentrequest() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();

    formData.append('meta', JSON.stringify(this.paymentrequestRequest.meta));
    formData.append('title',this.paymentrequestRequest.title);
    formData.append('amount', this.paymentrequestRequest.amount);
    formData.append('duedate', this.paymentrequestRequest.duedate);
    formData.append('status', this.paymentrequestRequest.status);
    formData.append('project_id', this.paymentrequestRequest.project_id);
    formData.append('flat_id', this.paymentrequestRequest.flat_id);

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
          this.paymentrequestError.title = errors?.title;
          this.paymentrequestError.amount = errors?.amount;
          this.paymentrequestError.duedate = errors?.duedate;
          this.paymentrequestError.status = errors?.status;
          this.paymentrequestError.project_id = errors?.project_id;
          this.paymentrequestError.flat_id = errors?.flat_id;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }

  onProjectChange(project) {
    this.getBuildings(project).subscribe();
  }

  onBuildingChange(building) {
    this.getFlats(building).subscribe();
  }
}
