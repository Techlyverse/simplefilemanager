import 'dart:async';
import 'dart:io';
import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/material.dart';

import '../data/enums.dart';
import 'components/breadcrumb/bread_crumb_bar.dart';
import 'components/entity/entity_grid_tile.dart';
import 'components/entity/entity_list_tile.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key, required this.dir});
  final Directory dir;

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  late Future<List<FileSystemEntity>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadFiles();
  }

  @override
  void didUpdateWidget(covariant DirectoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload if the directory changes
    if (oldWidget.dir.path != widget.dir.path) {
      _future = _loadFiles();
    }
  }

  Future<List<FileSystemEntity>> _loadFiles() async {
    // listSync is actually faster inside an Isolate than awaiting a Stream
    final List<FileSystemEntity> items = await widget.dir.list().toList();

    // Sort: Directories first, then Files, then Case-insensitive Alphabetical
    items.sort((a, b) {
      if (a is Directory && b is File) return -1;
      if (a is File && b is Directory) return 1;
      return a.path.toLowerCase().compareTo(b.path.toLowerCase());
    });

    items.removeWhere((e) => e.uri.pathSegments.last.startsWith("."));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (context.layoutType != LayoutType.desktop)
          BreadCrumbBar(uri: widget.dir.uri),
        Expanded(child: _entityViewer()),
      ],
    );
  }

  Widget _entityViewer() {
    return FutureBuilder(
      future: _future,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null &&
            snapshot.data!.isNotEmpty) {
          return ValueListenableBuilder<bool>(
            valueListenable: AppController().showGridView,
            builder: (_, isGrid, _) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: isGrid
                    ? _buildGrid(snapshot.data!)
                    : _buildList(snapshot.data!),
              );
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _buildGrid(List<FileSystemEntity> entities) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: context.layoutType == .mobile ? 90 : 120,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: entities.length,
      itemBuilder: (context, index) => EntityGridTile(
        entity: entities[index],
        key: ValueKey(entities[index].path),
      ),
    );
  }

  Widget _buildList(List<FileSystemEntity> entities) {
    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) => EntityListTile(
        entity: entities[index],
        key: ValueKey(entities[index].path),
      ),
    );
  }
}
