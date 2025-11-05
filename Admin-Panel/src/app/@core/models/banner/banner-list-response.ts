import {Banner} from './banner';
import {BaseListResponse} from '../base-list.response';

export class BannerListResponse extends BaseListResponse {
  data: Array<Banner>;
}
