package nl.viter.native_launcher

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class NativeLauncherPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "native_launcher")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "launchNonBrowser") {
            val uri = Uri.parse(call.argument("url"))
            val launched = launchNonBrowser(uri)
            result.success(launched)
        } else {
            result.notImplemented()
        }
    }

    private fun launchNonBrowser(uri: Uri): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            launchNonBrowserApiR(uri)
        } else {
            launchNonBrowserBeforeApiR(uri)
        }
    }


    @RequiresApi(Build.VERSION_CODES.R)
    private fun launchNonBrowserApiR(uri: Uri): Boolean {
        val nativeAppIntent = Intent(Intent.ACTION_VIEW, uri)
                .addCategory(Intent.CATEGORY_BROWSABLE)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REQUIRE_NON_BROWSER)

        return try {
            context.startActivity(nativeAppIntent)
            true
        } catch (ex: ActivityNotFoundException) {
            false
        }
    }

    private fun launchNonBrowserBeforeApiR(uri: Uri): Boolean {
        // Get all apps that resolve a generic URL.
        val genericActivityIntent = Intent()
                .setAction(Intent.ACTION_VIEW)
                .addCategory(Intent.CATEGORY_BROWSABLE)
                .setData(Uri.fromParts("http", "", null))
        val genericResolvedList = extractPackageNames(genericActivityIntent)

        // Get all apps that resolve the specific URL.
        val specializedActivityIntent = Intent(Intent.ACTION_VIEW, uri)
                .addCategory(Intent.CATEGORY_BROWSABLE)
        val specializedResolvedList = extractPackageNames(specializedActivityIntent)

        // Keep only the URLs that resolve the specific, but not the generic URLs.
        // If the list is empty, no native app handlers were found.
        if (specializedResolvedList.minus(genericResolvedList).isEmpty()) {
            return false
        }

        specializedActivityIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(specializedActivityIntent)
        return true
    }

    private fun extractPackageNames(intent: Intent): MutableSet<String> =
            context.packageManager.queryIntentActivities(intent, 0)
                    .map { x -> x.activityInfo.packageName }
                    .toMutableSet()
}
