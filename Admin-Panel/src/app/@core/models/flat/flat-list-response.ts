import {Flat} from './flat';
import {BaseListResponse} from '../base-list.response';

export class FlatListResponse extends BaseListResponse {
  data: Array<Flat>;
}
