import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {ResidentListResponse} from '../models/resident/resident-list-response';

import {Resident} from '../models/resident/resident';
import {BaseClient} from './base-client.service';

@Injectable()
export class ResidentClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/residents';
  }

  public list(): Observable<ResidentListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<ResidentListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Resident> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Resident>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Resident> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Resident>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Resident> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Resident>(this.getBaseEndpoint() +  '/' + id, formData,
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
