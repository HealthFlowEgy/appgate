import {Injectable, Inject} from '@angular/core';
import {HttpClient, HttpHeaders, HttpParams} from '@angular/common/http';
import {Observable} from 'rxjs';
import {NbAuthService, NbAuthToken} from '@nebular/auth';
import {switchMap} from 'rxjs/operators';

import {BaseClient} from './base-client.service';
import {Setting} from '../models/setting/setting';
import {Env} from '../models/setting/env';

@Injectable()
export class SettingClient extends BaseClient {
  
  public getBaseEndpoint() {
    return this.baseEndpoint + '/settings';
  }

  public list(): Observable<Array<Setting>> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<Setting>>(this.getBaseEndpoint(), {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<any> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<any>(this.getBaseEndpoint(), formData, {headers: this.getHeaders(token, false)});
    }));
  }

  public envList(): Observable<Env> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Env>(this.getBaseEndpoint() + '/env', {headers: this.getHeaders(token)});
    }));
  }

  public updateEnv(formData: FormData): Observable<any> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<any>(this.getBaseEndpoint() + '/env',
        formData, {headers: this.getHeaders(token, false)});
    }));
  }


}
