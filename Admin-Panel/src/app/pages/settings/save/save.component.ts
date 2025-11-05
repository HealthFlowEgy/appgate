import {Component, OnInit} from '@angular/core';
import {Router, ActivatedRoute, ParamMap} from '@angular/router';

import {SettingClient} from '../../../@core/network/setting-client.service';
import {Setting} from '../../../@core/models/setting/setting';
import { CoreService } from '../../../@core/service/core.service';
import { ToastStatus } from '../../../@core/service/toast.service';

@Component({
  selector: 'edit-setting',
  templateUrl: './save.component.html',
})
export class SaveComponent implements OnInit {    
  updatedSettings: any = {};
  settings: Array<Setting> = [];
  showProgress: boolean = false;
  showProgressButton: boolean = false;  
  
  constructor(private client: SettingClient, private coreService: CoreService) {
    
  }  
  
  ngOnInit() {    
    this.getSettings();
  }
  
  getSettings() {
    this.client.list().subscribe(
      (response) => { 
        this.settings = response;
        for(let i=0; i<this.settings.length; i++) {
          this.updatedSettings[this.settings[i].key] = this.settings[i].value;
        }
      }
    );
  } 
  
  updateSetting() {
    this.showProgressButton = true;

    const formData: FormData = new FormData();
    
    for (let key in this.updatedSettings) {
      formData.append(key, this.updatedSettings[key]);    
    }
    
    this.client.store(formData).subscribe(
      res => {
        this.showProgressButton = false;
        this.coreService.toastService.showToast(ToastStatus.SUCCESS, 'Saved', 'Saved successfully!');        
      },
      err => {          
        this.showProgressButton = false;
        this.coreService.toastService.showToast(ToastStatus.SUCCESS, 'Failed', err.error.message);        
      }
    );
  }
  
  formatKey(key) {
    return key.replace(/\_/g, " ");
  }
}
