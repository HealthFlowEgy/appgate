<?php

use function Pest\Laravel\get;

test('health check endpoint returns healthy status', function () {
    $response = get('/health');

    $response->assertStatus(200)
        ->assertJson([
            'status' => 'healthy',
            'service' => 'AppsGate API',
        ]);
});

test('detailed health check returns all checks', function () {
    $response = get('/health/detailed');

    $response->assertStatus(200)
        ->assertJsonStructure([
            'status',
            'timestamp',
            'service',
            'version',
            'checks' => [
                'database',
                'redis',
                'storage',
            ],
        ]);
});
