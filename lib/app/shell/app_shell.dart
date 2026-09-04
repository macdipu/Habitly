import 'package:customer/features/today/presentation/screens/today_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_shell_controller.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppShellController>();

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              TodayScreen(),
              _PlaceholderScreen(label: 'Calendar'),
              _PlaceholderScreen(label: 'Insights'),
              _PlaceholderScreen(label: 'Settings'),
            ],
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.today_outlined),
              activeIcon: Icon(Icons.today),
              label: 'Today',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              activeIcon: Icon(Icons.insights),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

/// Calendar/Insights/Settings land in later phases (docs/ARCHITECTURE.md §9,
/// Phase 3/4) — this keeps the 4-tab IA navigable meanwhile.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text(
          '$label — coming soon',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
