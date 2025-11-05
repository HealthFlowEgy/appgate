import {BaseListResponse} from '../base-list.response';
import { Episode } from './episode';

export class EpisodeListResponse extends BaseListResponse {
  data: Array<Episode>;
}
