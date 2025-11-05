import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Banner } from '../../../@core/models/banner/banner';
import { BannerRequest } from '../../../@core/models/banner/banner.request';
import { BannerError } from '../../../@core/models/banner/banner.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { BannerClient } from '../../../@core/network/banner-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  banner: Banner = new Banner();
  bannerRequest: BannerRequest = new BannerRequest();
  bannerError: BannerError = new BannerError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  parentBanners: Array<Banner> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];

  constructor(private client: BannerClient, public coreService: CoreService, public route: ActivatedRoute,
    private formBuilder: FormBuilder) {
    this.languages = coreService.translationService.languages;
  }

  ngOnInit() {
    this.titleGroupForm = this.coreService.translationService.buildFormGroup(null);

    this.getEditData();
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

  getDataById(id: string): Observable<Banner> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.banner = response;
        this.titleGroupForm = this.coreService.translationService.buildFormGroup(this.banner.title_translations);
        this.bannerRequest.sort_order = this.banner.sort_order;
        this.bannerRequest.meta = this.banner.meta;

        return response;
      }
      ))
  }

  saveBanner() {
    this.metaeditorComponent.updatedMetaProperty();
    
    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('title_translations', this.coreService.translationService.buildRequestParam(this.titleGroupForm));
    formData.append('sort_order', this.bannerRequest.sort_order);
    formData.append('meta', JSON.stringify(this.bannerRequest.meta));

    if (this.bannerRequest.image) {
      formData.append('image', this.bannerRequest.image);
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
          this.bannerError.title_translations = errors?.title_translations;
          this.bannerError.image = errors?.image;
          this.bannerError.sort_order = errors?.sort_order;
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
    this.bannerRequest.image = file;
  }
}
