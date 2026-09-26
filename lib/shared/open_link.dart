import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Whether [text] is an absolute http(s) link worth offering to open.
bool isWebLink(String text) {
  final uri = Uri.tryParse(text.trim());
  return uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
}

/// Opens [url] in the browser (or the app that handles it) and shows a
/// message if that is not possible.
Future<void> openLink(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.of(context);
  var opened = false;
  if (isWebLink(url)) {
    try {
      opened = await launchUrl(
        Uri.parse(url.trim()),
        mode: LaunchMode.externalApplication,
      );
    } on Exception {
      opened = false;
    }
  }
  if (!opened) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text("Couldn't open the link")));
  }
}
