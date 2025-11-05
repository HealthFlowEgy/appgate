import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Building } from '../../../@core/models/building/building';
import { BuildingRequest } from '../../../@core/models/building/building.request';
import { BuildingError } from '../../../@core/models/building/building.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { BuildingClient } from '../../../@core/network/building-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';
import { Category } from '../../../@core/models/category/category';
import { CategoryClient } from '../../../@core/network/category-client.service';
import { ProjectClient } from '../../../@core/network/project-client.service';
import { Project } from '../../../@core/models/project/project';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  building: Building = new Building();
  buildingRequest: BuildingRequest = new BuildingRequest();
  buildingError: BuildingError = new BuildingError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  projects: Array<Project> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];

  constructor(private client: BuildingClient, public coreService: CoreService, public route: ActivatedRoute,
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

  getDataById(id: string): Observable<Building> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.building = response;
        this.buildingRequest.title = this.building.title;
        this.buildingRequest.project_id = this.building.project_id;
        this.buildingRequest.meta = this.building.meta;

        return response;
      }
      ))
  }

  saveBuilding() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('title', this.buildingRequest.title);
    formData.append('project_id', this.buildingRequest.project_id);
    formData.append('meta', JSON.stringify(this.buildingRequest.meta));

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
          this.buildingError.title = errors?.title;
          this.buildingError.project_id = errors?.project_id;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }
}
