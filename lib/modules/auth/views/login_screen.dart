import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receipt_management_flutter/app/theme/app_colors.dart';
import 'package:receipt_management_flutter/app/theme/app_text_styles.dart';
import 'package:receipt_management_flutter/core/utils/validators.dart';
import 'package:receipt_management_flutter/modules/auth/controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Obx(() => Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo & Title
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Receipt Manager',
                        style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.isLogin.value
                            ? 'Welcome back! Sign in to continue.'
                            : 'Create your account to get started.',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Name field (register only)
                      if (!controller.isLogin.value) ...[
                        TextFormField(
                          controller: controller.nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (v) => Validators.required(v, 'Name'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email
                      TextFormField(
                        controller: controller.emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: Validators.email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      Obx(() => TextFormField(
                            controller: controller.passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscurePassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                            obscureText: controller.obscurePassword.value,
                            validator: Validators.password,
                            textInputAction: controller.isLogin.value
                                ? TextInputAction.done
                                : TextInputAction.next,
                          )),
                      const SizedBox(height: 16),

                      // Confirm Password (register only)
                      if (!controller.isLogin.value) ...[
                        Obx(() => TextFormField(
                              controller:
                                  controller.confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon:
                                    const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.obscureConfirmPassword.value
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed:
                                      controller.toggleConfirmPasswordVisibility,
                                ),
                              ),
                              obscureText:
                                  controller.obscureConfirmPassword.value,
                              validator: (v) => Validators.confirmPassword(
                                  v, controller.passwordController.text),
                            )),
                        const SizedBox(height: 16),
                      ],

                      // Forgot password (login only)
                      if (controller.isLogin.value)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: controller.forgotPassword,
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Submit button
                      Obx(() => SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : (controller.isLogin.value
                                      ? controller.signIn
                                      : controller.register),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      controller.isLogin.value
                                          ? 'Sign In'
                                          : 'Create Account',
                                      style: AppTextStyles.button,
                                    ),
                            ),
                          )),
                      const SizedBox(height: 16),

                      // Toggle login/register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.isLogin.value
                                ? "Don't have an account? "
                                : 'Already have an account? ',
                            style: AppTextStyles.bodySmall,
                          ),
                          TextButton(
                            onPressed: controller.toggleLoginRegister,
                            child: Text(
                              controller.isLogin.value
                                  ? 'Register'
                                  : 'Sign In',
                              style: AppTextStyles.labelLarge
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OR',
                                style: AppTextStyles.caption),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Continue offline
                      SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: controller.continueOffline,
                          icon: const Icon(Icons.wifi_off_rounded),
                          label: Text(
                            'Continue Offline',
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
