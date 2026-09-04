import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// S02 — explains value and the offline/privacy model in one screen. No
/// sign-up, login, email, or network prompt (BRD §S02 acceptance note).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Text(
                'Build better days, one habit at a time',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const _Benefit(icon: Icons.check_circle_outline, text: 'Track your daily habits'),
              const SizedBox(height: 16),
              const _Benefit(icon: Icons.notifications_outlined, text: 'Remember with gentle reminders'),
              const SizedBox(height: 16),
              const _Benefit(icon: Icons.insights_outlined, text: 'Understand your progress over time'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Get.toNamed(AppRoutes.onboardingPreferences),
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your data stays on this device',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Benefit({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
      ],
    );
  }
}
