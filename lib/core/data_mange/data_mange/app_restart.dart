import 'dart:io';
import 'package:path/path.dart' as p;

class AppRestart {
  static Future<void> restart() async {
    final appPath = p.join(
      p.dirname(Platform.resolvedExecutable),
      'ModuPOS.exe',
    );

    await Process.start(
      appPath,
      [],
      mode: ProcessStartMode.detached,
    );

    exit(0);
  }
}