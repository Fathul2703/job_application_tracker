import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/core/app_info.dart';

void main() {
  test('AppInfo matches the version in pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match = RegExp(
      r'^version:\s*(\S+)\+(\d+)\s*$',
      multiLine: true,
    ).firstMatch(pubspec);

    expect(match, isNotNull, reason: 'pubspec.yaml needs version: x.y.z+n');
    expect(AppInfo.version, match![1]);
    expect(AppInfo.buildNumber, int.parse(match[2]!));
  });
}
