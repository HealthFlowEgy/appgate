import { Amenity } from "../amenity/amenity";
import { Payment } from "../paymentmethod/payment";
import { Resident } from "../resident/resident";
import { User } from "../user/user";

export class Appointment {
  id: number;
  amount: string;
  amount_meta: string;
  meta: any;
  address: string;
  address_meta: string;
  longitude: string;
  latitude: string;
  date: string;
  date_to: string;
  time_from: string;
  time_to: string;
  resident: Resident;
  amenity: Amenity;
  payment: Payment;
  status: string;
  created_at: string;
}
