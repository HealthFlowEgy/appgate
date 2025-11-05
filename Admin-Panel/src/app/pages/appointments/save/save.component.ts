import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap, catchError } from 'rxjs/operators';


import { Appointment } from '../../../@core/models/appointment/appointment';
import { AppointmentRequest } from '../../../@core/models/appointment/appointment.request';
import { AppointmentError } from '../../../@core/models/appointment/appointment.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { AppointmentClient } from '../../../@core/network/appointment-client.service';
import { FormGroup, FormArray } from '@angular/forms';
import { Category } from '../../../@core/models/category/category';
import { CategoryClient } from '../../../@core/network/category-client.service';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  appointment: Appointment = new Appointment();
  appointmentRequest: AppointmentRequest = new AppointmentRequest();
  appointmentError: AppointmentError = new AppointmentError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  categories: Array<Category> = [];
  appointmentStatusList: Array<string> = ['pending', 'accepted', 'onway', 'ongoing', 'complete', 'cancelled', 'rejected'];
  editId = null;

  constructor(private client: AppointmentClient, public coreService: CoreService, public route: ActivatedRoute,
    public categoryClient: CategoryClient, httpClient: HttpClient) {
    }

  ngOnInit() {
    this.getEditData();
  }

  getEditData() {
    let id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.editId = id;
      this.getDataById(id).subscribe();
    }
  }

  getDataById(id: string): Observable<Appointment> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.appointment = response;
        this.appointmentRequest.status = this.appointment.status;

        return response;
      }
      ))
  }

  saveAppointment() {
    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('status', this.appointmentRequest.status);

    let save$ = this.editId ? this.client.update(this.editId, formData) : null;

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
          this.appointmentError.status = errors?.status;
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }

  parseFloat(number) {
    return parseFloat(number);
  }
}
