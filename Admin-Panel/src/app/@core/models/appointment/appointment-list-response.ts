import {Appointment} from './appointment';
import {BaseListResponse} from '../base-list.response';

export class AppointmentListResponse extends BaseListResponse {
  data: Array<Appointment>;
}
