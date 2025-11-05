import { UserPartialError } from "../user/user-partial.error";

export class ResidentError extends UserPartialError{
  type: Array<string>;
  is_approved: Array<string>;
  meta: Array<string>;
  project_id: Array<string>;
  building_id: Array<string>;
  flat_id: Array<string>;
  user_id: Array<string>;
}
