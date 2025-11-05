import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {ProviderListResponse} from '../models/provider/provider-list-response';

import {Provider} from '../models/provider/provider';
import {BaseClient} from './base-client.service';

@Injectable()
export class ProviderClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/provider/providerprofiles';
  }

  public list(): Observable<ProviderListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<ProviderListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Provider> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Provider>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Provider> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Provider>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Provider> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Provider>(this.getBaseEndpoint() +  '/' + id, formData,
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
