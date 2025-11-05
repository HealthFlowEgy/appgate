import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {SupportListResponse} from '../models/support/support-list-response';

import {Support} from '../models/support/support';
import {BaseClient} from './base-client.service';

@Injectable()
export class SupportClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/supports';
  }

  public list(): Observable<SupportListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<SupportListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }
  
  public delete(id): Observable<any> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.delete<any>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }
}
