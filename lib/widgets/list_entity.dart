import 'dart:io';
import 'package:filemanager/helper/extension.dart';
import 'package:flutter/material.dart';
import 'entity_icon.dart';

class ListEntity extends StatelessWidget {
  const ListEntity({
    super.key,
    required this.entity,
    required this.onTap,
  });
  final FileSystemEntity entity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
        ),
        const Padding(
          padding: EdgeInsets.only(left: 70, right: 8),
          child: Divider(thickness: 1, height: 1),
        )
      ],
    );
  }
}
