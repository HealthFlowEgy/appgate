import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';

import {BaseClient} from './base-client.service';
import { VisitorlogListResponse } from '../models/visitorlog/visitorlog-list-response';
import { Visitorlog } from '../models/visitorlog/visitorlog';

@Injectable()
export class VisitorlogClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/visitorlogs';
  }

  public list(): Observable<VisitorlogListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<VisitorlogListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Visitorlog> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Visitorlog>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Visitorlog> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Visitorlog>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Visitorlog> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Visitorlog>(this.getBaseEndpoint() +  '/' + id, formData,
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
