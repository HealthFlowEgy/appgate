import {Guard} from './guard';
import {BaseListResponse} from '../base-list.response';

export class GuardListResponse extends BaseListResponse {
  data: Array<Guard>;
}
