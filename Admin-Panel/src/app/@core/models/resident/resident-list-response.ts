import {Resident} from './resident';
import {BaseListResponse} from '../base-list.response';

export class ResidentListResponse extends BaseListResponse {
  data: Array<Resident>;
}
