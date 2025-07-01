import 'dart:io';
import 'package:flutter/material.dart';
import '../directory/directory_page.dart';

class HomeGrid extends StatelessWidget {
  const HomeGrid({super.key, required this.directories});
  final List<Directory>? directories;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double factor = constraints.biggest.shortestSide;
          double size = factor * 0.6;
          return Padding(
            padding: EdgeInsets.all(size * 0.04),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  crossAxisCount: 2,
                ),
                itemCount: directories?.length,
                itemBuilder: (_, index) {
                  if (directories != null && directories!.isNotEmpty) {
                    final bool sdCard =
                        directories?[index].path.split('/').last != '0';
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DirectoryPage(
                              entity: directories![index],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xfff5f5f5),
                        //foregroundColor: Color(0xffeeeee),
                        padding: EdgeInsets.symmetric(
                          horizontal: size * 0.02,
                          vertical: size * 0.04,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(size * 0.08)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            sdCard ? Icons.sd_card : Icons.phone_android,
                            size: size * 0.8,
                            color: sdCard ? Colors.green[600] : Colors.blue[600],
                          ),
                          SizedBox(height: size * 0.02),
                          Text(
                            sdCard ? 'SD Card' : 'Device',
                            style: TextStyle(
                              fontSize: size * 0.08,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("No directory found"),
                    );
                  }
                }),
          );
        }
    );
  }
}
