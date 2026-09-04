import 'package:customer/res/routes/app_routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/data_backup_controller.dart';

/// S23/S24/S26 — Data & Backup section of the consolidated Settings tab.
class DataBackupSection extends StatelessWidget {
  const DataBackupSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DataBackupController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final last = controller.lastBackupAt.value;
          return ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Create backup'),
            subtitle: Text(
              last == null ? 'Never backed up' : 'Last backup: ${DateFormat.yMMMd().add_jm().format(last.toLocal())}',
            ),
            trailing: FilledButton(
              onPressed: controller.isLoading.value ? null : controller.createAndShareBackup,
              child: const Text('Create'),
            ),
          );
        }),
        ListTile(
          leading: const Icon(Icons.restore_outlined),
          title: const Text('Restore backup'),
          subtitle: const Text('Replaces all current data — a safety copy is made first'),
          trailing: OutlinedButton(
            onPressed: () => _pickAndRestore(context, controller),
            child: const Text('Restore'),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.table_chart_outlined),
          title: const Text('Export CSV'),
          subtitle: const Text('A flat, human-readable check-in history file'),
          trailing: OutlinedButton(
            onPressed: controller.exportAndShareCsv,
            child: const Text('Export'),
          ),
        ),
        ListTile(
          leading: Icon(Icons.delete_forever_outlined, color: Theme.of(context).colorScheme.error),
          title: Text('Delete all data', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          subtitle: const Text('Permanently erases every habit and check-in on this device'),
          trailing: OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => _confirmDeleteAll(context, controller),
            child: const Text('Delete'),
          ),
        ),
      ],
    );
  }

  Future<void> _pickAndRestore(BuildContext context, DataBackupController controller) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = result?.files.single.path;
    if (path == null) return;

    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    final validation = await controller.validateFile(path);
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    if (!context.mounted) return;

    if (!validation.isValid) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Can\'t restore this backup'),
          content: Text(validation.error ?? 'Unknown error'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    final summary = validation.summary!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore this backup?'),
        content: Text(
          'Backup from ${DateFormat.yMMMd().add_jm().format(summary.createdAt.toLocal())}\n'
          '${summary.habitCount} habits, ${summary.reminderCount} reminders, '
          '${summary.checkInCount} check-ins.\n\n'
          'This replaces everything currently on this device. A safety copy of your '
          'current data is created automatically first.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Replace my data')),
        ],
      ),
    );
    if (confirmed != true) return;

    final success = await controller.performRestore(validation.bundle!);
    if (success) {
      // The entire dataset just changed out from under every already-loaded
      // controller (Today/Calendar/Insights) — route back through Splash so
      // the shell rebuilds fresh rather than show stale cached lists.
      Get.offAllNamed(AppRoutes.splash);
    }
  }

  Future<void> _confirmDeleteAll(BuildContext context, DataBackupController controller) async {
    final textController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete all data?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This permanently deletes every habit, schedule, reminder, and check-in on '
              'this device. This cannot be undone.',
            ),
            const SizedBox(height: 16),
            Text('Type DELETE to confirm', style: Theme.of(context).textTheme.labelMedium),
            TextField(controller: textController, autofocus: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: textController,
            builder: (context, value, _) => FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: value.text.trim() == 'DELETE' ? () => Navigator.pop(context, true) : null,
              child: const Text('Delete permanently'),
            ),
          ),
        ],
      ),
    );
    textController.dispose();
    if (confirmed != true) return;

    final success = await controller.deleteAllData();
    if (success) {
      Get.offAllNamed(AppRoutes.splash);
    }
  }
}
