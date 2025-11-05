import {Injectable, Inject} from '@angular/core';
import {HttpClient, HttpHeaders, HttpParams} from '@angular/common/http';
import {Observable} from 'rxjs';
import {NbAuthService, NbAuthToken} from '@nebular/auth';
import {switchMap} from 'rxjs/operators';

import {BaseClient} from './base-client.service';

@Injectable()
export class AdminConfigClient extends BaseClient {
  
  public getBaseEndpoint() {
    return this.baseEndpoint + '/config';
  }

  public languages(): Observable<Array<string>> {
    return this.http.get<Array<string>>(this.getBaseEndpoint() + '/languages');
  }
}
