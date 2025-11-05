import { UserPartialError } from "../user/user-partial.error";

export class VisitorlogError extends UserPartialError{
  status: Array<string>;
}
