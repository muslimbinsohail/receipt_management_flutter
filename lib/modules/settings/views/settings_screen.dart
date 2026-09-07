import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receipt_management_flutter/app/theme/app_colors.dart';
import 'package:receipt_management_flutter/app/theme/app_text_styles.dart';
import 'package:receipt_management_flutter/data/local/settings_local_source.dart';
import 'package:receipt_management_flutter/modules/auth/controllers/auth_controller.dart';
import 'package:receipt_management_flutter/data/repositories/auth_repository.dart';
import 'package:receipt_management_flutter/services/sync_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsLocalSource>();
    final authRepo = Get.find<AuthRepository>();
    final syncService = Get.find<SyncService>();
    final isDark = RxBool(settings.isDarkMode);
    final autoSync = RxBool(settings.isAutoSync);

    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: AppTextStyles.h3)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Account section
          _sectionHeader('Account'),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(Icons.person_rounded, color: AppColors.primary),
            ),
            title: Text(authRepo.userName ?? 'Guest User'),
            subtitle: Text(authRepo.userEmail ?? 'Not signed in'),
            trailing: authRepo.isSignedIn
                ? TextButton(
                    onPressed: () {
                      final authController = Get.find<AuthController>();
                      authController.signOut();
                    },
                    child: const Text('Sign Out'),
                  )
                : null,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // Appearance
          _sectionHeader('Appearance'),
          Obx(() => SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle dark theme'),
                value: isDark.value,
                onChanged: (v) {
                  isDark.value = v;
                  settings.setDarkMode(v);
                  Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                },
                secondary: Icon(isDark.value
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded),
              )),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // Sync
          _sectionHeader('Sync'),
          Obx(() => SwitchListTile(
                title: const Text('Auto Sync'),
                subtitle: const Text('Automatically sync when online'),
                value: autoSync.value,
                onChanged: (v) {
                  autoSync.value = v;
                  settings.setAutoSync(v);
                },
                secondary: const Icon(Icons.sync_rounded),
              )),
          ListTile(
            leading: const Icon(Icons.cloud_sync_rounded),
            title: const Text('Sync Now'),
            subtitle: Obx(() => Text(
                  syncService.isSyncing.value
                      ? 'Syncing...'
                      : '${syncService.pendingCount.value} items pending',
                )),
            trailing: Obx(() => syncService.isSyncing.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.arrow_forward_ios_rounded, size: 16)),
            onTap: () => syncService.forceSync(),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // About
          _sectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: Icon(Icons.receipt_long_rounded,
                color: AppColors.primary),
            title: const Text('Receipt Manager'),
            subtitle: const Text(
                'Professional e-commerce receipt management'),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textTertiary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
