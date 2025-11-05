import {Servicebooking} from './servicebooking';
import {BaseListResponse} from '../base-list.response';

export class ServicebookingListResponse extends BaseListResponse {
  data: Array<Servicebooking>;
}
