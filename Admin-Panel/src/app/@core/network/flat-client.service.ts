import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {FlatListResponse} from '../models/flat/flat-list-response';

import {Flat} from '../models/flat/flat';
import {BaseClient} from './base-client.service';

@Injectable()
export class FlatClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/flats';
  }

  public list(): Observable<FlatListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<FlatListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Flat> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Flat>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Flat> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Flat>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Flat> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Flat>(this.getBaseEndpoint() +  '/' + id, formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public delete(id): Observable<any> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.delete<any>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public all(building): Observable<Array<Flat>> {
    let url = this.getBaseEndpoint() + '?pagination=0';
    if(building) {
      url += '&building=' + building;
    }
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<Flat>>(url,
        {headers: this.getHeaders(token)});
    }));
  }
}
