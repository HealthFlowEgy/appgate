import { Injectable, Inject } from '@angular/core';
import { Observable } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { PlanListResponse } from '../models/plan/plan-list-response';

import { Plan } from '../models/plan/plan';
import { BaseClient } from './base-client.service';

@Injectable()
export class PlanClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/provider/plans';
  }

  public list(): Observable<PlanListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<PlanListResponse>(this.getBaseEndpoint(),
        { headers: this.getHeaders(token) });
    }));
  }

  public show(id: string): Observable<Plan> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Plan>(this.getBaseEndpoint() + '/' + id,
        { headers: this.getHeaders(token) });
    }));
  }

  public store(formData: FormData): Observable<Plan> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Plan>(this.getBaseEndpoint(), formData,
        { headers: this.getHeaders(token, false) });
    }));
  }

  public update(id, formData: FormData): Observable<Plan> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Plan>(this.getBaseEndpoint() + '/' + id, formData,
        { headers: this.getHeaders(token, false) });
    }));
  }

  public delete(id): Observable<any> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.delete<any>(this.getBaseEndpoint() + '/' + id,
        { headers: this.getHeaders(token) });
    }));
  }

  public all(): Observable<Array<Plan>> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<Plan>>(this.getBaseEndpoint() + '?pagination=0',
        { headers: this.getHeaders(token) });
    }));
  }
}
