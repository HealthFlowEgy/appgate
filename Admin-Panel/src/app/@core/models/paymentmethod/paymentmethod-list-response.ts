import {Paymentmethod} from './paymentmethod';
import {BaseListResponse} from '../base-list.response';

export class PaymentmethodListResponse extends BaseListResponse {
  data: Array<Paymentmethod>;
}
