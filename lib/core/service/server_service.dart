import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';

class ServerService {
  static const _baseUrl = "http://127.0.0.1:5089";

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 2),
      receiveTimeout: const Duration(seconds: 2),
    ),
  );

  static Future<bool> isRunning() async {
    try {
      final response = await _dio.get("/api/printer/status");
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// يحدد اسم الملف المناسب حسب معمارية الجهاز
  static String _getExeName() {
    final abi = Abi.current();
    switch (abi) {
      case Abi.windowsX64:
        return 'ModuPrintService_x64.exe';
      case Abi.windowsIA32:
        return 'ModuPrintService_x86.exe';
      case Abi.windowsArm64:
      // لو حابب تدعم ARM64 كمان لاحقًا، ضيف بناء مخصص ليها
        return 'ModuPrintService_x64.exe'; // fallback مؤقت
      default:
        throw Exception("Unsupported architecture: $abi");
    }
  }

  static Future<void> start() async {
    if (await isRunning()) return;

    final exeDir = File(Platform.resolvedExecutable).parent.path;
    final exeName = _getExeName();
    final exe = File('$exeDir${Platform.pathSeparator}$exeName');

    print("Detected architecture: ${Abi.current()}");
    print("Looking for exe at: ${exe.path}, exists: ${exe.existsSync()}");

    if (!exe.existsSync()) {
      throw Exception("$exeName not found at ${exe.path}");
    }

    final process = await Process.start(
      exe.path,
      [],
      workingDirectory: exe.parent.path,
      mode: ProcessStartMode.detached,
    );

    print("Started process with pid: ${process.pid}");

    for (int i = 0; i < 20; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      final running = await isRunning();
      print("Attempt $i: isRunning = $running");
      if (running) return;
    }

    throw Exception("Print Service failed to start within the timeout period.");
  }
}