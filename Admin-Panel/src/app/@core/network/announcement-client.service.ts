import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {AnnouncementListResponse} from '../models/announcement/announcement-list-response';

import {Announcement} from '../models/announcement/announcement';
import {BaseClient} from './base-client.service';

@Injectable()
export class AnnouncementClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/announcements';
  }

  public list(): Observable<AnnouncementListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<AnnouncementListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Announcement> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Announcement>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Announcement> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Announcement>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Announcement> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Announcement>(this.getBaseEndpoint() +  '/' + id, formData,
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
