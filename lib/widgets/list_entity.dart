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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          double size = constraints.biggest.shortestSide * 0.5;
          return Column(
            children: [
              ListTile(
                onTap: onTap,
                contentPadding: EdgeInsets.symmetric(vertical: size * 0.03, horizontal: size * 0.055),
                title: Text(entity.name, style: TextStyle(fontSize: size * 0.04),),
                leading: EntityIcon(entity),
                trailing: FutureBuilder<FileStat>(
                    future: entity.stat(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();
                      return Text(
                        entity is File
                            ? snapshot.data!.size.toString()
                            : "${snapshot.data!.modified}".substring(0, 10),
                        style: TextStyle(fontSize: size * 0.04),
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(left: size * 0.058, right: size * 0.052),
                child: Divider(thickness: size * 0.006, height: size * 0.01),
              )
            ],
          );
        }
    );
  }
}
