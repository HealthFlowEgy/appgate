import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {ProjectListResponse} from '../models/project/project-list-response';

import {Project} from '../models/project/project';
import {BaseClient} from './base-client.service';

@Injectable()
export class ProjectClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/projects';
  }

  public list(pagination): Observable<ProjectListResponse> {
    let url = this.getBaseEndpoint();
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<ProjectListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Project> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Project>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Project> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Project>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Project> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Project>(this.getBaseEndpoint() +  '/' + id, formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public all(city): Observable<Array<Project>> {
    let url = this.getBaseEndpoint() + '?pagination=0';
    if(city) {
      url += '&city=' + city;
    }
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<Project>>(url,
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
