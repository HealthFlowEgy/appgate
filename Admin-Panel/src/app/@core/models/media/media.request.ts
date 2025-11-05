export class MediaRequest {
    title_translations: string;
    meta: object = {type: ''};
    content_url: string;
    status: string;
    user_id: number;
    images: Array<File> = [];
}
