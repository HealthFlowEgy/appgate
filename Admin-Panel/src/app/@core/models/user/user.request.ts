export class UserRequest {
  name: string;
  email: string;
  image: File;
  mobile_number: string;
  password: string;
  roles: Array<string>;
  mobile_verified: boolean = false;
  language: string;
  balance: number = 0;
  meta: any = {project_id: null};
}
