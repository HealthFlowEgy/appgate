import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { NB_AUTH_OPTIONS, NbAuthService, NbLoginComponent, NbPasswordAuthStrategy, NbAuthJWTToken } from '@nebular/auth';
import { Router } from '@angular/router';
import { AppConfigService } from '../../app-config.service';
import { CoreService } from '../../@core/service/core.service';
import { Observable } from 'rxjs';
import { RoleService } from '../../@core/utils/role.service';

class LanguageRequest {
  selectedLanguage = 'en';
}

@Component({
  selector: 'ngx-login',
  templateUrl: './login.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class NgxLoginComponent extends NbLoginComponent implements OnInit {
  languages: Observable<Array<string>> = null;
  language: LanguageRequest = new LanguageRequest();
  
  constructor(service: NbAuthService, @Inject(NB_AUTH_OPTIONS) protected options, cd: ChangeDetectorRef, router: Router, appConfig: AppConfigService, authStrategy: NbPasswordAuthStrategy,
    private coreService: CoreService, private roleService: RoleService) {
    super(service, options, cd, router);
    authStrategy.setOptions({
      name: 'email',
      token: {
        class: NbAuthJWTToken,
        key: 'token', // this parameter tells where to look for the token
      },
      baseEndpoint: appConfig.getConfig().apiBaseUrl,
      login: {
        // ...
        endpoint: '/login',
      },
    });

    let baseUrl = appConfig.getConfig().apiBaseUrl;
    if (baseUrl.indexOf('vtlabs.dev') > -1) {
      this.user.email = 'admin@example.com';
      this.user.password = 'admin';
    }

    this.languages = this.coreService.translationService.languagesSubject$;

    this.coreService.translationService.defaultLanguageAndDirectionSetup();
  }

  ngOnInit() {
    if (this.service.isAuthenticated()) {
      return this.router.navigateByUrl('/')
    }
  }


  login() {
    const _this = this;
    this.errors = [];
    this.messages = [];
    this.submitted = true;
    this.service.authenticate(this.strategy, this.user).subscribe(function (result) {
      _this.submitted = false;
      if (result.isSuccess()) {
        _this.messages = result.getMessages();
        if (result.getResponse().body.store_id) {
          localStorage.setItem('store_id', result.getResponse().body.store_id);
        }

        if (result.getResponse().body && result.getResponse().body.user && result.getResponse().body.user.roles) {
          _this.roleService.saveRoles(result.getResponse().body.user.roles);
          _this.roleService.savePermissions(result.getResponse().body.permissions);
        }

        // language
        localStorage.setItem('selected_language', _this.language.selectedLanguage)
      } else {
        _this.errors = result.getErrors();
      }
      const redirect = result.getRedirect();
      if (redirect) {
        setTimeout(function () {
          _this.coreService.translationService.languageAndDirectionSetup();
          return _this.router.navigateByUrl(redirect);
        }, _this.redirectDelay);
      }
      _this.cd.detectChanges();
    });
  }
}
