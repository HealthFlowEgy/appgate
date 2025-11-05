import { Building } from "../building/building";
import { Flat } from "../flat/flat";
import { Project } from "../project/project";
import { User } from "../user/user";

export class Resident {
  id: number;
  type: string;
  is_approved: boolean;
  meta: object;
  project_id: string;
  project: Project;
  building_id: string;
  building: Building;
  flat_id: string;
  flat: Flat;
  user_id: number;
  user: User;
}
