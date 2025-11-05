import { UserPartialError } from "../user/user-partial.error";

export class GuardError extends UserPartialError{
  meta: Array<string>;
  project_id: Array<string>;
}
