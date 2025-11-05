import { User } from "../user/user";

export class Comment {
  id: string;
  comment: string;
  user: User;
  created_at: string;
}
