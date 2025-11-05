import {Transaction} from './transaction';
import {BaseListResponse} from '../base-list.response';

export class TransactionListResponse extends BaseListResponse {
  data: Array<Transaction>;
}
