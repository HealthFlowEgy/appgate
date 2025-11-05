import { Injectable } from '@angular/core';
import { FormArray, FormGroup, FormBuilder } from '@angular/forms';
import { AppConfigService } from '../../app-config.service';
import { TranslateService } from '@ngx-translate/core';
import { NbLayoutDirectionService, NbLayoutDirection } from '@nebular/theme';
import { AdminConfigClient } from '../network/adminconfig-client.service';
import { map } from 'rxjs/operators';
import { Observable, BehaviorSubject, forkJoin } from 'rxjs';
import { TranslationService } from './translation.service';
import { HttpClient } from '@angular/common/http';
import { NbAuthService } from '@nebular/auth';
import { Router, ActivatedRoute } from '@angular/router';
import { ToastService } from './toast.service';
import { Location } from '@angular/common';

@Injectable()
export class CoreService {
    constructor(public appConfigService: AppConfigService, public translationService: TranslationService,
        public http: HttpClient, public authService: NbAuthService, public router: Router,
        public toastService: ToastService, public location: Location,
        public translateService: TranslateService) {
    }

    slugify(text: string): string {
        return text.toString().toLowerCase()
            .replace(/\s+/g, '-')           // Replace spaces with -
            .replace(/[^\u0100-\uFFFF\w\-]/g, '-') // Remove all non-word chars ( fix for UTF-8 chars )
            .replace(/\-\-+/g, '-')         // Replace multiple - with single -
            .replace(/^-+/, '')             // Trim - from start of text
            .replace(/-+$/, '');            // Trim - from end of text
    }
}