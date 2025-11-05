import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Flat } from '../../../@core/models/flat/flat';
import { FlatRequest } from '../../../@core/models/flat/flat.request';
import { FlatError } from '../../../@core/models/flat/flat.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { FlatClient } from '../../../@core/network/flat-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';
import { ProjectClient } from '../../../@core/network/project-client.service';
import { Project } from '../../../@core/models/project/project';
import { BuildingClient } from '../../../@core/network/building-client.service';
import { Building } from '../../../@core/models/building/building';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  flat: Flat = new Flat();
  flatRequest: FlatRequest = new FlatRequest();
  flatError: FlatError = new FlatError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  projects: Array<Project> = [];
  buildings: Array<Building> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];

  constructor(private client: FlatClient, public coreService: CoreService, public route: ActivatedRoute,
    private projectClient: ProjectClient, private buildingClient: BuildingClient) {
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

  getDataById(id: string): Observable<Flat> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.flat = response;
        this.flatRequest.title = this.flat.title;
        this.flatRequest.building_id = this.flat.building_id;
        this.flatRequest.meta = this.flat.meta;

        this.getBuildings(this.flat.building.project_id).subscribe();
        return response;
      }
      ))
  }

  saveFlat() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('title', this.flatRequest.title);
    formData.append('building_id', this.flatRequest.building_id);
    formData.append('meta', JSON.stringify(this.flatRequest.meta));

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
          this.flatError.title = errors?.title;
          this.flatError.building_id = errors?.building_id;
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
