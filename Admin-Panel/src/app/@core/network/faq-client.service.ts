import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {FaqListResponse} from '../models/faq/faq-list-response';

import {Faq} from '../models/faq/faq';
import {BaseClient} from './base-client.service';

@Injectable()
export class FaqClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/faqs';
  }

  public list(): Observable<FaqListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<FaqListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Faq> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Faq>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Faq> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Faq>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Faq> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Faq>(this.getBaseEndpoint() +  '/' + id, formData,
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
