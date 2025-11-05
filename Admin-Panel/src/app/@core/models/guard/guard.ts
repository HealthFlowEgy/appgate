import { Project } from "../project/project";
import { User } from "../user/user";

export class Guard {
  id: number;
  meta: object;
  project_id: string;
  project: Project;
  user_id: number;
  user: User;
}
