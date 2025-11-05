import { Injectable } from '@angular/core';
import { Permission } from '../models/user/permission';
import { Role } from '../models/user/role';

@Injectable()
export class RoleService {
    saveRoles(roles: Array<Role>) {
        if (roles) {
            localStorage.setItem('roles', JSON.stringify(roles));
        }
    }

    hasRole(name: string) {
        let roles: Array<Role> = JSON.parse(localStorage.getItem('roles'));
        if (roles) {
            for (let i = 0; i < roles.length; i++) {
                if (roles[i].name == name) {
                    return true;
                }
            }
        }
        return false;
    }

    checkRolesExists(names: string[]) {
        let roles: Array<Role> = JSON.parse(localStorage.getItem('roles'));
        if (roles) {
            for (let i = 0; i < roles.length; i++) {
                for (let j = 0; j < names.length; j++) {
                    if (roles[i].name == names[j]) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    savePermissions(permissions: Array<Permission>) {
        if (permissions) {
            localStorage.setItem('permissions', JSON.stringify(permissions));
        }
    }

    checkPermission(key: string) {
        if(this.hasRole('admin')) {
            return true;
        }
        
        let permission: Permission = JSON.parse(localStorage.getItem('permissions'));
        if (permission) {
            let permissions = permission.permissions.split(',');
            for (let i = 0; i < permissions.length; i++) {
                if (key == (permissions[i])) {
                    return true;
                }
            }
        }
        return false;
    }
}