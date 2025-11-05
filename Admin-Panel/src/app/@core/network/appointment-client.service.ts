import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {AppointmentListResponse} from '../models/appointment/appointment-list-response';

import {Appointment} from '../models/appointment/appointment';
import {BaseClient} from './base-client.service';

@Injectable()
export class AppointmentClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/appointments';
  }

  public list(): Observable<AppointmentListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<AppointmentListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Appointment> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Appointment>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public update(id, formData: FormData): Observable<Appointment> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Appointment>(this.getBaseEndpoint() +  '/' + id, formData,
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
