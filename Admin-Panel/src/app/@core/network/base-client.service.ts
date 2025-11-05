import { Injectable, Inject } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { NbAuthService, NbAuthToken } from '@nebular/auth';
import { AppConfigService } from '../../app-config.service';
import { CoreService } from '../service/core.service';
import { TranslateService } from '@ngx-translate/core';

@Injectable()
export class BaseClient {    
    public baseEndpoint;
    constructor(protected http: HttpClient, protected authService: NbAuthService, protected appConfigService: AppConfigService,
        protected translateService: TranslateService) {
        this.baseEndpoint = this.appConfigService.getConfig().apiBaseUrl;
    }        

    protected getHeaders(token: NbAuthToken, jsonContent: boolean = true): HttpHeaders {
        let headers = { 'Authorization': 'Bearer ' + token };

        if(jsonContent) {
            headers['Content-Type'] = 'application/json';
        }

        if(this.translateService.currentLang) {
            headers['X-Localization'] = this.translateService.currentLang;
        }

        return new HttpHeaders(headers);
    }    
}
