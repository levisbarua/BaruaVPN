import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  // TODO: Replace with your actual GitHub username and repository name
  static const String githubRepo = 'levisbarua/BaruaVPN';

  static Future<void> checkForUpdates(BuildContext context) async {
    // Disabled as requested
    return;
  }

  static bool _isNewerVersion(String currentVersion, String latestVersion) {
    // Simple string comparison or split by dot and compare integers
    final currentParts = currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final latestParts = latestVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLength = currentParts.length > latestParts.length ? currentParts.length : latestParts.length;

    for (int i = 0; i < maxLength; i++) {
      final currentPart = i < currentParts.length ? currentParts[i] : 0;
      final latestPart = i < latestParts.length ? latestParts[i] : 0;

      if (latestPart > currentPart) return true;
      if (latestPart < currentPart) return false;
    }
    return false;
  }

  static void _showUpdateDialog(BuildContext context, String newVersion, String url, String releaseNotes) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Available ($newVersion)'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('A new version of Barua VPN is available!'),
                const SizedBox(height: 12),
                const Text('Release Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(releaseNotes),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }
}
