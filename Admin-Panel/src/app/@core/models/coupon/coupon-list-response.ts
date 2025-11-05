import {Coupon} from './coupon';
import {BaseListResponse} from '../base-list.response';

export class CouponListResponse extends BaseListResponse {
  data: Array<Coupon>;
}
