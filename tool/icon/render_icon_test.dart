// Renders the app icon and splash artwork from code, so the branding can be
// regenerated without design tools:
//
//   flutter test tool/icon/render_icon_test.dart
//   dart run flutter_launcher_icons
//   dart run flutter_native_splash:create
//
// Lives outside test/ so it doesn't run with the normal suite.

import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

const _indigo = Color(0xFF4F46E5); // AppColors.seed
const _white = Color(0xFFFFFFFF);

/// Briefcase with a check mark, drawn in a unit square and scaled to [size].
/// [scale] shrinks the glyph around the centre (adaptive-icon safe zone).
void _paintGlyph(
  Canvas canvas,
  double size, {
  double scale = 1,
  Color checkColor = _indigo,
  BlendMode checkBlend = BlendMode.srcOver,
}) {
  canvas
    ..save()
    ..translate(size / 2, size / 2)
    ..scale(size * scale)
    ..translate(-0.5, -0.5);

  final white = Paint()..color = _white;
  // Handle: a rounded outline peeking above the body.
  canvas.drawRRect(
    RRect.fromLTRBR(0.38, 0.22, 0.62, 0.42, const Radius.circular(0.06)),
    Paint()
      ..color = _white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.055,
  );
  // Body.
  canvas.drawRRect(
    RRect.fromLTRBR(0.2, 0.34, 0.8, 0.78, const Radius.circular(0.08)),
    white,
  );
  // Check mark cut into the body.
  canvas
    ..drawPath(
      Path()
        ..moveTo(0.375, 0.56)
        ..lineTo(0.465, 0.65)
        ..lineTo(0.635, 0.475),
      Paint()
        ..color = checkColor
        ..blendMode = checkBlend
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.06
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    )
    ..restore();
}

Future<void> _save(
  String path,
  int size,
  void Function(Canvas canvas, double size) paint,
) async {
  final recorder = PictureRecorder();
  paint(Canvas(recorder), size.toDouble());
  final image = await recorder.endRecording().toImage(size, size);
  final bytes = await image.toByteData(format: ImageByteFormat.png);
  File(path).writeAsBytesSync(bytes!.buffer.asUint8List());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('render branding assets', () async {
    // Full-bleed icon (iOS masks the corners itself; no transparency).
    await _save('assets/branding/icon.png', 1024, (canvas, size) {
      canvas.drawRect(Offset.zero & Size(size, size), Paint()..color = _indigo);
      _paintGlyph(canvas, size);
    });

    // Android adaptive foreground: glyph inside the 66% safe zone.
    await _save('assets/branding/icon_foreground.png', 1024, (canvas, size) {
      _paintGlyph(canvas, size, scale: 0.62);
    });

    // Android 13+ themed icon: single colour, the check punched out.
    await _save('assets/branding/icon_monochrome.png', 1024, (canvas, size) {
      canvas.saveLayer(Offset.zero & Size(size, size), Paint());
      _paintGlyph(canvas, size, scale: 0.62, checkBlend: BlendMode.clear);
      canvas.restore();
    });

    // Splash logo: rounded indigo tile with the glyph.
    await _save('assets/branding/splash_logo.png', 768, (canvas, size) {
      canvas.drawRRect(
        RRect.fromLTRBR(0, 0, size, size, Radius.circular(size * 0.22)),
        Paint()..color = _indigo,
      );
      _paintGlyph(canvas, size);
    });

    // Android 12+ splash: the system draws the icon background circle.
    await _save('assets/branding/splash_android12.png', 1152, (canvas, size) {
      _paintGlyph(canvas, size, scale: 0.5);
    });
  });
}
