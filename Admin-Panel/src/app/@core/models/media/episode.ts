
import { Media } from './media';

export class Episode {
    id: string;
    episode_number: string;
    season_number: string;
    media: Media;
    parent_media_id: string;
}
