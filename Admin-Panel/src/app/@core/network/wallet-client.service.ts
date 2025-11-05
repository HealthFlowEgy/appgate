import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';

import {BaseClient} from './base-client.service';
import {UserListResponse} from '../models/user/user-list-response';
import {User} from '../models/user/user';
import {Role} from '../models/user/role';

@Injectable()
export class WalletClient extends BaseClient {
  
  public getBaseEndpoint() {
    return this.baseEndpoint + '/wallet';
  }

  public transactions(): Observable<UserListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<UserListResponse>(this.getBaseEndpoint() + '/transactions',
        {headers: this.getHeaders(token)});
    }));
  }
}
