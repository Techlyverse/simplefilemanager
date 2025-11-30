import 'dart:io';
import 'package:filemanager/data/enums.dart';
import 'package:path/path.dart' as p;

/// An extension on [FileSystemEntity] to provide convenient getters
/// for extracting file/directory names, extensions, and type checks.
extension FileSystemEntityExtension on FileSystemEntity {
  static const Set<String> _imageExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.heic',
    '.heif',
    '.tiff',
    '.bmp',
  };
  static const Set<String> _videoExtensions = {
    '.mp4',
    '.flv',
    '.mkv',
    '.avi',
    '.mov',
    '.wmv',
    '.3gp',
    '.webm',
  };
  static const Set<String> _audioExtensions = {
    '.mp3',
    '.wav',
    '.ogg',
    '.flac',
    '.aac',
    '.wma',
    '.m4a',
  };
  static const Set<String> _archiveExtensions = {
    '.zip',
    '.rar',
    '.7z',
    '.tar',
    '.gz',
    '.bz2',
    '.iso',
  };

  /// Returns the full name of the file or directory, including its extension
  /// if it's a file. This is the last segment of the path.
  ///
  /// Examples:
  /// - For a file "/path/to/document.pdf", returns "document.pdf".
  /// - For a directory "/path/to/my_folder/", returns "my_folder".
  /// - For a hidden file "/path/to/.gitignore", returns ".gitignore".
  String get nameWithExtension {
    return p.basename(path);
  }

  /// Returns the name of the file or directory without its extension.
  ///
  /// This getter correctly handles:
  /// - Standard files (e.g., "report.txt" -> "report").
  /// - Files with multiple dots (e.g., "archive.tar.gz" -> "archive.tar").
  /// - Hidden files (e.g., ".bashrc" -> ".bashrc").
  /// - Directories (e.g., "/my_folder/" -> "my_folder").
  String get name {
    // p.basename gets the last segment (e.g., "document.pdf" or "my_folder")
    // p.withoutExtension then removes the extension from that segment.
    return p.withoutExtension(p.basename(path));
  }

  /// Returns the extension of the file, including the leading dot.
  /// Returns an empty string if the entity is a directory, has no extension,
  /// or if it's a hidden file with no further extension (e.g., ".gitignore").
  ///
  /// Examples:
  /// - For a file "/path/to/document.pdf", returns ".pdf".
  /// - For a file "/path/to/archive.tar.gz", returns ".gz".
  /// - For a file "/path/to/README", returns "".
  /// - For a hidden file "/path/to/.gitignore", returns "".
  /// - For a directory "/path/to/my_folder/", returns "".
  String get extension {
    // p.extension returns the extension including the dot.
    // It correctly handles multiple extensions and no extension.
    return p.extension(path);
  }

  EntityType get fileType {
    // Directories are not media files, so check first.
    if (this is Directory) return EntityType.directory;

    // Convert the extension to lowercase for reliable, case-insensitive checks
    final String fileExt = extension.toLowerCase();

    if (_imageExtensions.contains(fileExt)) {
      return EntityType.image;
    } else if (_videoExtensions.contains(fileExt)) {
      return EntityType.video;
    } else if (_audioExtensions.contains(fileExt)) {
      return EntityType.audio;
    } else if (_archiveExtensions.contains(fileExt)) {
      return EntityType.archive;
    } else {
      return EntityType.other;
    }
  }
}
