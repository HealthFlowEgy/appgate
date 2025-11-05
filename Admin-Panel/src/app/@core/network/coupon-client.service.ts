import {Injectable, Inject} from '@angular/core';
import {HttpClient, HttpHeaders, HttpParams} from '@angular/common/http';
import {Observable} from 'rxjs';
import {NbAuthService, NbAuthToken} from '@nebular/auth';
import {switchMap} from 'rxjs/operators';
import {CouponListResponse} from '../models/coupon/coupon-list-response';

import {Coupon} from '../models/coupon/coupon';
import {BaseClient} from './base-client.service';

@Injectable()
export class CouponClient extends BaseClient {
  
  public getBaseEndpoint() {
    return this.baseEndpoint + '/coupons';
  }

  public list(): Observable<CouponListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<CouponListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Coupon> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Coupon>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Coupon> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Coupon>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Coupon> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Coupon>(this.getBaseEndpoint() +  '/' + id, formData,
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
