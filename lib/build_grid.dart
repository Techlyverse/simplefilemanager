import 'dart:io';
import 'package:flutter/material.dart';
import 'directory_page.dart';

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
            if(snapshot != null && snapshot!.isNotEmpty){
              final bool sdCard = snapshot?[index].path.split('/').last != '0';
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
            }
            else{
              return const Center(
                child: Text("No directory found"),
              );
            }


          }),
    );
  }
}