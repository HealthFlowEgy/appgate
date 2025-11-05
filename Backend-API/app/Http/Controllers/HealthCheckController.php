<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Redis;
use Illuminate\Support\Facades\Cache;

class HealthCheckController extends Controller
{
    /**
     * Basic health check endpoint
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        return response()->json([
            'status' => 'healthy',
            'timestamp' => now()->toIso8601String(),
            'service' => 'AppsGate API',
            'version' => config('app.version', '1.0.0'),
        ]);
    }

    /**
     * Detailed health check with dependencies
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function detailed()
    {
        $checks = [
            'database' => $this->checkDatabase(),
            'redis' => $this->checkRedis(),
            'storage' => $this->checkStorage(),
        ];

        $allHealthy = collect($checks)->every(fn($check) => $check['status'] === 'healthy');

        return response()->json([
            'status' => $allHealthy ? 'healthy' : 'degraded',
            'timestamp' => now()->toIso8601String(),
            'service' => 'AppsGate API',
            'version' => config('app.version', '1.0.0'),
            'checks' => $checks,
        ], $allHealthy ? 200 : 503);
    }

    /**
     * Check database connectivity
     *
     * @return array
     */
    private function checkDatabase(): array
    {
        try {
            DB::connection()->getPdo();
            return [
                'status' => 'healthy',
                'message' => 'Database connection successful',
            ];
        } catch (\Exception $e) {
            return [
                'status' => 'unhealthy',
                'message' => 'Database connection failed: ' . $e->getMessage(),
            ];
        }
    }

    /**
     * Check Redis connectivity
     *
     * @return array
     */
    private function checkRedis(): array
    {
        try {
            if (config('cache.default') === 'redis') {
                Cache::store('redis')->put('health_check', 'ok', 10);
                $value = Cache::store('redis')->get('health_check');
                
                if ($value === 'ok') {
                    return [
                        'status' => 'healthy',
                        'message' => 'Redis connection successful',
                    ];
                }
            } else {
                return [
                    'status' => 'skipped',
                    'message' => 'Redis not configured',
                ];
            }
        } catch (\Exception $e) {
            return [
                'status' => 'unhealthy',
                'message' => 'Redis connection failed: ' . $e->getMessage(),
            ];
        }

        return [
            'status' => 'unhealthy',
            'message' => 'Redis check failed',
        ];
    }

    /**
     * Check storage writability
     *
     * @return array
     */
    private function checkStorage(): array
    {
        try {
            $testFile = storage_path('logs/health_check.txt');
            file_put_contents($testFile, 'test');
            
            if (file_exists($testFile)) {
                unlink($testFile);
                return [
                    'status' => 'healthy',
                    'message' => 'Storage is writable',
                ];
            }
        } catch (\Exception $e) {
            return [
                'status' => 'unhealthy',
                'message' => 'Storage write failed: ' . $e->getMessage(),
            ];
        }

        return [
            'status' => 'unhealthy',
            'message' => 'Storage check failed',
        ];
    }
}
