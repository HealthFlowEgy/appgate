import { UserPartialError } from "../user/user-partial.error";

export class PaymentrequestError {
  title: Array<string>;
  amount: Array<string>;
  duedate: Array<string>;
  status: Array<string>;
  meta: Array<string>;
  project_id: Array<string>;
  flat_id: Array<string>;
}
