export class EpisodeRequest {
    season_number: string;
    episode_number: string;
    parent_media_id: string;
    title_translations: string;
    description_translations: string;
    short_description_translations: string;
    meta: object = {};
    length: string;
    language: string;
    artists: string;
    release_date: string;
    status: string;
    images: Array<File> = [];
}
