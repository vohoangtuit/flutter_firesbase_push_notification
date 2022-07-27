package vht.flutter.flutter_notifications;
import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

public class FApplication extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @Override
    public void registerWith(PluginRegistry registry) {
      //  GeneratedPluginRegister.registerGeneratedPlugins(new FlutterEngine(this));
    }
    @Override
    public void onCreate() {
        super.onCreate();
      //  FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
    }
}
