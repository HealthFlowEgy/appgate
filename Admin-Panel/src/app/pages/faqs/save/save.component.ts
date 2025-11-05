import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Faq } from '../../../@core/models/faq/faq';
import { FaqRequest } from '../../../@core/models/faq/faq.request';
import { FaqError } from '../../../@core/models/faq/faq.error';
import { FaqClient } from '../../../@core/network/faq-client.service';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {

  faq: Faq = new Faq();
  faqRequest: FaqRequest = new FaqRequest();
  faqError: FaqError = new FaqError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  isEdit = false;
  editId = null;

  constructor(private client: FaqClient, public coreService: CoreService, public route: ActivatedRoute) {
  }

  ngOnInit() {
    this.getEditData();
  }

  getEditData() {
    let id = this.route.snapshot.paramMap.get('id');

    if (id) {
      this.isEdit = true;
      this.editId = id;
      this.getDataById(id).subscribe();
    }
  }

  getDataById(id: string): Observable<Faq> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.faq = response;
        this.faqRequest.title = this.faq.title;
        this.faqRequest.short_description = this.faq.short_description;
        this.faqRequest.description = this.faq.description;
        return response;
      }
      ))
  }

  saveFaq() {
    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('title', this.faqRequest.title);
    formData.append('short_description', this.faqRequest.short_description);
    formData.append('description', this.faqRequest.description);

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
          this.faqError.title = errors?.title;
          this.faqError.short_description = errors?.short_description;
          this.faqError.description = errors?.description;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }

  formatRole(role) {
    switch (role) {
      default:
        return role;
    }
  }
}
