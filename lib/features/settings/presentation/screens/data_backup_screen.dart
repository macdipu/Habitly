import 'package:flutter/material.dart';

import '../widgets/data_backup_section.dart';

/// S23/S24/S26 — data ownership: create/restore backup, export CSV,
/// delete all data. Split out of the consolidated Settings tab
/// (docs/ARCHITECTURE.md §12).
class DataBackupScreen extends StatelessWidget {
  const DataBackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data & backup')),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: const [DataBackupSection()],
      ),
    );
  }
}
