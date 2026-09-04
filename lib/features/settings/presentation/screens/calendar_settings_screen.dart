import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/settings_controller.dart';

/// Calendar preferences — one of the rows BRD §S20 lists on the Settings
/// home; split out of the consolidated Settings tab
/// (docs/ARCHITECTURE.md §12). No dedicated BRD screen ID beyond S20's own
/// listing.
class CalendarSettingsScreen extends StatelessWidget {
  const CalendarSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            const Text('Start of week'),
            const Spacer(),
            Obx(() => SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 1, label: Text('Mon')),
                    ButtonSegment(value: 7, label: Text('Sun')),
                  ],
                  selected: {settingsController.startOfWeek.value},
                  onSelectionChanged: (s) => settingsController.setStartOfWeek(s.first),
                )),
          ],
        ),
      ),
    );
  }
}
