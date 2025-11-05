import {Amenity} from './amenity';
import {BaseListResponse} from '../base-list.response';

export class AmenityListResponse extends BaseListResponse {
  data: Array<Amenity>;
}
