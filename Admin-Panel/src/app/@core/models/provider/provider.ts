import { Subscription } from '../plan/subscription';
import { MediaUrl, User } from '../user/user';
import { ProviderAvailability } from './provider-availability';
import { ProviderCategory } from './provider-category';

export class Provider {
    id: string;
    name: string;
    name_translations: object;
    details: string;
    details_translations: object;
    meta: any;
    mediaurls: MediaUrl;
    fee: string;
    is_verified: boolean;
    experience_years: string;
    address: string;
    longitude: string;
    latitude: string;
    categories: Array<ProviderCategory>;
    subcategories: Array<ProviderCategory>;
    availability: Array<ProviderAvailability>;
    user: User;
    plan: Subscription;
}
