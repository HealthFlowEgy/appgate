import {Faq} from './faq';
import {BaseListResponse} from '../base-list.response';

export class FaqListResponse extends BaseListResponse {
  data: Array<Faq>;
}
