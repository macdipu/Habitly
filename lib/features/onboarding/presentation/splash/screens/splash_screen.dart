import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Obx(() {
          if (controller.hasError.value) {
            return _BootstrapError(controller: controller);
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Habitly',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              if (controller.showLoadingIndicator.value) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
              ],
            ],
          );
        }),
      ),
    );
  }
}

class _BootstrapError extends StatelessWidget {
  final SplashController controller;

  const _BootstrapError({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text('Couldn\'t start Habitly', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Your data is safe — it was not touched. Try again, or check that '
            'the device has enough free storage.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: controller.retry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
