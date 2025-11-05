import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {BuildingListResponse} from '../models/building/building-list-response';

import {Building} from '../models/building/building';
import {BaseClient} from './base-client.service';

@Injectable()
export class BuildingClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/buildings';
  }

  public list(): Observable<BuildingListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<BuildingListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Building> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Building>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Building> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Building>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Building> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Building>(this.getBaseEndpoint() +  '/' + id, formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public delete(id): Observable<any> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.delete<any>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public all(project): Observable<Array<Building>> {
    let url = this.getBaseEndpoint() + '?pagination=0';
    if(project) {
      url += '&project=' + project;
    }
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<Building>>(url,
        {headers: this.getHeaders(token)});
    }));
  }
}
