import { AnnouncementOption } from "./announcement-option";

export class AnnouncementRequest {
  type: string;
  message: string;
  posted_by: string;
  duedate: string;
  meta = {};
  project_id: string;
  options: Array<AnnouncementOption>;
}
