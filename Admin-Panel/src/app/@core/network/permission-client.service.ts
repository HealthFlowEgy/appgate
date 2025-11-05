import { Injectable, Inject } from '@angular/core';
import { Observable } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { Constants } from '../models/constants.model';
import { BaseClient } from './base-client.service';
import { PermissionListResponse } from '../models/user/permission-list-response';
import { Permission } from '../models/user/permission';

@Injectable()
export class PermissionClient extends BaseClient {    
    
    public getBaseEndpoint() {
        return this.baseEndpoint + '/permissions';
    }
    
    public list(): Observable<PermissionListResponse> {
        return this.authService.getToken().pipe(switchMap((token) => {            
            return this.http.get<PermissionListResponse>(this.getBaseEndpoint(), {headers: this.getHeaders(token)});
        }));
    }

    public show(id: string): Observable<Permission> {
        return this.authService.getToken().pipe(switchMap((token) => {            
            return this.http.get<Permission>(this.getBaseEndpoint() + '/' + id, {headers: this.getHeaders(token)});
        }));
    }

    public store(formData: FormData): Observable<Permission> {        
        return this.authService.getToken().pipe(switchMap((token) => {            
            return this.http.post<Permission>(this.getBaseEndpoint(), formData, {headers: this.getHeaders(token, false)});
        }));
    }

    public update(id, formData: FormData): Observable<Permission> {
        formData.append('_method', 'PUT');
        return this.authService.getToken().pipe(switchMap((token) => {            
            return this.http.post<Permission>(this.getBaseEndpoint() + '/' + id, formData, {headers: this.getHeaders(token, false)});
        }));
    }

    public delete(id): Observable<any> {        
        return this.authService.getToken().pipe(switchMap((token) => {            
            return this.http.delete<any>(this.getBaseEndpoint() + '/' + id, {headers: this.getHeaders(token)});
        }));
    }
}