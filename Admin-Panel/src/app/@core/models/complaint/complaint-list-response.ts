import {Complaint} from './complaint';
import {BaseListResponse} from '../base-list.response';

export class ComplaintListResponse extends BaseListResponse {
  data: Array<Complaint>;
}
