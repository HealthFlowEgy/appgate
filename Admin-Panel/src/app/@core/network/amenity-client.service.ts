import {Injectable, Inject} from '@angular/core';
import {Observable} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {AmenityListResponse} from '../models/amenity/amenity-list-response';

import {Amenity} from '../models/amenity/amenity';
import {BaseClient} from './base-client.service';

@Injectable()
export class AmenityClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/gateapp/amenities';
  }

  public list(): Observable<AmenityListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<AmenityListResponse>(this.getBaseEndpoint(),
        {headers: this.getHeaders(token)});
    }));
  }

  public show(id: string): Observable<Amenity> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Amenity>(this.getBaseEndpoint() + '/' + id,
        {headers: this.getHeaders(token)});
    }));
  }

  public store(formData: FormData): Observable<Amenity> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Amenity>(this.getBaseEndpoint(), formData,
        {headers: this.getHeaders(token, false)});
    }));
  }

  public update(id, formData: FormData): Observable<Amenity> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Amenity>(this.getBaseEndpoint() +  '/' + id, formData,
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
