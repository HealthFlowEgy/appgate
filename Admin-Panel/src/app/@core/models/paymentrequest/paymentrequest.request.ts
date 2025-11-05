import { UserPartialRequest } from "../user/user-partial.request";

export class PaymentrequestRequest {
  title: string;
  amount: string;
  duedate: string;
  status: string;
  meta: object = {};
  project_id: string;
  flat_id: string;
}
