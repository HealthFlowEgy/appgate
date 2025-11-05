import {BaseListResponse} from '../base-list.response';

export class CommentListResponse extends BaseListResponse {
  data: Array<Comment>;
}
