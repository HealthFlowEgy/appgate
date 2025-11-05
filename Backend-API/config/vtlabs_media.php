<?php

return [
    'models' => [
        'media' => \Vtlabs\Media\Models\Media::class,
        'media_content' => \Vtlabs\Media\Models\MediaContent::class,
        'media_episode' => \Vtlabs\Media\Models\MediaEpisode::class
    ],
    'resources' => [
        'admin' => [
            'media' => \Vtlabs\Media\Http\Resources\Admin\MediaResource::class,
        ],
        'media' => \Vtlabs\Media\Http\Resources\MediaResource::class,
    ],
    'tables' => [
        'media' => 'media',
        'media_content' => 'media_content',
        'seasons' => 'seasons'
    ],
    'images' => [
        'thumb' => 50,
        'small' => 150,
        'medium' => 300,
        'large' => 500,
    ]
];
