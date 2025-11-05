import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { User } from '../../../@core/models/user/user';
import { UserRequest } from '../../../@core/models/user/user.request';
import { UserError } from '../../../@core/models/user/user.error';
import { UserClient } from '../../../@core/network/user-client.service';
import { Role } from '../../../@core/models/user/role';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { Project } from '../../../@core/models/project/project';
import { ProjectClient } from '../../../@core/network/project-client.service';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {

  user: User = new User();
  userRoles: Array<Role> = [];
  userRequest: UserRequest = new UserRequest();
  userError: UserError = new UserError();
  projects: Array<Project> = [];
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  isEdit = false;
  editId = null;

  constructor(private client: UserClient, public coreService: CoreService, public route: ActivatedRoute,
    private projectClient: ProjectClient) {
  }

  ngOnInit() {
    this.getRoles().subscribe();
    this.getProjects().subscribe();

    this.getEditData();
  }

  getRoles(): Observable<Array<Role>> {
    return this.client.roles().pipe(
      map(
        (response) => {
          this.userRoles = response;
          return response;
        },
      ));
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

  getEditData() {
    let id = this.route.snapshot.paramMap.get('id');

    if (id) {
      this.isEdit = true;
      this.editId = id;
      this.getDataById(id).subscribe();
    }
  }

  getDataById(id: string): Observable<User> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.user = response;
        this.userRequest.name = this.user.name;
        this.userRequest.email = this.user.email;
        this.userRequest.mobile_number = this.user.mobile_number;
        this.userRequest.roles = [];
        let selectedRoles = [];
        for (let i = 0; i < this.user.roles.length; i++) {
          selectedRoles.push(this.user.roles[i].name);
        }
        this.userRequest.roles = selectedRoles;
        this.userRequest.language = this.user.language;
        this.userRequest.mobile_verified = this.user.mobile_verified;
        // this.userRequest.balance = this.user.wallet.balance;
        this.userRequest.meta = this.user.meta ?? {project_id: null};
        return response;
      }
      ))
  }

  saveUser() {
    this.showProgressButton = true;

    const formData: FormData = new FormData();
    formData.append('name', this.userRequest.name);
    formData.append('email', this.userRequest.email);
    formData.append('mobile_number', this.userRequest.mobile_number);
    if(this.userRequest.password) {
      formData.append('password', this.userRequest.password);
    }
    formData.append('mobile_verified', this.userRequest.mobile_verified ? "1" : "0");
    formData.append('language', this.userRequest.language);
    //formData.append('balance', String(this.userRequest.balance));

    for (let i = 0; i < this.userRequest.roles.length; i++) {
      formData.append('roles[]', this.userRequest.roles[i]);
    }

    if (this.userRequest.image) {
      formData.append('image', this.userRequest.image);
    }

    console.log(this.userRequest.meta);
    if(this.userRequest.meta.project_id) {
      formData.append('meta', JSON.stringify(this.userRequest.meta));
    }

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
          if (err.error.errors.name) {
            this.userError.name = err.error.errors.name;
          }
          if (err.error.errors.image) {
            this.userError.image = err.error.errors.image;
          }
          if (err.error.errors.email) {
            this.userError.email = err.error.errors.email;
          }
          if (err.error.errors.mobile_number) {
            this.userError.mobile_number = err.error.errors.mobile_number;
          }
          if (err.error.errors.password) {
            this.userError.password = err.error.errors.password;
          }
          if (err.error.errors.roles) {
            this.userError.roles = err.error.errors.role;
          }
          if (err.error.errors.balance) {
            this.userError.balance = err.error.errors.balance;
          }
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

  onMobileVerifiedChange(value) {
    this.userRequest.mobile_verified = value;
  }

  onImageChanged(event) {
    const file = event.target.files[0];
    this.userRequest.image = file;
  }
}
