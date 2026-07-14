package com.example.friday

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.friday/device"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "lockScreen" -> {
                    val dpm = getSystemService(
                        Context.DEVICE_POLICY_SERVICE
                    ) as DevicePolicyManager
                    val admin = ComponentName(
                        this,
                        FridayDeviceAdminReceiver::class.java
                    )
                    if (dpm.isAdminActive(admin)) {
                        dpm.lockNow()
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                "requestAdmin" -> {
                    val admin = ComponentName(
                        this,
                        FridayDeviceAdminReceiver::class.java
                    )
                    val intent = Intent(
                        DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN
                    )
                    intent.putExtra(
                        DevicePolicyManager.EXTRA_DEVICE_ADMIN,
                        admin
                    )
                    intent.putExtra(
                        DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                        "FRIDAY needs device admin to lock your screen."
                    )
                    startActivity(intent)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}