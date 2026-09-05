// Crops each phone screenshot in docs/store/screenshots/ down to an exact
// 9:16 portrait ratio from the top - Play Console requires screenshots be
// exactly 16:9 or 9:16, not merely within a 2:1 ratio. Most phone emulators
// are taller than 9:16 (this project's test emulator is 1080x2340), and in
// this app's screens the bottom nav bar and trailing blank space (not real
// content) sit in that extra height, so keeping the top width*16/9 rows and
// dropping the rest loses only chrome, not content - verify that still
// holds if you add a screen whose content runs closer to the bottom.
//
// Run with `flutter test tool/crop_store_screenshots.dart`.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

const _dir = 'docs/store/screenshots';

void main() {
  test('crop screenshots to exact 9:16', () {
    for (final entity in Directory(_dir).listSync()) {
      if (entity is! File || !entity.path.endsWith('.png')) continue;
      final image = img.decodeImage(entity.readAsBytesSync())!;
      final targetHeight = (image.width * 16 / 9).round();
      if (image.height == targetHeight) continue;
      final cropped = img.copyCrop(
        image,
        x: 0,
        y: 0,
        width: image.width,
        height: targetHeight,
      );
      entity.writeAsBytesSync(img.encodePng(cropped));
      // ignore: avoid_print
      print('Cropped ${entity.path} to ${cropped.width}x${cropped.height}');
    }
  });
}
