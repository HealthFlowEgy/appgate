import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Resident } from '../../../@core/models/resident/resident';
import { ResidentRequest } from '../../../@core/models/resident/resident.request';
import { ResidentError } from '../../../@core/models/resident/resident.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { ResidentClient } from '../../../@core/network/resident-client.service';
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

  resident: Resident = new Resident();
  residentRequest: ResidentRequest = new ResidentRequest();
  residentError: ResidentError = new ResidentError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  projects: Array<Project> = [];
  buildings: Array<Building> = [];
  flats: Array<Flat> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];
  typeList = ['owner', 'tenant', 'owner_family', 'tenant_family'];

  constructor(private client: ResidentClient, public coreService: CoreService, public route: ActivatedRoute,
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

  getDataById(id: string): Observable<Resident> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.resident = response;
        this.residentRequest.is_approved = this.resident.is_approved;
        this.residentRequest.type = this.resident.type;
        this.residentRequest.project_id = this.resident.project_id;
        this.residentRequest.building_id = this.resident.building_id;
        this.residentRequest.flat_id = this.resident.flat_id;
        this.residentRequest.meta = this.resident.meta;
        this.getBuildings(this.resident.building.project_id).subscribe(_ => {
          this.getFlats(this.resident.building_id).subscribe();
        });
        return response;
      }
      ))
  }

  saveResident() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();

    formData.append('meta', JSON.stringify(this.residentRequest.meta));
    formData.append('is_approved', this.residentRequest.is_approved ? "1" : "0");
    formData.append('type', this.residentRequest.type);
    formData.append('project_id', this.residentRequest.project_id);
    formData.append('building_id', this.residentRequest.building_id);
    formData.append('flat_id', this.residentRequest.flat_id);

    // user information
    if (!this.editId) {
      formData.append('name', this.residentRequest.name);
      formData.append('email', this.residentRequest.email);
      formData.append('mobile_number', this.residentRequest.mobile_number);
      formData.append('password', this.residentRequest.password);
    }

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
          this.residentError.building_id = errors?.building_id;
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

  onIsApprovedChange(value) {
    this.residentRequest.is_approved = value;
  }
}
