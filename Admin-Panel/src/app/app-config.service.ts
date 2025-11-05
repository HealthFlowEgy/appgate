import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
    providedIn: 'root'
})
export class AppConfigService {
    private appConfig;

    constructor(private httpClient: HttpClient) { }

    loadAppConfig() {
        return new Promise((resolve, reject) => {
            this.httpClient.get("assets/appConfig.json")
                .toPromise()
                .then(response => {
                    this.appConfig = response;
                    resolve(response);
                });
        });

    }

    getConfig() {
        return this.appConfig;
    }
}