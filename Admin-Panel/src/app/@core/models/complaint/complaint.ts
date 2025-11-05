import { Project } from "../project/project";
import { User } from "../user/user";

export class Complaint {
  id: number;
  type: string;
  message: string;
  status: string;
  meta: object;
  user_id: number;
  user: User;
  project_id: number;
  project: Project;
}
