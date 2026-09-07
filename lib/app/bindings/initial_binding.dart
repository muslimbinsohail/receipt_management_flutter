import 'package:get/get.dart';
import 'package:receipt_management_flutter/data/local/receipt_local_source.dart';
import 'package:receipt_management_flutter/data/local/settings_local_source.dart';
import 'package:receipt_management_flutter/data/remote/auth_service.dart';
import 'package:receipt_management_flutter/data/remote/firestore_service.dart';
import 'package:receipt_management_flutter/data/repositories/auth_repository.dart';
import 'package:receipt_management_flutter/data/repositories/receipt_repository.dart';
import 'package:receipt_management_flutter/data/repositories/sync_repository.dart';
import 'package:receipt_management_flutter/modules/auth/controllers/auth_controller.dart';
import 'package:receipt_management_flutter/modules/home/controllers/home_controller.dart';
import 'package:receipt_management_flutter/services/connectivity_service.dart';
import 'package:receipt_management_flutter/services/error_handler_service.dart';
import 'package:receipt_management_flutter/services/sync_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services (singletons)
    Get.put(ConnectivityService(), permanent: true);
    Get.put(ErrorHandlerService(), permanent: true);

    // Data sources
    Get.lazyPut(() => ReceiptLocalSource(), fenix: true);
    Get.lazyPut(() => SettingsLocalSource(), fenix: true);
    Get.lazyPut(() => FirestoreService(), fenix: true);
    Get.lazyPut(() => AuthService(), fenix: true);

    // Repositories
    Get.lazyPut(
      () => AuthRepository(authService: Get.find<AuthService>()),
      fenix: true,
    );
    Get.lazyPut(() => SyncRepository(), fenix: true);
    Get.lazyPut(
      () => ReceiptRepository(
        localSource: Get.find<ReceiptLocalSource>(),
        firestoreService: Get.find<FirestoreService>(),
        syncRepository: Get.find<SyncRepository>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // Sync service (after dependencies are ready)
    Get.put(
      SyncService(
        connectivityService: Get.find<ConnectivityService>(),
        syncRepository: Get.find<SyncRepository>(),
        firestoreService: Get.find<FirestoreService>(),
        receiptLocalSource: Get.find<ReceiptLocalSource>(),
        settingsLocalSource: Get.find<SettingsLocalSource>(),
      ),
      permanent: true,
    );

    // Controllers
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
