import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../directory/directory_page.dart';

class HomeList extends StatelessWidget {
  const HomeList({super.key, required this.directories});
  final List<Directory>? directories;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          double size = constraints.biggest.shortestSide * 0.5;
          return ListView.builder(
              key: key,
              itemCount: directories?.length,
              itemBuilder: (_, index) {
                final bool sdCard = directories![index].path.split('/').last != '0';
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size * 0.05,
                    vertical: size * 0.06,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: size * 0.05,
                        vertical: size * 0.06,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(size * 0.08)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          sdCard
                              ? Icons.sd_card_outlined
                              : Icons.phone_android_outlined,
                          size: size * 0.5,
                          color: sdCard ? Colors.amber[700] : Colors.blue[600],
                        ),
                        SizedBox(width: size * 0.05),
                        Text(
                          sdCard ? 'SD Card' : 'Internal Storage',
                          style: TextStyle(
                            fontSize: size * 0.06,
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
    );
  }
}
