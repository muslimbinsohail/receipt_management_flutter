import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:receipt_management_flutter/app/bindings/initial_binding.dart';
import 'package:receipt_management_flutter/app/routes/app_pages.dart';
import 'package:receipt_management_flutter/app/routes/app_routes.dart';
import 'package:receipt_management_flutter/app/theme/app_theme.dart';
import 'package:receipt_management_flutter/data/local/hive_service.dart';
import 'package:receipt_management_flutter/data/local/settings_local_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive (local storage)
  await HiveService.init();

  // Initialize Firebase
  // TODO: Configure Firebase — run `flutterfire configure` and uncomment:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init skipped (not configured yet): $e');
  }

  // Get theme preference
  final settings = SettingsLocalSource();
  final isDark = settings.isDarkMode;

  runApp(
    GetMaterialApp(
      title: 'Receipt Manager',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      // Routes
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      initialBinding: InitialBinding(),

      // Default transition
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 250),

      // Error handling
      builder: (context, child) {
        // Handle global errors
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 12),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Please restart the app',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        };
        return child ?? const SizedBox.shrink();
      },
    ),
  );
}
