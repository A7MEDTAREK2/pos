import 'package:flutter/material.dart';
import '../../data/model/stock_item_model.dart';

class StockItemCard extends StatelessWidget {
  final StockItemModel item;
  final VoidCallback onEditTap;

  const StockItemCard({
    super.key,
    required this.item,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLow = item.isLowStock;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isLow ? const BorderSide(color: Colors.red, width: 1.5) : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('البارکود: ${item.barcode ?? "غير محدد"}'),
            Text('سعر البيع: ${item.sellPrice.toStringAsFixed(2)} ج.م'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'الكمية: ${item.quantity.toInt()}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isLow ? Colors.red : Colors.green,
                  ),
                ),
                if (item.minimumStock > 0)
                  Text(
                    'الحد الأدنى: ${item.minimumStock.toInt()}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.blue),
              onPressed: onEditTap,
            ),
          ],
        ),
      ),
    );
  }
}