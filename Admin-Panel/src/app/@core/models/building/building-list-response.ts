import {Building} from './building';
import {BaseListResponse} from '../base-list.response';

export class BuildingListResponse extends BaseListResponse {
  data: Array<Building>;
}
