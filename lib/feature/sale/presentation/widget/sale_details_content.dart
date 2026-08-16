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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                color: colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "فاتورة رقم #${sale.orderNumber}",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: theme.dividerColor),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(
                      item.productName,
                      style: theme.textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      "الكمية : ${item.quantity}",
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: Text(
                      "${item.price} ج.م",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(color: theme.dividerColor),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    "الإجمالي",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${sale.total} ج.م",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
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