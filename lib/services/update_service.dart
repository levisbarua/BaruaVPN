import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  // TODO: Replace with your actual GitHub username and repository name
  static const String githubRepo = 'levisbarua/BaruaVPN';

  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/$githubRepo/releases/latest'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestVersionTag = data['tag_name'] as String; // e.g. "v1.0.0.0.1"
        final latestVersion = latestVersionTag.replaceAll('v', '');
        
        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;

        if (_isNewerVersion(currentVersion, latestVersion)) {
          // Find the APK asset URL
          String? apkUrl;
          if (data['assets'] != null) {
            for (var asset in data['assets']) {
              if (asset['name'].toString().endsWith('.apk')) {
                apkUrl = asset['browser_download_url'];
                break;
              }
            }
          }
          
          // If no direct APK link, just link to the release page
          final downloadUrl = apkUrl ?? data['html_url'];

          if (context.mounted) {
            _showUpdateDialog(context, latestVersion, downloadUrl, data['body'] ?? 'Bug fixes and improvements.');
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    }
  }

  static bool _isNewerVersion(String currentVersion, String latestVersion) {
    // Simple string comparison or split by dot and compare integers
    final currentParts = currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final latestParts = latestVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLength = currentParts.length > latestParts.length ? currentParts.length : latestParts.length;

    for (int i = 0; i < maxLength; i++) {
      final currentPart = i < currentParts.length ? currentParts.length : 0;
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
