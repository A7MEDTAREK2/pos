import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/presentation/screen/home_screen.dart';
import '../../data/model/shifts.dart';
import '../../logic/shifts_cubit.dart';
import '../../logic/shifts_state.dart';

// استيراد الشاشة الرئيسية والـ UserSession للتنقل السليم
import '../../../../../../core/service/user_session.dart';

class ShiftScreen extends StatefulWidget {
  final int userId;
  final String userName;

  const ShiftScreen({Key? key, required this.userId, required this.userName}) : super(key: key);

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _actualCashController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // أول ما الشاشة تفتح، بنتشيك على الوردية الحالية
    context.read<ShiftCubit>().checkActiveShift();
  }

  @override
  void dispose() {
    _cashController.dispose();
    _noteController.dispose();
    _actualCashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الورديات'),
        centerTitle: true,
      ),
      body: BlocConsumer<ShiftCubit, ShiftState>(
        listener: (context, state) {
          if (state is ShiftOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is ShiftError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is ShiftLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final cubit = context.read<ShiftCubit>();
          final activeShift = cubit.activeShift;

          if (activeShift == null || activeShift.status == 'closed') {
            return _buildOpenShiftView(context);
          } else {
            return _buildActiveShiftView(context, activeShift, cubit.transactions);
          }
        },
      ),
    );
  }

  // 1. واجهة فتح وردية جديدة (لو مفيش وردية مفتوحة)
  Widget _buildOpenShiftView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.point_of_sale, size: 80, color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            'لا توجد وردية مفتوحة حالياً',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'الرجاء إدخال رصيد الخزنة الافتتاحي لبدء الوردية',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _cashController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'رصيد فتح الوردية (Opening Cash)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.money),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final openingCash = double.tryParse(_cashController.text) ?? 0.0;
              if (openingCash <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء إدخال مبلغ صحيح')),
                );
                return;
              }
              context.read<ShiftCubit>().openShift(
                userId: widget.userId,
                openingCash: openingCash,
              );
            },
            child: const Text('فتح الوردية الآن', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  // 2. واجهة الوردية المفتوحة (عرض التفاصيل، الحركات، زر الدخول للرئيسية وإغلاق الوردية)
  Widget _buildActiveShiftView(BuildContext context, ShiftModel shift, List transactions) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('رقم الوردية: #${shift.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Chip(label: Text('مفتوحة', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('الرصيد الافتتاحي:'),
                      Text('${shift.openingCash} ج.م', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('الكاش المتوقع بالدرج:'),
                      Text('${shift.expectedCash} ج.م', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // زر الانتقال للشاشة الرئيسية (POS / البيع)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(
                    user: UserSession.currentUser!,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.point_of_sale),
            label: const Text('الدخول إلى شاشة البيع الرئيسية (POS)', style: TextStyle(fontSize: 16)),
          ),

          const SizedBox(height: 20),
          const Text('حركات الخزينة الأخيرة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text('لا توجد حركات نقدية مسجلة بعد'))
                : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final isCashIn = tx.type == 'cash_in';
                return ListTile(
                  leading: Icon(
                    isCashIn ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isCashIn ? Colors.green : Colors.red,
                  ),
                  title: Text(tx.reason),
                  subtitle: Text(tx.createdAt.substring(11, 16)), // عرض الوقت فقط
                  trailing: Text(
                    '${isCashIn ? '+' : '-'}${tx.amount} ج.م',
                    style: TextStyle(
                      color: isCashIn ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showAddTransactionDialog(context, shift.id!),
                  icon: const Icon(Icons.add),
                  label: const Text('حركة نقدية'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () => _showCloseShiftDialog(context, shift),
                  child: const Text('إغلاق الوردية'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // دايلوج لإضافة حركة نقدية (سحب أو إيداع)
  void _showAddTransactionDialog(BuildContext context, int shiftId) {
    final amountController = TextEditingController();
    final reasonController = TextEditingController();
    String type = 'cash_in';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('إضافة حركة نقدية للخزينة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'cash_in', child: Text('إيداع (Cash In)')),
                  DropdownMenuItem(value: 'cash_out', child: Text('صرف/مسحوبات (Cash Out)')),
                ],
                onChanged: (val) => type = val!,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'المبلغ'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: 'السبب (مثلاً: شراء سلع، عهدة...)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                final reason = reasonController.text.trim();
                if (amount > 0 && reason.isNotEmpty) {
                  Navigator.pop(dialogContext);
                  context.read<ShiftCubit>().addCashTransaction(
                    shiftId: shiftId,
                    userId: widget.userId,
                    type: type,
                    amount: amount,
                    reason: reason,
                  );
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  // دايلوج إغلاق الوردية
  void _showCloseShiftDialog(BuildContext context, ShiftModel shift) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('إغلاق الوردية'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('الكاش المتوقع في الدرج: ${shift.expectedCash} ج.م'),
              const SizedBox(height: 15),
              TextField(
                controller: _actualCashController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'الكاش الفعلي الموجود بالدرج حالياً'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'ملاحظات الإغلاق (اختياري)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                // تم إصلاح الأخطاء هنا بالتأكد من التعامل مع الـ null وضبط النوع double
                final double actualCash = double.tryParse(_actualCashController.text) ?? -1.0;

                if (actualCash < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء إدخال مبلغ صحيح للكاش الفعلي')),
                  );
                  return;
                }
                Navigator.pop(dialogContext);

                // التأكد من تحويل expectedCash إلى double لو كانت num
                final double expectedCashValue = (shift.expectedCash is int)
                    ? (shift.expectedCash as int).toDouble()
                    : (shift.expectedCash as double);

                context.read<ShiftCubit>().closeShift(
                  shiftId: shift.id!,
                  actualCash: actualCash,
                  expectedCash: expectedCashValue,
                  closingNote: _noteController.text.isEmpty ? null : _noteController.text,
                  userId: widget.userId,
                  userName: widget.userName,
                );
              },
              child: const Text('تأكيد الإغلاق'),
            ),
          ],
        );
      },
    );
  }
}