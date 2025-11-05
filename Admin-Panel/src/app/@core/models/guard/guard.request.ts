import { UserPartialRequest } from "../user/user-partial.request";

export class GuardRequest extends UserPartialRequest{
  meta: object = {};
  project_id: string;
}
