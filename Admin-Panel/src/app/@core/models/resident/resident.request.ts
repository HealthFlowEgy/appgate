import { UserPartialRequest } from "../user/user-partial.request";

export class ResidentRequest extends UserPartialRequest{
  type: string;
  is_approved: boolean = false;
  meta: object = {};
  project_id: string;
  building_id: string;
  flat_id: string;
}
