import 'dart:io';
import 'package:flutter/material.dart';
import '../directory/directory_page.dart';

class HomeList extends StatelessWidget {
  const HomeList({super.key, required this.directories});
  final List<Directory>? directories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: key,
        itemCount: directories?.length,
        itemBuilder: (_, index) {
          final bool sdCard = directories![index].path.split('/').last != '0';
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
                              entity: directories![index],
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
                    sdCard
                        ? Icons.sd_card_outlined
                        : Icons.phone_android_outlined,
                    size: 45,
                    color: sdCard ? Colors.amber[700] : Colors.blue[600],
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
