import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {BannerListResponse} from '../models/banner/banner-list-response';

import {Banner} from '../models/banner/banner';
import {BaseClient} from './base-client.service';

@Injectable()
export class BannerClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/banners';
  }

  public list(): Observable<BannerListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<BannerListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Banner> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Banner>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Banner> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Banner>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Banner> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Banner>(this.getBaseEndpoint() +  '/' + id, formData,
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
