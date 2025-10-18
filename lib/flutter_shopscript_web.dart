import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Web implementation of FlutterShopScript
class FlutterShopScriptWeb {
  static void registerWith(Registrar registrar) {
    // Web-specific implementation if needed
    // For now, this is a no-op as all functionality is in Dart
  }
}

/// Plugin registration for web
class FlutterShopScriptPlugin {
  static void registerWith(Registrar registrar) {
    FlutterShopScriptWeb.registerWith(registrar);
  }
}
