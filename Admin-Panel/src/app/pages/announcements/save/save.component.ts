import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Announcement } from '../../../@core/models/announcement/announcement';
import { AnnouncementRequest } from '../../../@core/models/announcement/announcement.request';
import { AnnouncementError } from '../../../@core/models/announcement/announcement.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { AnnouncementClient } from '../../../@core/network/announcement-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';
import { ProjectClient } from '../../../@core/network/project-client.service';
import { Project } from '../../../@core/models/project/project';
import { AnnouncementOption } from '../../../@core/models/announcement/announcement-option';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  announcement: Announcement = new Announcement();
  announcementRequest: AnnouncementRequest = new AnnouncementRequest();
  announcementError: AnnouncementError = new AnnouncementError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  projects: Array<Project> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];
  typesList = ['announcement', 'poll'];

  groupForm: FormGroup;
  groupFormItems: FormArray;

  constructor(private client: AnnouncementClient, public coreService: CoreService, public route: ActivatedRoute,
    private projectClient: ProjectClient, private formBuilder: FormBuilder,) {
    this.languages = coreService.translationService.languages;
  }

  ngOnInit() {
    this.titleGroupForm = this.coreService.translationService.buildFormGroup(null);

    this.groupForm = this.formBuilder.group({
      items: this.formBuilder.array([]),
    });

    if (!this.editId) {
      this.groupFormItems = this.groupForm.get('items') as FormArray;
    }

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

  getDataById(id: string): Observable<Announcement> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.announcement = response;
        this.announcementRequest.type = this.announcement.type;
        this.announcementRequest.message = this.announcement.message;
        this.announcementRequest.posted_by = this.announcement.posted_by;
        this.announcementRequest.duedate = this.announcement.duedate;
        this.announcementRequest.project_id = this.announcement.project_id;
        this.announcementRequest.meta = this.announcement.meta;

        this.groupFormItems = this.groupForm.get('items') as FormArray;
        for (let i = 0; i < this.announcement.options.length; i++) {
          this.groupFormItems.push(this.createGroupItem(this.announcement.options[i]));
        }

        return response;
      }
      ))
  }

  saveAnnouncement() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('type', this.announcementRequest.type);
    formData.append('message', this.announcementRequest.message);
    formData.append('posted_by', this.announcementRequest.posted_by);
    formData.append('project_id', this.announcementRequest.project_id);
    formData.append('meta', JSON.stringify(this.announcementRequest.meta));

    if(this.announcementRequest.duedate) {
      formData.append('duedate', this.announcementRequest.duedate);
    }

    // handle options
    const group = this.groupForm.controls.items as FormArray;
    for (let i = 0; i < group.controls.length; i++) {
      const innerGroup = group.controls[i] as FormGroup;
      formData.append('options[' + i + '][title]', innerGroup.controls.title.value ?? '');
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
          this.announcementError.message = errors?.message;
          this.announcementError.project_id = errors?.project_id;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }

  createGroupItem(group: AnnouncementOption): FormGroup {
    return this.formBuilder.group({
      title: group.title,
      selected_percentage: group.selected_percentage
    });
  }

  addNewGroup() {
    this.groupFormItems.push(
      this.formBuilder.group({
        title: '',
        selected_percentage: ''
      }));
  }

  deleteGroup(groupIndex) {
    this.groupFormItems.removeAt(groupIndex);
  }

  getFormGroupItems() {
    return this.groupForm.get('items') as FormArray;
  }
}
