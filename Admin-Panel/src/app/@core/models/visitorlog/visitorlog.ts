import { Building } from "../building/building";
import { Flat } from "../flat/flat";
import { Project } from "../project/project";
import { User } from "../user/user";

export class Visitorlog {
  id: number;
  code: string;
  type: string;
  name: string;
  contact: string;
  company_name: string;
  vehicle_number: string;
  pax: string;
  intime: string;
  outtime: string;
  meta: object;
  status: string;
  project_id: string;
  project: Project;
  building_id: string;
  building: Building;
  flat_id: string;
  flat: Flat;
  user_id: number;
  user: User;
}
