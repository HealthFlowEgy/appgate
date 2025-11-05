<?php

namespace Tests\Feature;

use Tests\TestCase;

class AdminLoginTest extends TestCase
{
    /**
     * A basic test example.
     *
     * @return void
     */
    public function testAdminLogin()
    {
        $response = $this->post('/api/admin/login',[
            'email' => 'admin@example.com',
            'password' => 'admin'
        ]);

        $response->assertStatus(200);
    }
}
