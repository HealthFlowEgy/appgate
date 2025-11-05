import {Announcement} from './announcement';
import {BaseListResponse} from '../base-list.response';

export class AnnouncementListResponse extends BaseListResponse {
  data: Array<Announcement>;
}
