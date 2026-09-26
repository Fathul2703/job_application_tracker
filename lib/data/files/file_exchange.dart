import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Rect;

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Moves files in and out of the app. An interface so tests can use a fake
/// instead of the platform share sheet and file picker.
abstract interface class FileExchange {
  /// Saves [content] as [fileName] and opens the share sheet, where the user
  /// can save it to Files, send it, etc. [origin] anchors the sheet on iPad.
  Future<void> shareTextFile({
    required String fileName,
    required String content,
    required String mimeType,
    Rect? origin,
  });

  /// Lets the user pick a file with one of [extensions]. Returns its text,
  /// or `null` when the picker is dismissed.
  Future<String?> pickTextFile({required List<String> extensions});
}

class PlatformFileExchange implements FileExchange {
  const PlatformFileExchange();

  @override
  Future<void> shareTextFile({
    required String fileName,
    required String content,
    required String mimeType,
    Rect? origin,
  }) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: mimeType)],
        subject: fileName,
        sharePositionOrigin: origin,
      ),
    );
  }

  @override
  Future<String?> pickTextFile({required List<String> extensions}) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    if (file == null) return null;
    // Throws FormatException for non-UTF-8 files; callers treat it as an
    // unreadable backup.
    return utf8.decode(await file.readAsBytes());
  }
}
