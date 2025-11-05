import { Injectable } from '@angular/core';
import { FormArray, FormGroup, FormBuilder } from '@angular/forms';
import { AppConfigService } from '../../app-config.service';
import { TranslateService } from '@ngx-translate/core';
import { NbLayoutDirectionService, NbLayoutDirection } from '@nebular/theme';
import { AdminConfigClient } from '../network/adminconfig-client.service';
import { map } from 'rxjs/operators';
import { Observable, BehaviorSubject, forkJoin } from 'rxjs';

@Injectable()
export class TranslationService
{
    languages = [];
    languagesSubject$: BehaviorSubject<Array<string>> = new BehaviorSubject([]);
    
    constructor(protected appConfigService: AppConfigService, private formBuilder: FormBuilder,
        private translate: TranslateService, private directionService: NbLayoutDirectionService,
        private adminConfigClient: AdminConfigClient) {
            let languages = localStorage.getItem("languages");
            this.languages = languages ? JSON.parse(languages) : ['en'];

            this.languagesSubject$.next(this.languages);

            this.fetchLanguages().subscribe();
    }        
    
    fetchLanguages(): Observable<Array<string>> {
        return this.adminConfigClient.languages().pipe(
            map(_ => {
                this.languages = _;
                localStorage.setItem("languages", JSON.stringify(_));
                this.languagesSubject$.next(this.languages);
                return _;
            }));
    }

    buildFormGroup(data) {
        return this.formBuilder.group({
            items: this.formBuilder.array(this.languages.map(_ => {
                return this.formBuilder.control(data && data[_] ? data[_] : '');
            })),
        });
    }

    buildRequestParam(groupForm) {
        let translations = [];
        const group = groupForm.controls.items as FormArray;
        for (let i = 0; i < group.controls.length; i++) {
            let value = group.controls[i].value
                ? {'language' : this.languages[i],'text' : group.controls[i].value}
                : null;
            translations[i] = value;
        }
        return JSON.stringify(translations.filter(_ => _ != null));
    }

    languageAndDirectionSetup() {
        // this language will be used as a fallback when a translation isn't found in the current language
        this.translate.setDefaultLang('en');

        // the lang to use, if the lang isn't available, it will use the current loader to get them
        let language = this.currentLanguage();
        this.translate.use(language);

        if(this.isRtl(language)) {
            this.directionService.setDirection(NbLayoutDirection.RTL);
        } else {
            this.directionService.setDirection(NbLayoutDirection.LTR);
        }
    }

    defaultLanguageAndDirectionSetup() {
        // reset language and direction for login
        this.translate.use('en');
        this.directionService.setDirection(NbLayoutDirection.LTR);
    }

    transformColumns(columns: Array<any>): Observable<any> {
        const translations$ = [
        //   this.translate.get("CATEGORY.FIELD.TITLE.LABEL").pipe(map(_ => headers.title = _)),
        //   this.translate.get("COMMON.ACTIONS").pipe(map(_ => headers.actions = _))
        ];
        for (let i = 0; i< columns.length; i++) {
            translations$.push(this.translate.get(columns[i].translation_key).pipe(map(_ => columns[i].column.title = _)));
        }
    
        return forkJoin(translations$);
    }

    currentLanguage()
    {
        let language = localStorage.getItem("selected_language");

        return language ? language : 'en';
    }

    private isRtl(language) {
        // rtl languages
        let rtlLanguages = ['iw', 'he', 'ur', 'ar', 'fa', 'dv'];
        return rtlLanguages.indexOf(language) > -1 ? true : false;
      }
}