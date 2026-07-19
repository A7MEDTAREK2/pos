// lib/feature/sale/presentation/widget/sale_details_content.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Sale ======
import '../../data/model/sale_model.dart';

class SaleDetailsContent extends StatelessWidget {
  final SalesHistoryModel sale;
  final List<SaleItemModel> items;

  const SaleDetailsContent({
    super.key,
    required this.sale,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .85,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colorsmanegments.grey300,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "فاتورة رقم #${sale.orderNumber}",
              style: TxtStyle.headerSmall,
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(
                      item.productName,
                      style: TxtStyle.bodyMedium,
                    ),
                    subtitle: Text(
                      "الكمية : ${item.quantity}",
                      style: TxtStyle.bodySmall,
                    ),
                    trailing: Text(
                      "${item.price} ج.م",
                      style: TxtStyle.tableRowBold.copyWith(
                        color: Colorsmanegments.primary,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    "الإجمالي",
                    style: TxtStyle.totalMedium,
                  ),
                  const Spacer(),
                  Text(
                    "${sale.total} ج.م",
                    style: TxtStyle.totalLarge.copyWith(
                      color: Colorsmanegments.success,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}