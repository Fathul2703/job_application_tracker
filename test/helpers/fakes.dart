import 'dart:ui' show Rect;

import 'package:job_application_tracker/data/files/file_exchange.dart';

/// Records shared files and returns a preset file when picking.
class FakeFileExchange implements FileExchange {
  FakeFileExchange({this.fileToPick});

  final shared = <({String fileName, String content, String mimeType})>[];

  /// Returned by [pickTextFile]; `null` simulates dismissing the picker.
  String? fileToPick;

  @override
  Future<void> shareTextFile({
    required String fileName,
    required String content,
    required String mimeType,
    Rect? origin,
  }) async {
    shared.add((fileName: fileName, content: content, mimeType: mimeType));
  }

  @override
  Future<String?> pickTextFile({required List<String> extensions}) async =>
      fileToPick;
}
