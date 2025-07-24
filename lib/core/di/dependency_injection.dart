import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/network_client.dart';
import '../network/network_info.dart';

class DependencyInjection {
  static Future<void> setup() async {
    // Core dependencies
    Get.lazyPut<NetworkClient>(() => NetworkClient.instance, fenix: true);
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(), fenix: true);

    // SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sharedPreferences);

    // TODO: Add more dependencies here when needed
    // Data sources will be injected via bindings
    // Repositories will be injected via bindings
    // Use cases will be injected via bindings
  }
}
