
import { User } from '../user/user';

export class Transaction {
    id: number;
    amount: number;
    type: string;
    meta: object;
    created_at: string;
    user: User;
}