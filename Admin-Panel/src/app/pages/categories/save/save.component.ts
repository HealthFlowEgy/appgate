import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Category } from '../../../@core/models/category/category';
import { CategoryRequest } from '../../../@core/models/category/category.request';
import { CategoryError } from '../../../@core/models/category/category.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { CategoryClient } from '../../../@core/network/category-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  category: Category = new Category();
  categoryRequest: CategoryRequest = new CategoryRequest();
  categoryError: CategoryError = new CategoryError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  parentCategories: Array<Category> = [];
  metaScopeList = ['default'];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];

  constructor(private client: CategoryClient, public coreService: CoreService, public route: ActivatedRoute,
    private formBuilder: FormBuilder) {
    this.languages = coreService.translationService.languages;
  }

  ngOnInit() {
    this.titleGroupForm = this.coreService.translationService.buildFormGroup(null);
    this.getParentCategories().subscribe();

    this.getEditData();
  }

  ngAfterViewInit() {
    if (!this.editId) {
      //this.metaeditorComponent.addMetaFields();
    }
  }

  getParentCategories(): Observable<Array<Category>> {
    return this.client.parent(undefined).pipe(
      map(
        (response) => {
          this.parentCategories = response;
          return response;
        },
      ));
  }

  getEditData() {
    let id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.editId = id;
      this.getDataById(id).subscribe();
    }
  }

  getDataById(id: string): Observable<Category> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.category = response;
        this.titleGroupForm = this.coreService.translationService.buildFormGroup(this.category.title_translations);
        this.categoryRequest.slug = this.category.slug;
        this.categoryRequest.parent_id = this.category.parent_id;
        this.categoryRequest.sort_order = this.category.sort_order;
        this.categoryRequest.meta = this.category.meta;

        //this.metaeditorComponent.addMetaFields();

        return response;
      }
      ))
  }

  saveCategory() {
    this.metaeditorComponent.updatedMetaProperty();
    
    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('title_translations', this.coreService.translationService.buildRequestParam(this.titleGroupForm));
    formData.append('slug', this.categoryRequest.slug);
    formData.append('sort_order', this.categoryRequest.sort_order);
    formData.append('meta', JSON.stringify(this.categoryRequest.meta));

    if (this.categoryRequest.parent_id) {
      formData.append('parent_id', this.categoryRequest.parent_id);
    }

    if (this.categoryRequest.image) {
      formData.append('image', this.categoryRequest.image);
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
          this.categoryError.title_translations = errors?.title_translations;
          this.categoryError.image = errors?.image;
          this.categoryError.sort_order = errors?.sort_order;
          this.categoryError.slug = errors?.slug;
          this.categoryError.parent_id = errors?.parent_id;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }

  getTitleItems() {
    return this.titleGroupForm.get('items') as FormArray;
  }

  onImageChanged(event) {
    const file = event.target.files[0];
    this.categoryRequest.image = file;
  }
}
