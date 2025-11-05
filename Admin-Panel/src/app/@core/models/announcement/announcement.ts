import { Project } from "../project/project";
import { AnnouncementOption } from "./announcement-option";

export class Announcement {
  id: number;
  type: string;
  message: string;
  posted_by: string;
  duedate: string;
  meta: object;
  project_id: string;
  project: Project;
  options: Array<AnnouncementOption>;
}
