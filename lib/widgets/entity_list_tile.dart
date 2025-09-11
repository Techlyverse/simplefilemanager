import 'dart:io';
import 'package:flutter/material.dart';
import 'package:filemanager/helper/extension.dart';

import 'entity_icon.dart';

class EntityListTile extends StatelessWidget {
  const EntityListTile({super.key, this.onTap, required this.entity});
  final VoidCallback? onTap;
  final FileSystemEntity entity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(entity.name),
      leading: EntityIcon(entity),
      trailing: FutureBuilder<FileStat>(
          future: entity.stat(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            return Text(
              entity is File
                  ? snapshot.data!.size.toString()
                  : "${snapshot.data!.modified}".substring(0, 10),
            );
          }),
    );
  }
}
