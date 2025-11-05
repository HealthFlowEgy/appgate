import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {ServicebookingListResponse} from '../models/servicebooking/servicebooking-list-response';

import {Servicebooking} from '../models/servicebooking/servicebooking';
import {BaseClient} from './base-client.service';

@Injectable()
export class ServicebookingClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/servicebookings';
  }

  public list(): Observable<ServicebookingListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<ServicebookingListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Servicebooking> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Servicebooking>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Servicebooking> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Servicebooking>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Servicebooking> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Servicebooking>(this.getBaseEndpoint() +  '/' + id, formData,
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
