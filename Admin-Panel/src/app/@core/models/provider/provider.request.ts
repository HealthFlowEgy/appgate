import { UserPartialRequest } from '../user/user-partial.request';
import { ProviderAvailability } from './provider-availability';

export class ProviderRequest extends UserPartialRequest {
    name_translations: string;
    details_translations: string;
    meta: any = {};
    images: Array<File> = [];
    fee: string;
    is_verified: boolean = false;
    address: string;
    longitude: string;
    latitude: string;
    categories: Array<string> = [];
    subcategories: Array<string> = [];
    availability: Array<ProviderAvailability>;
    plan_id: string;
}
