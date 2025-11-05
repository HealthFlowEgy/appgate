import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {ComplaintListResponse} from '../models/complaint/complaint-list-response';

import {Complaint} from '../models/complaint/complaint';
import {BaseClient} from './base-client.service';

@Injectable()
export class ComplaintClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/complaints';
  }

  public list(): Observable<ComplaintListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<ComplaintListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Complaint> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Complaint>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Complaint> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Complaint>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Complaint> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Complaint>(this.getBaseEndpoint() +  '/' + id, formData,
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
