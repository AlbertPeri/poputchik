package com.djigit.companion
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterFragmentActivity(){
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    //MapKitFactory.setLocale("YOUR_LOCALE") // Your preferred language. Not required, defaults to system language
    MapKitFactory.setApiKey("4fd413c1-be88-4366-a523-6eb32cf84330") // Your generated API key
    super.configureFlutterEngine(flutterEngine)
  }
}