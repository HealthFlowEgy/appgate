import { EventEmitter, Output, SimpleChanges } from '@angular/core';
import { Component, OnDestroy, OnInit, Input } from '@angular/core';

import { FormGroup, FormArray, FormBuilder } from '@angular/forms';
import { CoreService } from '../../../@core/service/core.service';

@Component({
  selector: 'ngx-metaeditor',
  styleUrls: ['./metaeditor.component.scss'],
  templateUrl: './metaeditor.component.html',
})
export class MetaeditorComponent implements OnInit, OnDestroy {
  @Input() meta: object;

  @Output()
  metaChange: EventEmitter<object> = new EventEmitter<object>();

  listItems = {
    'scope': ['default', 'country', 'city', 'service'],
    'type': ['post', 'music']
  };

  metaForm: FormGroup;
  metaFormItems: FormArray;

  constructor(public coreService: CoreService, private formBuilder: FormBuilder) {
    this.metaForm = this.formBuilder.group({
      metafields: this.formBuilder.array([])
    });
  }

  ngOnDestroy(): void {
  }
  ngOnInit(): void {
  }

  ngOnChanges(changes: SimpleChanges) {
    this.meta = changes.meta.currentValue;
    this.addMetaFields();
  }

  get metafields() {
    return this.metaForm.get('metafields') as FormArray;
  }

  public addMetaFields() {
    if (this.meta) {
      this.metafields.clear();
      for (let key in this.meta) {
        this.addMetaField(key, this.meta[key]);
      }
    }
  }

  public addMetaField(key?, value?) {
    this.metafields.push(this.formBuilder.group({
      key: this.formBuilder.control(key),
      value: this.formBuilder.control(value)
    }));
  }

  public updatedMetaProperty() {
    this.meta = {};
    for (let i = 0; i < this.metafields.controls.length; i++) {
      const innerGroup = this.metafields.controls[i] as FormGroup;
      let key = innerGroup.controls.key.value;
      Object.assign(this.meta, { [key]: innerGroup.controls.value.value });
    }

    if(Object.keys(this.meta).length == 0) {
      this.meta = null;
    }
    
    this.metaChange.emit(this.meta)
  }

  public selectionChanged($event, key) {
    for (let i = 0; i < this.metafields.controls.length; i++) {
      const innerGroup = this.metafields.controls[i] as FormGroup;
      if (key == innerGroup.controls.key.value) {
        innerGroup.controls.value.setValue($event);
      }
    }
  }

  public deleteItem(index) {
    this.metafields.controls.splice(index, 1);
  }
}
