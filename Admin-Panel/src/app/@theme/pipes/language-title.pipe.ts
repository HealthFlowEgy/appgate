import { Pipe, PipeTransform } from '@angular/core';
import { Constants } from '../../@core/models/constants.model';

@Pipe({name: 'languageTitle'})
export class LanguageTitlePipe implements PipeTransform {
  transform(value: string): string {
    return Constants.languages[value];
  }
}