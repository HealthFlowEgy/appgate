import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, Route, UrlSegment, CanLoad, Router } from '@angular/router';
import { NbAuthService } from '@nebular/auth';
import { tap } from 'rxjs/operators';
import { RoleService } from './role.service';

@Injectable({
    providedIn: 'root'
})
export class RouteGuardService implements CanLoad, CanActivate {

    constructor(private roleService: RoleService, private authService: NbAuthService, private router: Router) { }

    public canLoad(route: Route, segments: UrlSegment[]) {
        let key = null;

        if (segments.length == 1) {
            key = segments[0];
        } else if (segments.length > 1) {
            key = segments.slice(0, 2).join('/');
        }

        return this.canAccess(key);
    }

    public canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
        return this.roleService.hasRole('admin') || this.roleService.checkPermission(state.url.split('/').slice(2).join('/'));
    }

    private canAccess(key) {
        this.authService.isAuthenticated()
            .pipe(
                tap(authenticated => {
                    if (!authenticated) {
                        this.router.navigate(['auth/login']);
                    }
                }),
            ).subscribe();
        return this.roleService.hasRole('admin') || this.roleService.checkPermission(key);
    }
}