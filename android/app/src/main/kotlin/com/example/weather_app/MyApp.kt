package com.example.weather_app

import android.annotation.TargetApi
import android.app.Application
import android.app.Activity
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MyApp : Application() {

    companion object {
        private const val CHANNEL = "app_events"
    }

    private lateinit var flutterEngine: FlutterEngine
    private lateinit var channel: MethodChannel

    @TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    override fun onCreate() {
        super.onCreate()

        // Initialize the Flutter engine
        flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        // Initialize MethodChannel
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        // Register Activity Lifecycle Callbacks
        registerActivityLifecycleCallbacks(object : ActivityLifecycleCallbacks {
            override fun onActivityStopped(activity: Activity) {
                Log.d("MyApp", "App stopped or swiped away")
                try {
                    channel.invokeMethod("onAppBackgrounded", null)
                } catch (e: Exception) {
                    Log.e("MyApp", "Failed to invoke onAppBackgrounded: ${e.message}")
                }
            }

            override fun onActivityDestroyed(activity: Activity) {
                Log.d("MyApp", "App destroyed")
                try {
                    channel.invokeMethod("onAppSwiped", null)
                } catch (e: Exception) {
                    Log.e("MyApp", "Failed to invoke onAppSwiped: ${e.message}")
                }
            }

            override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {}
            override fun onActivityStarted(activity: Activity) {}
            override fun onActivityResumed(activity: Activity) {}
            override fun onActivityPaused(activity: Activity) {}
            override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}
        })

        // Example: Trigger an error manually (can be removed)
        try {
            channel.invokeMethod("onAppError", "Some error occurred")
        } catch (e: Exception) {
            Log.e("MyApp", "Failed to invoke onAppError: ${e.message}")
        }
    }
}
