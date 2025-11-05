import { Project } from "../project/project";

export class Amenity {
  id: number;
  title: string;
  description: string;
  fee: string;
  capacity: string;
  booking_capacity: string;
  advance_booking_days: string;
  max_days_per_flat: string;
  meta: object;
  project_id: string;
  project: Project;
}
