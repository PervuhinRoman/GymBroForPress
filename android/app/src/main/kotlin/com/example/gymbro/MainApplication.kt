package com.example.gymbro;

import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setLocale("ru_RU") // Your preferred language. Not required, defaults to system language
        MapKitFactory.setApiKey("7fc1859f-c483-4a45-b8a2-ff45cfc15299") // Your generated API key
    }
}