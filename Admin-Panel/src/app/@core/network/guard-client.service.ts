import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {GuardListResponse} from '../models/guard/guard-list-response';

import {Guard} from '../models/guard/guard';
import {BaseClient} from './base-client.service';

@Injectable()
export class GuardClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/guards';
  }

  public list(): Observable<GuardListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<GuardListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Guard> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Guard>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Guard> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Guard>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Guard> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Guard>(this.getBaseEndpoint() +  '/' + id, formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public delete(id): Observable<any> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.delete<any>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }
}
