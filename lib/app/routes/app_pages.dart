import 'package:get/get.dart';
import 'package:receipt_management_flutter/app/routes/app_routes.dart';
import 'package:receipt_management_flutter/app/bindings/initial_binding.dart';
import 'package:receipt_management_flutter/app/bindings/receipt_binding.dart';
import 'package:receipt_management_flutter/modules/auth/views/login_screen.dart';
import 'package:receipt_management_flutter/modules/home/views/home_screen.dart';
import 'package:receipt_management_flutter/modules/receipt/views/create_receipt_screen.dart';
import 'package:receipt_management_flutter/modules/receipt/views/receipt_detail_screen.dart';
import 'package:receipt_management_flutter/modules/settings/views/settings_screen.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.createReceipt,
      page: () => const CreateReceiptScreen(),
      binding: ReceiptBinding(),
    ),
    GetPage(
      name: AppRoutes.receiptDetail,
      page: () => const ReceiptDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
    ),
  ];
}
