import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { switchMap, map, concatMap } from 'rxjs/operators';


import { Permission } from '../../../@core/models/user/permission';
import { PermissionRequest } from '../../../@core/models/user/permission.request';
import { PermissionError } from '../../../@core/models/user/permission.error';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';
import { Observable, empty, of } from 'rxjs';
import { PermissionClient } from '../../../@core/network/permission-client.service';
import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { MetaeditorComponent } from '../../../@theme/components/metaeditor/metaeditor.component';
import { Category } from '../../../@core/models/category/category';
import { CategoryClient } from '../../../@core/network/category-client.service';
import { ProjectClient } from '../../../@core/network/project-client.service';
import { Project } from '../../../@core/models/project/project';
import { Role } from '../../../@core/models/user/role';
import { UserClient } from '../../../@core/network/user-client.service';
import { Constants } from '../../../@core/models/constants.model';

@Component({
  selector: 'save',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit, IsEditable {
  @ViewChild(MetaeditorComponent) metaeditorComponent: MetaeditorComponent;

  permission: Permission = new Permission();
  primaryPermissions: Array<Permission> = [];
  permissionRequest: PermissionRequest = new PermissionRequest();
  permissionError: PermissionError = new PermissionError();
  projects: Array<Project> = [];
  roles: Array<Role> = [];
  permissions: Array<string> = [];
  showProgress: boolean = false;
  showProgressButton: boolean = false;
  editId = null;

  constructor(private client: PermissionClient, public coreService: CoreService, public route: ActivatedRoute,
    private userClient: UserClient, private projectClient: ProjectClient) {
    this.permissions = Constants.PERMISSIONS;
  }

  ngOnInit() {

    this.getRoles();

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

  getRoles() {
    this.userClient.roles().subscribe(
      (response) => {
        this.roles = response;
      }
    );
  }

  getDataById(id: string): Observable<Permission> {
    this.showProgress = true;
    return this.client.show(id).pipe(
      map((response) => {
        this.showProgress = false;
        this.permission = response;
        this.permissionRequest.role = this.permission.role;
        this.permissionRequest.permissions = this.permission.permissions.split(',');

        return response;
      }
      ))
  }

  savePermission() {
    this.showProgressButton = true;

    const formData: FormData = new FormData();
    
    if(!this.permissionRequest.new_role && !this.permissionRequest.role) {
      this.coreService.toastService.showToast(ToastStatus.SUCCESS, 'Failed', 'Role is required!');
    }

    if (this.permissionRequest.new_role) {
      formData.append('new_role', this.permissionRequest.new_role);
    } else {
      formData.append('role', this.permissionRequest.role);
    }

    for (let i = 0; i < this.permissionRequest.permissions.length; i++) {
      formData.append('permissions[]', this.permissionRequest.permissions[i]);
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
          if (err.error.errors.role) {
            this.permissionError.role = err.error.errors.role;
          }
        }
      },
    );
  }

  back() {
    this.coreService.location.back();
  }
}
