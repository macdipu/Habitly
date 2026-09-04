import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// S25 — privacy statement and app metadata. Split out of the consolidated
/// Settings tab (docs/ARCHITECTURE.md §12).
class PrivacyAboutScreen extends StatelessWidget {
  const PrivacyAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & about')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Your data stays on this device'),
            subtitle: Text(
              'Habitly has no account, no server, and no analytics. All habits, '
              'check-ins, and settings are stored locally in this app\'s database.',
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final info = snapshot.data;
              return ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Version'),
                subtitle: Text(info == null ? '—' : '${info.version} (${info.buildNumber})'),
              );
            },
          ),
        ],
      ),
    );
  }
}
