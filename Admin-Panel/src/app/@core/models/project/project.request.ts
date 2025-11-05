export class ProjectRequest {
  title: string;
  address: string;
  latitude: string;
  longitude: string;
  meta: object = { "fire_alert": "", "lift_alert": "", "animal_alert": "", "visitor_alert": "" };
  city_id: string;
}
