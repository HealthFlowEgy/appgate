import {Project} from './project';
import {BaseListResponse} from '../base-list.response';

export class ProjectListResponse extends BaseListResponse {
  data: Array<Project>;
}
