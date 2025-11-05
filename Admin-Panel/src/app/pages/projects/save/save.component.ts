import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Project } from '../../../@core/models/project/project';
import { ProjectRequest } from '../../../@core/models/project/project.request';
import { ProjectError } from '../../../@core/models/project/project.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { ProjectClient } from '../../../@core/network/project-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';
import { Category } from '../../../@core/models/category/category';
import { CategoryClient } from '../../../@core/network/category-client.service';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  project: Project = new Project();
  projectRequest: ProjectRequest = new ProjectRequest();
  projectError: ProjectError = new ProjectError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  cityCategories: Array<Category> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];

  constructor(private client: ProjectClient, public coreService: CoreService, public route: ActivatedRoute,
    private categoryClient: CategoryClient) {
    this.languages = coreService.translationService.languages;
  }

  ngOnInit() {
    this.titleGroupForm = this.coreService.translationService.buildFormGroup(null);

    this.getEditData();

    this.getCityCategories().subscribe();
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

  getCityCategories(): Observable<Array<Category>> {
    return this.categoryClient.all('city').pipe(
      map(
        (response) => {
          this.cityCategories = response;
          return response;
        },
      ));
  }

  getDataById(id: string): Observable<Project> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.project = response;
        this.projectRequest.title = this.project.title;
        this.projectRequest.address = this.project.address;
        this.projectRequest.latitude = this.project.latitude;
        this.projectRequest.longitude = this.project.longitude;
        this.projectRequest.city_id = this.project.city_id;
        this.projectRequest.meta = this.project.meta;

        return response;
      }
      ))
  }

  saveProject() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('title', this.projectRequest.title);
    formData.append('address', this.projectRequest.address);
    formData.append('latitude', this.projectRequest.latitude);
    formData.append('longitude', this.projectRequest.longitude);
    formData.append('city_id', this.projectRequest.city_id);
    formData.append('meta', JSON.stringify(this.projectRequest.meta));

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
          this.projectError.title = errors?.title;
          this.projectError.address = errors?.address;
          this.projectError.latitude = errors?.latitude;
          this.projectError.longitude = errors?.longitude;
          this.projectError.city_id = errors?.city_id;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }
}
