import { Category } from '../category/category';
import { MediaUrl, User } from '../user/user';
import { Author } from './author';
import { MediaContent } from './mediacontent';

export class Media {
    id: string;
    title: string;
    title_translations: object;
    meta: object;
    status: string;
    user: User;
    medialibrary: MediaUrl;
    content: Array<MediaContent>;
    comments_count: number = 0;
    likes_count: number = 0;
    views_count: number = 0;
}
