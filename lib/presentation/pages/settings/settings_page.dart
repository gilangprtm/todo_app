import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import '../../../core/theme/app_color.dart';
import '../../../core/mahas/widget/mahas_button.dart';
import '../../../core/di/service_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _exportDatabase(BuildContext context, WidgetRef ref) async {
    // Request storage permission - for Android 13+ this should be more specific
    var status = await Permission.storage.request();

    // For Android 13+ (SDK 33+), we need to request specific permissions
    if (Platform.isAndroid) {
      // Request media permissions (needed in Android 13+)
      final permissions = [
        Permission.photos,
        Permission.videos,
        Permission.audio,
      ];

      // Request permissions
      Map<Permission, PermissionStatus> statuses = await permissions.request();

      // Check if any permission was granted
      bool anyGranted = statuses.values.any((status) => status.isGranted);

      if (!anyGranted && !status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Storage permissions denied. Cannot export database.',
              ),
            ),
          );
        }
        return;
      }
    } else if (!status.isGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
      return;
    }

    try {
      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Exporting database...'),
                ],
              ),
            );
          },
        );
      }

      // Get database
      final dbLocal = ref.read(dbProvider);

      // Ensure the database exists
      await dbLocal.database;

      // Get database file name and path (from the application documents directory)
      const databaseName = "todo_app.db";

      // Get the correct database path - it's in app documents directory not in databases folder
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final dbPath = path.join(documentsDirectory.path, databaseName);

      // Check if database file exists
      final File dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        throw Exception(
          'Database file not found at: $dbPath\nPlease make sure the database is created first.',
        );
      }

      // Decide on export location based on platform and permissions
      String exportPath;

      // Try to use download folder on Android if permission granted
      if (Platform.isAndroid) {
        if (await Permission.storage.isGranted) {
          try {
            final downloadDir = Directory('/storage/emulated/0/Download');
            if (await downloadDir.exists()) {
              final timestamp = DateTime.now().millisecondsSinceEpoch;
              exportPath = '${downloadDir.path}/todo_app_$timestamp.db';
            } else {
              throw Exception('Download directory not found');
            }
          } catch (e) {
            // Fallback to app documents if download directory not accessible
            final appDir = await getApplicationDocumentsDirectory();
            final timestamp = DateTime.now().millisecondsSinceEpoch;
            exportPath = '${appDir.path}/todo_app_export_$timestamp.db';
          }
        } else {
          // No permission - use app documents directory
          final appDir = await getApplicationDocumentsDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          exportPath = '${appDir.path}/todo_app_export_$timestamp.db';
        }
      } else {
        // iOS - use app documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        exportPath = '${appDir.path}/todo_app_export_$timestamp.db';
      }

      // Ensure the target directory exists
      final exportDir = Directory(
        exportPath.substring(0, exportPath.lastIndexOf('/')),
      );
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      // Copy database file
      await dbFile.copy(exportPath);

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database exported to: $exportPath'),
            duration: const Duration(seconds: 10),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting database: $e'),
            duration: const Duration(seconds: 10),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Database Tools',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              MahasButton(
                text: 'Export Database',
                color: AppColors.primaryColor,
                isFullWidth: true,
                onPressed: () => _exportDatabase(context, ref),
              ),

              const Text(
                '⚠️ The database will be exported to internal storage or Download folder if permission is granted',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                'App Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const ListTile(
                title: Text('Version'),
                subtitle: Text('1.0.0'),
                leading: Icon(Icons.info_outline),
              ),
              const Divider(),
              const ListTile(
                title: Text('Developer'),
                subtitle: Text('Todo App Developer Team'),
                leading: Icon(Icons.code),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
