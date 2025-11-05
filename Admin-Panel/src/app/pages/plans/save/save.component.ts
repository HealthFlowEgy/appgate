import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Plan } from '../../../@core/models/plan/plan';
import { PlanRequest } from '../../../@core/models/plan/plan.request';
import { PlanError } from '../../../@core/models/plan/plan.error';
import { PlanClient } from '../../../@core/network/plan-client.service';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {

  plan: Plan = new Plan();
  planRequest: PlanRequest = new PlanRequest();
  planError: PlanError = new PlanError();
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  isEdit = false;
  editId = null;

  constructor(private client: PlanClient, public coreService: CoreService, public route: ActivatedRoute) {
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

  getDataById(id: string): Observable<Plan> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.plan = response;
        this.planRequest.name = this.plan.name;
        this.planRequest.description = this.plan.description;
        this.planRequest.price = this.plan.price;
        this.planRequest.duration = this.plan.duration;
        this.planRequest.leads_per_day = String(this.plan.features[0].limit);
        return response;
      }
      ))
  }

  savePlan() {
    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('name', this.planRequest.name);
    formData.append('description', this.planRequest.description);
    formData.append('price', this.planRequest.price);
    formData.append('duration', this.planRequest.duration);
    formData.append('leads_per_day', this.planRequest.leads_per_day);

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
          this.planError.name = errors?.name;
          this.planError.description = errors?.description;
          this.planError.price = errors?.price;
          this.planError.duration = errors?.duration;
          this.planError.leads_per_day = errors?.leads_per_day;
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
