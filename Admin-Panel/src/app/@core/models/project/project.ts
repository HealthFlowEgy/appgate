import { Category } from "../category/category";

export class Project {
  id: number;
  title: string;
  address: string;
  latitude: string;
  longitude: string;
  meta: object;
  city_id: string;
  city: Category;
}
