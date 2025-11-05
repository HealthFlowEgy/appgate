import {Visitorlog} from './visitorlog';
import {BaseListResponse} from '../base-list.response';

export class VisitorlogListResponse extends BaseListResponse {
  data: Array<Visitorlog>;
}
