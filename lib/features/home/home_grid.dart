import 'dart:io';
import 'package:flutter/material.dart';
import '../directory/directory_page.dart';

class HomeGrid extends StatelessWidget {
  const HomeGrid({super.key, required this.directories});
  final List<Directory>? directories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
            } else {
              return const Center(
                child: Text("No directory found"),
              );
            }
          }),
    );
  }
}
