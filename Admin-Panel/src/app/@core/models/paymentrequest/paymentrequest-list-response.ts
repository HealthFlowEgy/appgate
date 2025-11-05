import {Paymentrequest} from './paymentrequest';
import {BaseListResponse} from '../base-list.response';

export class PaymentrequestListResponse extends BaseListResponse {
  data: Array<Paymentrequest>;
}
