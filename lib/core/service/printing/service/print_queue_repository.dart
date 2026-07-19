import '../model/print_queue_model.dart';
import 'print_queue_local.dart';

class PrintQueueRepository {
  final PrintQueueLocalDataSource _local;


  PrintQueueRepository(this._local);

  Future<void> addJob(PrintQueueModel model) async {
    await _local.add(model);
  }

  Future<List<PrintQueueModel>> getPendingJobs() async {
    return await _local.pending();
  }

  Future<void> markPrinted(int id) async {
    await _local.markPrinted(id);
  }

  Future<void> markFailed(
      int id,
      String error,
      int retryCount,
      ) async {
    await _local.markFailed(
      id,
      error,
      retryCount,
    );
  }

  // ==========================
  // Retry Queue
  // ==========================
  Future<void> retryPendingJobs(
      Future<void> Function(PrintQueueModel job) sender,
      ) async {
    final jobs = await getPendingJobs();

    if (jobs.isEmpty) return;

    final job = jobs.first;

// اطبعها فقط
      try {
        await sender(job);

        await markPrinted(job.id!);

        print("✅ Printed Job #${job.id}");
      } catch (e) {
        await markFailed(
          job.id!,
          e.toString(),
          job.retryCount + 1,
        );

        print("❌ Failed Job #${job.id}");
      }

  }
}