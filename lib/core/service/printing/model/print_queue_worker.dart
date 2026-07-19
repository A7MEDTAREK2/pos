import 'dart:async';
import 'dart:convert';

import '../printing_manager.dart';
import '../service/modu_print_service.dart';
import '../model/print_queue_model.dart';
import '../service/print_queue_local.dart';
import '../service/print_queue_repository.dart';

class PrintQueueWorker {
  PrintQueueWorker._();

  static final PrintQueueWorker instance = PrintQueueWorker._();

  final PrintQueueRepository _repository =
  PrintQueueRepository(PrintQueueLocalDataSource());

  final ModuPrintService _service = ModuPrintService();

  Timer? _timer;

  void start() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _process(),
    );
  }

  Future<void> _process() async {
    try {
      await _service.getStatus();
    } catch (_) {
      // الـ API مش شغال
      return;
    }
    final jobs = await _repository.getPendingJobs();

    if (jobs.isEmpty) return;

    for (final job in jobs) {
      try {
        final payload = jsonDecode(job.payload);

        switch (job.type) {
          case "receipt":
            await _service.printReceipt(payload);
            break;

          case "kitchen":
            await _service.printKitchen(payload);
            break;

          case "daily_report":
            await _service.printDailyReport(payload);
            break;

          case "report":
            await _service.printReport(payload);
            break;
        }

        await _repository.markPrinted(job.id!);

        print("✅ Printed Queue Job ${job.id}");
      } catch (e) {
        await _repository.markFailed(
          job.id!,
          e.toString(),
          job.retryCount + 1,
        );

        print("❌ Queue Retry Failed ${job.id}");
      }
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}