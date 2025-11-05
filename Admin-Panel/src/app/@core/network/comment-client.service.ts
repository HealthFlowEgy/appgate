import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {CommentListResponse} from '../models/comment/comment-list-response';

import {Comment} from '../models/comment/comment';
import {BaseClient} from './base-client.service';

@Injectable()
export class CommentClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/comments';
  }

  public list(): Observable<CommentListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<CommentListResponse>(this.getBaseEndpoint(),
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
