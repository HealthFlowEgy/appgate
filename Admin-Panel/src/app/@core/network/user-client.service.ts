import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';

import {BaseClient} from './base-client.service';
import {UserListResponse} from '../models/user/user-list-response';
import {User} from '../models/user/user';
import {Role} from '../models/user/role';

@Injectable()
export class UserClient extends BaseClient {
  
  public getBaseEndpoint() {
    return this.baseEndpoint + '/users';
  }

  public list(): Observable<UserListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<UserListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<User> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<User>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<User> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<User>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<User> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<User>(this.getBaseEndpoint() + '/' + id, formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public delete(id): Observable<any> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.delete<any>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public roles(): Observable<Array<Role>> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<Role>>(this.getBaseEndpoint() + '/roles',
        {headers: this.getHeaders(token)});
    }));
  }

  public all(): Observable<Array<User>> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<User>>(this.getBaseEndpoint() + '?pagination=0',
        {headers: this.getHeaders(token)});
    }));
  }

}
