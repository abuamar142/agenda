import 'package:get/get.dart';
import 'package:agenda/core/network/network_client.dart';
import 'package:agenda/core/network/network_info.dart';

class DependencyInjection {
  static void init() {
    // Core dependencies
    Get.lazyPut<NetworkClient>(() => NetworkClient(), fenix: true);
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(), fenix: true);

    // TODO: Add more dependencies here
    // Data sources
    // Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(Get.find()));
    // Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());

    // Repositories
    // Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(
    //   remoteDataSource: Get.find(),
    //   localDataSource: Get.find(),
    //   networkInfo: Get.find(),
    // ));

    // Use cases
    // Get.lazyPut(() => LoginUseCase(Get.find()));
    // Get.lazyPut(() => LogoutUseCase(Get.find()));
    // Get.lazyPut(() => GetCurrentUserUseCase(Get.find()));
  }
}
