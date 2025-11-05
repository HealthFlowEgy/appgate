import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {PaymentmethodListResponse} from '../models/paymentmethod/paymentmethod-list-response';

import {Paymentmethod} from '../models/paymentmethod/paymentmethod';
import {BaseClient} from './base-client.service';

@Injectable()
export class PaymentmethodClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/paymentmethods';
  }

  public list(): Observable<PaymentmethodListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<PaymentmethodListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Paymentmethod> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Paymentmethod>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Paymentmethod> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Paymentmethod>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Paymentmethod> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Paymentmethod>(this.getBaseEndpoint() +  '/' + id, formData,
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
