import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

class CustomFm extends StatefulWidget {
  const CustomFm({super.key});

  @override
  State<CustomFm> createState() => _CustomFmState();
}

class _CustomFmState extends State<CustomFm> {
  List<FileSystemEntity> files = [];
  bool _isLoading = true;
  String currentDirectory = '/storage/emulated/0/';

  @override
  void initState() {
    super.initState();
    _loadFiles(currentDirectory);
    final directory = Directory(currentDirectory);
    files = directory.listSync();
    print("files are $files");
  }

  Future<void> _loadFiles(String path) async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 30) {
          status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            _showPermissionDeniedDialog();
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }
      }
      try {
        final directory = Directory(path);
        files = directory.listSync();
        setState(() {
          currentDirectory = path;
          _isLoading = false;
        });
      } catch (e) {
        debugPrint('Error loading files: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _showPermissionDeniedDialog();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content:
              const Text('Please grant storage permission to access files.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToDirectory(String path) {
    setState(() {
      _isLoading = true;
    });
    _loadFiles(path);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('File Manager - $currentDirectory'),
        actions: currentDirectory != '/storage/emulated/0/'
            ? [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    _navigateToDirectory(p.dirname(currentDirectory));
                  },
                ),
              ]
            : null,
      ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          final fileName = p.basename(file.path);

          return ListTile(
            title: Text(fileName),
            leading:
                Icon(file is File ? Icons.insert_drive_file : Icons.folder),
            onTap: () {
              if (file is Directory) {
                _navigateToDirectory(file.path);
              } else {
                // Open file (add file handling logic here)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening file: $fileName')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
