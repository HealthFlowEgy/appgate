import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {PaymentrequestListResponse} from '../models/paymentrequest/paymentrequest-list-response';

import {Paymentrequest} from '../models/paymentrequest/paymentrequest';
import {BaseClient} from './base-client.service';

@Injectable()
export class PaymentrequestClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/paymentrequests';
  }

  public list(): Observable<PaymentrequestListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<PaymentrequestListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Paymentrequest> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Paymentrequest>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Paymentrequest> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Paymentrequest>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Paymentrequest> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Paymentrequest>(this.getBaseEndpoint() +  '/' + id, formData,
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
