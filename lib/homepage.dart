import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'directory_page.dart';
import 'preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FileManagerController fileManagerController = FileManagerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Files'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                Preferences.setViewType(!Preferences.getViewType());
              });
            },
            icon: Icon(Preferences.getViewType()
                ? Icons.grid_on_rounded
                : Icons.list_alt),
          ),
        ],
      ),
      body: FileManager(
        controller: fileManagerController,
        builder: (context, listFileSystemEntity) {
          return FutureBuilder<List<Directory>>(
              future: FileManager.getStorageList(),
              builder: (context, snapshot) {
                return Preferences.getViewType()
                    ? BuildGrid(
                        snapshot: snapshot.data,
                        key: const Key("grid"),
                      )
                    : BuildList(
                        snapshot: snapshot.data,
                        key: const Key('list'),
                      );
              });
        },
      ),
    );
  }
}

class BuildList extends StatelessWidget {
  const BuildList({super.key, required this.snapshot});
  final List<Directory>? snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: key,
        itemCount: snapshot?.length,
        itemBuilder: (_, index) {
          final bool sdCard = snapshot![index].path.split('/').last != '0';
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DirectoryPage(
                              entity: snapshot![index],
                            )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfff5f5f5),
                //foregroundColor: Color(0xffeeeee),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    sdCard ? Icons.sd_card : Icons.phone_android,
                    size: 45,
                    color: sdCard ? Colors.green[600] : Colors.blue[600],
                  ),
                  const SizedBox(width: 10),
                  Text(
                    sdCard ? 'SD Card' : 'Internal Storage',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class BuildGrid extends StatelessWidget {
  const BuildGrid({super.key, required this.snapshot});
  final List<Directory>? snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 20,
            crossAxisSpacing: 30,
            crossAxisCount: 2,
          ),
          itemCount: snapshot?.length,
          itemBuilder: (_, index) {
            final bool sdCard = snapshot![index].path.split('/').last != '0';
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DirectoryPage(
                      entity: snapshot![index],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfff5f5f5),
                //foregroundColor: Color(0xffeeeee),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    sdCard ? Icons.sd_card : Icons.phone_android,
                    size: 60,
                    color: sdCard ? Colors.green[600] : Colors.blue[600],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    sdCard ? 'SD Card' : 'Device',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
