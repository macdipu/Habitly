
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../app/shell/app_shell.dart';
import '../../app/shell/app_shell_binding.dart';
import '../../features/habits/presentation/bindings/create_habit_binding.dart';
import '../../features/habits/presentation/create_habit/screens/create_habit_screen.dart';
import 'app_routes.dart';

class AppPages {
  // Habitly has no account/login flow (BRD §4.2) — the shell is the entry
  // point. `lib/features/sample_feature/` (login/reset-PIN) went missing
  // from disk mid-session with no explanation (see memory
  // "habitly-project-overview"); its routes are gone too, which is moot
  // for Habitly since they were never meant to be reachable.
  static const initial = AppRoutes.appShell;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.appShell,
      page: () => const AppShell(),
      bindings: [
        AppShellBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.createHabit,
      page: () => const CreateHabitScreen(),
      binding: CreateHabitBinding(),
    ),
  ];
}
