import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Guard } from '../../../@core/models/guard/guard';
import { GuardRequest } from '../../../@core/models/guard/guard.request';
import { GuardError } from '../../../@core/models/guard/guard.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { GuardClient } from '../../../@core/network/guard-client.service';
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

  guard: Guard = new Guard();
  guardRequest: GuardRequest = new GuardRequest();
  guardError: GuardError = new GuardError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  projects: Array<Project> = [];
  buildings: Array<Building> = [];
  flats: Array<Flat> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];

  constructor(private client: GuardClient, public coreService: CoreService, public route: ActivatedRoute,
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

  getDataById(id: string): Observable<Guard> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.guard = response;
        this.guardRequest.project_id = this.guard.project_id;
        this.guardRequest.meta = this.guard.meta;
        return response;
      }
      ))
  }

  saveGuard() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();

    formData.append('meta', JSON.stringify(this.guardRequest.meta));
    formData.append('project_id', this.guardRequest.project_id);

    // user information
    if (!this.editId) {
      formData.append('name', this.guardRequest.name);
      formData.append('mobile_number', this.guardRequest.mobile_number);
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
          this.guardError.project_id = errors?.project_id;
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
}
