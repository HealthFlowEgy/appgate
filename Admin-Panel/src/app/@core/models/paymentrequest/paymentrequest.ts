import { Flat } from "../flat/flat";
import { Project } from "../project/project";

export class Paymentrequest {
  id: number;
  title: string;
  amount: string;
  duedate: string;
  status: string;
  meta: object;
  project_id: string;
  project: Project;
  flat_id: string;
  flat: Flat;
}
