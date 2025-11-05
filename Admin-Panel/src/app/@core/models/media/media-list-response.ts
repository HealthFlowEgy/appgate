import {BaseListResponse} from '../base-list.response';
import { Media } from './media';

export class MediaListResponse extends BaseListResponse {
  data: Array<Media>;
}
