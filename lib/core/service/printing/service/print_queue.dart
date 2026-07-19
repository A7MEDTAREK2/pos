import 'dart:collection';

class PrintQueue {
  PrintQueue._();

  static final PrintQueue instance = PrintQueue._();

  final Queue<Future<void> Function()> _jobs = Queue();

  bool _isPrinting = false;

  void add(Future<void> Function() job) {
    _jobs.add(job);
    _run();
  }

  Future<void> _run() async {
    if (_isPrinting) return;

    _isPrinting = true;

    while (_jobs.isNotEmpty) {
      final job = _jobs.removeFirst();

      try {
        await job();
      } catch (_) {
        // هنعالج الفشل بعدين
      }
    }

    _isPrinting = false;
  }
}