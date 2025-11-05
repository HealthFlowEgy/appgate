<?php

use function Pest\Laravel\postJson;

test('user can register with valid data', function () {
    $userData = [
        'name' => 'Test User',
        'email' => 'test@example.com',
        'password' => 'password123',
        'password_confirmation' => 'password123',
        'phone' => '+1234567890',
    ];

    $response = postJson('/api/register', $userData);

    $response->assertStatus(201)
        ->assertJsonStructure([
            'access_token',
            'token_type',
            'user' => [
                'id',
                'name',
                'email',
            ],
        ]);
});

test('user registration fails with invalid email', function () {
    $userData = [
        'name' => 'Test User',
        'email' => 'invalid-email',
        'password' => 'password123',
        'password_confirmation' => 'password123',
    ];

    $response = postJson('/api/register', $userData);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['email']);
});

test('user registration fails with mismatched passwords', function () {
    $userData = [
        'name' => 'Test User',
        'email' => 'test@example.com',
        'password' => 'password123',
        'password_confirmation' => 'different_password',
    ];

    $response = postJson('/api/register', $userData);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['password']);
});
