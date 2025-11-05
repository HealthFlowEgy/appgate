import {Role} from './role';
import { Wallet } from './wallet';

export class MediaImage {
  default: string;
}

export class MediaUrl {
  images: Array<MediaImage>;
}

export class User {
  id: number;
  name: string;
  email: string;
  mobile_number: string;
  roles: Array<Role>;
  mobile_verified: boolean;
  language: string;
  meta: object;
  notification: any;
  mediaurls: any;
  wallet: Wallet;
  balance: number;
}
