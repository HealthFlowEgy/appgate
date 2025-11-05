import { MediaUrl } from "../user/user";

export class Category {
    id: string;
    slug: string;
    title: string;
    title_translations: object;
    meta: object;
    parent_id: string;
    sort_order: string;
    mediaurls: MediaUrl;
}
