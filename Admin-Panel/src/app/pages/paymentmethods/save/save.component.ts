import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Paymentmethod } from '../../../@core/models/paymentmethod/paymentmethod';
import { PaymentmethodRequest } from '../../../@core/models/paymentmethod/paymentmethod.request';
import { PaymentmethodError } from '../../../@core/models/paymentmethod/paymentmethod.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { PaymentmethodClient } from '../../../@core/network/paymentmethod-client.service';
import { FormGroup, FormArray } from '@angular/forms';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
  styleUrls: ['./save.component.scss'],
})
export class SaveComponent implements OnInit, IsEditable {

  paymentmethod: Paymentmethod = new Paymentmethod();
  paymentmethodRequest: PaymentmethodRequest = new PaymentmethodRequest();
  paymentmethodError: PaymentmethodError = new PaymentmethodError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  typeList: Array<string> = ['postpaid', 'prepaid'];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];

  constructor(private client: PaymentmethodClient, public coreService: CoreService, public route: ActivatedRoute) {
    this.languages =  coreService.translationService.languages;
  }

  ngOnInit() {
    this.titleGroupForm = this.coreService.translationService.buildFormGroup(null);

    this.getEditData();
  }

  getEditData() {
    let id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.editId = id;
      this.getDataById(id).subscribe();
    }
  }

  getDataById(id: string): Observable<Paymentmethod> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.paymentmethod = response;
        this.titleGroupForm = this.coreService.translationService.buildFormGroup(this.paymentmethod.title_translations);
        this.paymentmethodRequest.slug = this.paymentmethod.slug;
        this.paymentmethodRequest.meta = this.paymentmethod.meta;
        this.paymentmethodRequest.type = this.paymentmethod.type;
        this.paymentmethodRequest.enabled = this.paymentmethod.enabled;
        return response;
      }
      ))
  }

  savePaymentmethod() {
    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('title_translations', this.coreService.translationService.buildRequestParam(this.titleGroupForm));
    formData.append('slug', this.paymentmethodRequest.slug);
    formData.append('meta', JSON.stringify(this.paymentmethodRequest.meta));
    formData.append('enabled', this.paymentmethodRequest.enabled ? "1" : "0");
    formData.append('type', String(this.paymentmethodRequest.type));

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
          this.paymentmethodError.title_translations = errors?.title_translations;
          this.paymentmethodError.slug = errors?.slug;
          this.paymentmethodError.meta = errors?.meta;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }

  getTitleItems() {
    return this.titleGroupForm.get('items')  as FormArray;
  }

  onEnabledChange(value) {
    this.paymentmethodRequest.enabled = value;
  }
}
