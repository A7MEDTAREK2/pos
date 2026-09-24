import 'package:flutter/material.dart';
import '../../data/model/stock_item_model.dart';

class AdjustStockDialog extends StatefulWidget {
  final StockItemModel item;
  final Function(double newQty, String reason, String note) onConfirm;

  const AdjustStockDialog({
    super.key,
    required this.item,
    required this.onConfirm,
  });

  @override
  State<AdjustStockDialog> createState() => _AdjustStockDialogState();
}

class _AdjustStockDialogState extends State<AdjustStockDialog> {
  late TextEditingController _qtyController;
  late TextEditingController _noteController;
  String _selectedReason = 'manual';

  final Map<String, String> _reasonsMap = {
    'manual': 'تسوية يدوية (جرد)',
    'purchase': 'شراء جديد',
    'damage': 'تالف / هالك',
    'return': 'مرتجع',
  };

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: widget.item.quantity.toInt().toString());
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تعديل كمية: ${widget.item.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _qtyController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'الكمية الجديدة الفعلية',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: const InputDecoration(
                labelText: 'سبب التعديل',
                border: OutlineInputBorder(),
              ),
              items: _reasonsMap.entries.map((e) {
                return DropdownMenuItem(value: e.key, child: Text(e.value));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedReason = val);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'ملاحظات (اختياري)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            final double? parsed = double.tryParse(_qtyController.text);
            if (parsed != null) {
              widget.onConfirm(parsed, _selectedReason, _noteController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}