import { Project } from "../project/project";

export class Building {
  id: number;
  title: string;
  meta: object;
  project_id: string;
  project: Project;
}
