import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Media } from '../../../@core/models/media/media';
import { MediaRequest } from '../../../@core/models/media/media.request';
import { MediaError } from '../../../@core/models/media/media.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of, forkJoin } from 'rxjs';
import { MediaClient } from '../../../@core/network/media-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';
import { ViewChild } from '@angular/core';
import { User } from '../../../@core/models/user/user';
import { UserClient } from '../../../@core/network/user-client.service';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  media: Media = new Media();
  mediaRequest: MediaRequest = new MediaRequest();
  mediaError: MediaError = new MediaError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  users: Array<User> = [];
  contentTypeList: Array<string> = ['main'];
  statusList: Array<string> = ['published', 'unpublished', 'draft'];
  editId = null;

  titleGroupForm: FormGroup;

  groupForm: FormGroup;
  groupFormItems: FormArray;

  languages = [];

  constructor(private client: MediaClient, public coreService: CoreService, public route: ActivatedRoute,
    public userClient: UserClient, private formBuilder: FormBuilder) {
    this.languages = coreService.translationService.languages;
  }

  ngOnInit() {
    this.titleGroupForm = this.coreService.translationService.buildFormGroup(null);

    this.groupForm = this.formBuilder.group({
      items: this.formBuilder.array([]),
    });

    this.getEditData();

    forkJoin([
      this.getUsers()
    ]).subscribe();

    if (!this.editId) {
      this.groupFormItems = this.groupForm.get('items') as FormArray;
      this.mediaRequest.meta = {type: 'music'};
    }
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

  getDataById(id: string): Observable<Media> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.media = response;
        this.titleGroupForm = this.coreService.translationService.buildFormGroup(this.media.title_translations);
        this.mediaRequest.status = this.media.status;
        this.mediaRequest.user_id = this.media.user.id;
        this.mediaRequest.content_url = this.media.content[0].original_source;

        this.mediaRequest.meta = this.media.meta;
        this.metaeditorComponent.addMetaFields();

        return response;
      }
      ))
  }

  getUsers(): Observable<Array<User>> {
    return this.userClient.all().pipe(
      map(
        (response) => {
          this.users = response;
          return response;
        },
      ));
  }

  saveMedia() {
    this.showProgressButton = true;

    this.metaeditorComponent.updatedMetaProperty();

    const formData: FormData = new FormData();
    formData.append('title_translations', this.coreService.translationService.buildRequestParam(this.titleGroupForm));
    formData.append('status', this.mediaRequest.status);
    formData.append('user_id', String(this.mediaRequest.user_id));
    formData.append('meta', JSON.stringify(this.mediaRequest.meta));

    // handle content
    formData.append('content[0][original_source]', this.mediaRequest.content_url);

    for (let i = 0; i < this.mediaRequest.images.length; i++) {
      formData.append('images[]', this.mediaRequest.images[i]);
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
          this.mediaError.title_translations = errors?.title_translations;
          this.mediaError.status = errors?.status;
          this.mediaError.images = errors?.images;
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

  onImageChanged(event, index) {
    const file = event.target.files[0];
    this.mediaRequest.images[index] = file;
  }
}
