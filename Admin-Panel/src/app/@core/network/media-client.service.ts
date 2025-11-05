import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {MediaListResponse} from '../models/media/media-list-response';

import {Media} from '../models/media/media';
import {BaseClient} from './base-client.service';

@Injectable()
export class MediaClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/media';
  }

  public list(): Observable<MediaListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<MediaListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Media> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Media>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Media> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Media>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Media> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Media>(this.getBaseEndpoint() +  '/' + id, formData,
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
