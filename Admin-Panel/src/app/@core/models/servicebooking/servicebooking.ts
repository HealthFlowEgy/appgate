import { Category } from "../category/category";
import { Flat } from "../flat/flat";
import { Project } from "../project/project";
import { User } from "../user/user";

export class Servicebooking {
  id: number;
  details: string;
  date: string;
  time_from: string;
  status: string;
  meta: object;
  service_id: string;
  service: Category;
  project_id: string;
  project: Project;
  flat_id: string;
  flat: Flat;
  user_id: number;
  user: User;
}
