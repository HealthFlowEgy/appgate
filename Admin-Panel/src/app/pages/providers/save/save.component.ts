import { Component, OnInit, ViewChild, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Provider } from '../../../@core/models/provider/provider';
import { ProviderRequest } from '../../../@core/models/provider/provider.request';
import { ProviderError } from '../../../@core/models/provider/provider.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { ProviderClient } from '../../../@core/network/provider-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { Category } from '../../../@core/models/category/category';
import { CategoryClient } from '../../../@core/network/category-client.service';
import { User } from '../../../@core/models/user/user';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';
import { ProviderAvailability } from '../../../@core/models/provider/provider-availability';
import { forkJoin } from 'rxjs/internal/observable/forkJoin';
import { Plan } from '../../../@core/models/plan/plan';
import { PlanClient } from '../../../@core/network/plan-client.service';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, AfterViewInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  provider: Provider = new Provider();
  providerRequest: ProviderRequest = new ProviderRequest();
  providerError: ProviderError = new ProviderError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  daysList: Array<string> = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];
  categories: Array<Category> = [];
  subcategories: Array<Category> = [];
  editId = null;

  plans: Array<Plan> = [];

  nameGroupForm: FormGroup;
  detailsGroupForm: FormGroup;

  languages = [];

  groupForm: FormGroup;
  groupFormItems: FormArray;

  constructor(private client: ProviderClient, public coreService: CoreService, public route: ActivatedRoute,
    public categoryClient: CategoryClient, private formBuilder: FormBuilder, private changeDetectorRef: ChangeDetectorRef,
    private planClient: PlanClient) {
    this.languages = coreService.translationService.languages;
  }

  ngOnInit() {
    this.nameGroupForm = this.coreService.translationService.buildFormGroup(null);
    this.detailsGroupForm = this.coreService.translationService.buildFormGroup(null);

    this.groupForm = this.formBuilder.group({
      items: this.formBuilder.array([]),
    });

    if (!this.editId) {
      this.groupFormItems = this.groupForm.get('items') as FormArray;
    }

    forkJoin([
      this.getPlans(),
      this.getCategories()
    ]).subscribe();

    this.getEditData();
  }

  getPlans(): Observable<Array<Plan>> {
    return this.planClient.all().pipe(
      map(
        (response) => {
          this.plans = response;
          return response;
        },
      ));
  }

  ngAfterViewInit() {
  }

  getCategories(): Observable<Array<Category>> {
    return this.categoryClient.parent('default').pipe(
      map(
        (response) => {
          this.categories = response;
          return response;
        },
      ));
  }

  getSubcategories(categoryId): Observable<Array<Category>> {
    return this.categoryClient.subcategory(categoryId).pipe(
      map(
        (response) => {
          this.subcategories = response;
          return response;
        },
      ));
  }

  getEditData() {
    let id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.editId = id;
      this.getDataById(id).subscribe();
    } else {
      this.groupFormItems = this.groupForm.get('items') as FormArray;
      let availabilities: Array<any> = [
        { 'days': 'sun', 'from': '10:00:00', 'to': '18:00:00' },
        { 'days': 'mon', 'from': '10:00:00', 'to': '18:00:00' },
        { 'days': 'tue', 'from': '10:00:00', 'to': '18:00:00' },
        { 'days': 'wed', 'from': '10:00:00', 'to': '18:00:00' },
        { 'days': 'thu', 'from': '10:00:00', 'to': '18:00:00' },
        { 'days': 'fri', 'from': '10:00:00', 'to': '18:00:00' },
        { 'days': 'sat', 'from': '10:00:00', 'to': '18:00:00' },
      ];
      for (let i = 0; i < availabilities.length; i++) {
        this.groupFormItems.push(this.createGroupItem(availabilities[i]));
      }
    }
  }

  getDataById(id: string): Observable<Provider> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.provider = response;
        this.nameGroupForm = this.coreService.translationService.buildFormGroup(this.provider.name_translations);
        this.detailsGroupForm = this.coreService.translationService.buildFormGroup(this.provider.details_translations);
        this.providerRequest.fee = this.provider.fee;
        this.providerRequest.is_verified = this.provider.is_verified;
        this.providerRequest.address = this.provider.address;
        this.providerRequest.latitude = this.provider.latitude;
        this.providerRequest.longitude = this.provider.longitude;

        if (this.provider.plan) {
          this.providerRequest.plan_id = this.provider.plan.plan_id;
        }

        let selectedCategories = [];
        let selectedSubcategoriesObservable = [];
        let selectedSubCategories = [];

        // selected categories
        for (let i = 0; i < this.provider.categories.length; i++) {
          selectedCategories.push(this.provider.categories[i].category_id);
          selectedSubcategoriesObservable.push(this.getSubcategories(this.provider.categories[i].category_id));
        }
        this.providerRequest.categories = selectedCategories;

        // selected subcategories
        this.getSubcategories(selectedCategories).subscribe(_ => {
          for (let i = 0; i < this.provider.subcategories.length; i++) {
            selectedSubCategories.push(this.provider.subcategories[i].category_id);
          }
        });
        this.providerRequest.subcategories = selectedSubCategories;

        this.groupFormItems = this.groupForm.get('items') as FormArray;
        for (let i = 0; i < this.provider.availability.length; i++) {
          this.groupFormItems.push(this.createGroupItem(this.provider.availability[i]));
        }

        this.providerRequest.meta = this.provider.meta;

        return response;
      }
      ))
  }

  saveProvider() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('name_translations', this.coreService.translationService.buildRequestParam(this.nameGroupForm));
    formData.append('details_translations', this.coreService.translationService.buildRequestParam(this.detailsGroupForm));
    formData.append('address', this.providerRequest.address);
    formData.append('latitude', this.providerRequest.latitude);
    formData.append('longitude', this.providerRequest.longitude);
    formData.append('fee', this.providerRequest.fee);
    formData.append('is_verified', this.providerRequest.is_verified ? "1" : "0");
    formData.append('meta', JSON.stringify(this.providerRequest.meta));

    if (this.providerRequest.plan_id) {
      formData.append('plan_id', this.providerRequest.plan_id);
    }

    // user information
    if (!this.editId) {
      formData.append('email', this.providerRequest.email);
      formData.append('mobile_number', this.providerRequest.mobile_number);
      formData.append('password', this.providerRequest.password);
    }

    for (let i = 0; i < this.providerRequest.categories.length; i++) {
      formData.append('categories[]', this.providerRequest.categories[i]);
    }

    for (let i = 0; i < this.providerRequest.subcategories.length; i++) {
      formData.append('subcategories[]', this.providerRequest.subcategories[i]);
    }

    for (let i = 0; i < this.providerRequest.images.length; i++) {
      formData.append('images[]', this.providerRequest.images[i]);
    }

    // handle availability
    const group = this.groupForm.controls.items as FormArray;
    for (let i = 0; i < group.controls.length; i++) {
      const innerGroup = group.controls[i] as FormGroup;
      const groupTitleForm = innerGroup.controls.title as FormGroup;
      formData.append('availability[' + i + '][days]', innerGroup.controls.days.value ?? '');
      formData.append('availability[' + i + '][from]', innerGroup.controls.from.value);
      formData.append('availability[' + i + '][to]', innerGroup.controls.to.value);
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
          this.providerError.name_translations = errors?.name_translations;
          this.providerError.details_translations = errors?.details_translations;
          this.providerError.is_verified = errors?.is_verified;
          this.providerError.address = errors?.address;
          this.providerError.longitude = errors?.longitude;
          this.providerError.latitude = errors?.latitude;
          this.providerError.images = errors?.image;
          this.providerError.categories = errors?.categories;
          this.providerError.availability = errors?.availability;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }

  getNameItems() {
    return this.nameGroupForm.get('items') as FormArray;
  }

  getDetailsItems() {
    return this.detailsGroupForm.get('items') as FormArray;
  }

  onImageChanged(event, index) {
    const file = event.target.files[0];
    this.providerRequest.images[index] = file;
  }

  createGroupItem(group: ProviderAvailability): FormGroup {
    return this.formBuilder.group({
      days: group.days,
      from: group.from,
      to: group.to
    });
  }

  addNewGroup() {
    this.groupFormItems.push(
      this.formBuilder.group({
        days: '',
        from: '',
        to: ''
      }));
  }

  deleteGroup(groupIndex) {
    this.groupFormItems.removeAt(groupIndex);
  }

  getFormGroupItems() {
    return this.groupForm.get('items') as FormArray;
  }

  onIsVerifiedChange(value) {
    this.providerRequest.is_verified = value;
  }

  onPrimaryCategoryChange(event) {
    if (event.length == 0) {
      this.providerRequest.subcategories = [];
      this.subcategories = [];
      return;
    }

    this.subcategories = [];

    // make a copy of currently selected subcategories
    let selectedSubCategories = [];
    selectedSubCategories.push(...this.providerRequest.subcategories);

    this.getSubcategories(event).subscribe(_ => {
      // filter out subcategories whose parent category is not selected any longer
      for (let i = 0; i < this.providerRequest.subcategories.length; i++) {
        if (!_.some(elem => elem.id == this.providerRequest.subcategories[i])) {
          selectedSubCategories.splice(i, 1);
        }
      }

      // update the request object with filtered sub categories
      this.providerRequest.subcategories = selectedSubCategories;
    });
  }
}
