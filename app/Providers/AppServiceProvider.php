<?php

namespace App\Providers;

use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Paksa selalu HTTPS & base URL — branch ini di-deploy di Railway (production)
        // Ini memastikan redirect()->route() dan form action 100% aman
        URL::forceScheme('https');
        URL::forceRootUrl('https://senandika-demo-production.up.railway.app');
    }
}
