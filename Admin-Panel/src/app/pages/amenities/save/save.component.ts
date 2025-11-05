import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Amenity } from '../../../@core/models/amenity/amenity';
import { AmenityRequest } from '../../../@core/models/amenity/amenity.request';
import { AmenityError } from '../../../@core/models/amenity/amenity.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { AmenityClient } from '../../../@core/network/amenity-client.service';
import { FormGroup } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';
import { ProjectClient } from '../../../@core/network/project-client.service';
import { Project } from '../../../@core/models/project/project';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  amenity: Amenity = new Amenity();
  amenityRequest: AmenityRequest = new AmenityRequest();
  amenityError: AmenityError = new AmenityError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  projects: Array<Project> = [];
  editId = null;
  titleGroupForm: FormGroup;
  languages = [];

  constructor(private client: AmenityClient, public coreService: CoreService, public route: ActivatedRoute,
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

  getDataById(id: string): Observable<Amenity> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.amenity = response;
        this.amenityRequest.title = this.amenity.title;
        this.amenityRequest.description = this.amenity.description;
        this.amenityRequest.fee = this.amenity.fee;
        this.amenityRequest.capacity = this.amenity.capacity;
        this.amenityRequest.booking_capacity = this.amenity.booking_capacity;
        this.amenityRequest.advance_booking_days = this.amenity.advance_booking_days;
        this.amenityRequest.max_days_per_flat = this.amenity.max_days_per_flat;
        this.amenityRequest.project_id = this.amenity.project_id;
        this.amenityRequest.meta = this.amenity.meta;
        return response;
      }
      ))
  }

  saveAmenity() {
    this.metaeditorComponent.updatedMetaProperty();

    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('title', this.amenityRequest.title);
    formData.append('description', this.amenityRequest.description);
    formData.append('fee', this.amenityRequest.fee);
    formData.append('capacity', this.amenityRequest.capacity);
    formData.append('booking_capacity', this.amenityRequest.booking_capacity);
    formData.append('advance_booking_days', this.amenityRequest.advance_booking_days);
    formData.append('max_days_per_flat', this.amenityRequest.max_days_per_flat);
    formData.append('project_id', this.amenityRequest.project_id);
    formData.append('meta', JSON.stringify(this.amenityRequest.meta));

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
          this.amenityError.title = errors?.title;
          this.amenityError.description = errors?.description;
          this.amenityError.fee = errors?.fee;
          this.amenityError.capacity = errors?.capacity;
          this.amenityError.booking_capacity = errors?.booking_capacity;
          this.amenityError.advance_booking_days = errors?.advance_booking_days;
          this.amenityError.max_days_per_flat = errors?.max_days_per_flat;
          this.amenityError.project_id = errors?.project_id;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }
}
