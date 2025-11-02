import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class ImageThumbnail extends StatefulWidget{
  final FileSystemEntity file;
  final double size;
  const ImageThumbnail({super.key, required this.file, this.size = 80});

  @override
  State<ImageThumbnail> createState() => _ImageThumbnailState();
}

class _ImageThumbnailState extends State<ImageThumbnail>{
  late Future<File?> _thumbnailFuture;

  @override
  void initState(){
    super.initState();
    _thumbnailFuture = _fetchOrCreateThumbnail(widget.file);
  }

  Future<File?> _fetchOrCreateThumbnail(FileSystemEntity file) async {
    final cacheDir = await getTemporaryDirectory();
    final thumbnailPath = '${cacheDir.path}/${file.uri.pathSegments.last}_thumb.jpg';
    final thumbnailFile = File(thumbnailPath);

    print('📁 Cache dir: ${cacheDir.path}');
    print('🎯 Source file: ${file.path}');
    print('🖼️ Thumbnail path: $thumbnailPath');

    //if (await thumbnailFile.exists()) return thumbnailFile;

    if (await thumbnailFile.exists()) {
      print('✅ Thumbnail exists, returning cached file');
      return thumbnailFile;
    }

    try{
      final bytes = await File(file.path).readAsBytes();
      print('📦 Read ${bytes.length} bytes');

      final image = img.decodeImage(bytes);
      print(image?.width); // should print width if decode succeeded
      //if (image == null) return null;
      if (image == null) {
        print('⚠️ decodeImage() returned null');
        return null;
      }

      final thumbnail = img.copyResize(image, width: 150);
      await thumbnailFile.writeAsBytes(img.encodeJpg(thumbnail));
      print('✅ Thumbnail created: ${thumbnailFile.path}');
      return thumbnailFile;
    } catch (e) {
        // debugPrint("No image here, go away: $e");
        // return null;
      debugPrint('❌ Thumbnail generation failed: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<File?>(
        future: _thumbnailFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return _placeholder();
          }

          final thumbnailFile = snapshot.data;
          if (thumbnailFile != null && thumbnailFile.existsSync()){
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(
                thumbnailFile,
                width: widget.size,
                height: widget.size,
                fit: BoxFit.cover,
              ),
            );
          }

          return _placeholder();
        }
    );
  }

  Widget _placeholder(){
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(6)
      ),
      child: Icon(
        Icons.image,
        color: Colors.amberAccent,
        size: widget.size * 0.6,
      ),
    );
  }
}