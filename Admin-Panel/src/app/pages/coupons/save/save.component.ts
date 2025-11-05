import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Coupon } from '../../../@core/models/coupon/coupon';
import { CouponRequest } from '../../../@core/models/coupon/coupon.request';
import { CouponError } from '../../../@core/models/coupon/coupon.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { FormArray, FormGroup } from '@angular/forms';
import { CouponClient } from '../../../@core/network/coupon-client.service';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  coupon: Coupon = new Coupon();
  couponRequest: CouponRequest = new CouponRequest();
  couponError: CouponError = new CouponError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  isEdit = false;
  editId = null;
  typeList: Array<string> = ['fixed', 'percent'];

  titleGroupForm: FormGroup;
  detailGroupForm: FormGroup;
  languages = [];

  constructor(private client: CouponClient, public coreService: CoreService, public route: ActivatedRoute) {
    this.languages = coreService.translationService.languages;
  }

  ngOnInit() {
    this.titleGroupForm = this.coreService.translationService.buildFormGroup(null);
    this.detailGroupForm = this.coreService.translationService.buildFormGroup(null);

    this.getEditData();
  }

  ngAfterViewInit() {
  }

  getEditData() {
    let id = this.route.snapshot.paramMap.get('id');

    if (id) {
      this.isEdit = true;
      this.editId = id;
      this.getDataById(id).subscribe();
    }
  }

  getDataById(id: string): Observable<Coupon> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.coupon = response;
        this.titleGroupForm = this.coreService.translationService.buildFormGroup(this.coupon.title_translations);
        this.detailGroupForm = this.coreService.translationService.buildFormGroup(this.coupon.detail_translations);
        this.couponRequest.code = this.coupon.code;
        this.couponRequest.reward = this.coupon.reward;
        this.couponRequest.type = this.coupon.type;
        this.couponRequest.expires_at = this.coupon.expires_at;
        
        this.couponRequest.meta = this.coupon.meta;

        return response;
      }
      ))
  }

  saveCoupon() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('title_translations', this.coreService.translationService.buildRequestParam(this.titleGroupForm));
    formData.append('detail_translations', this.coreService.translationService.buildRequestParam(this.detailGroupForm));
    formData.append('code', this.couponRequest.code);
    formData.append('reward', String(this.couponRequest.reward));
    formData.append('type', this.couponRequest.type);
    formData.append('expires_at', this.couponRequest.expires_at);
    formData.append('meta', JSON.stringify(this.couponRequest.meta));

    let save$ = !this.isEdit ? this.client.store(formData) : this.client.update(this.editId, formData);

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
          this.couponError.title_translations = errors?.title_translations;
          this.couponError.detail_translations = errors?.detail_translations;
          this.couponError.code = errors?.code;
          this.couponError.reward = errors?.reward;
          this.couponError.type = errors?.type;
          this.couponError.expires_at = errors?.expires_at;
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

  getDetailItems() {
    return this.detailGroupForm.get('items') as FormArray;
  }
}
