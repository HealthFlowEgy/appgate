import { Injectable, Inject } from '@angular/core';
import { Observable } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { CategoryListResponse } from '../models/category/category-list-response';

import { Category } from '../models/category/category';
import { BaseClient } from './base-client.service';

@Injectable()
export class CategoryClient extends BaseClient {

  public getBaseEndpoint() {
    return this.baseEndpoint + '/categories';
  }

  public list(): Observable<CategoryListResponse> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<CategoryListResponse>(this.getBaseEndpoint(),
        { headers: this.getHeaders(token) });
    }));
  }

  public show(id: string): Observable<Category> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Category>(this.getBaseEndpoint() + '/' + id,
        { headers: this.getHeaders(token) });
    }));
  }

  public store(formData: FormData): Observable<Category> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Category>(this.getBaseEndpoint(), formData,
        { headers: this.getHeaders(token, false) });
    }));
  }

  public update(id, formData: FormData): Observable<Category> {
    formData.append('_method', 'PUT');
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.post<Category>(this.getBaseEndpoint() + '/' + id, formData,
        { headers: this.getHeaders(token, false) });
    }));
  }

  public delete(id): Observable<any> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.delete<any>(this.getBaseEndpoint() + '/' + id,
        { headers: this.getHeaders(token) });
    }));
  }

  public parent(scope): Observable<Array<Category>> {
    let url = this.getBaseEndpoint() + '?parent=1&pagination=0';
    if(scope) {
      url += '&scope=' + scope;
    }
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<Category>>(url,
        { headers: this.getHeaders(token) });
    }));
  }

  public all(scope): Observable<Array<Category>> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<Category>>(this.getBaseEndpoint() + '?pagination=0&scope=' + scope,
        { headers: this.getHeaders(token) });
    }));
  }

  public subcategory(parentId): Observable<Array<Category>> {
    return this.authService.getToken().pipe(switchMap((token) => {
      return this.http.get<Array<Category>>(this.getBaseEndpoint() + '?categories=' + parentId + '&pagination=0',
        { headers: this.getHeaders(token) });
    }));
  }

}
