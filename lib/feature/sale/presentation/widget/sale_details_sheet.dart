// lib/feature/sale/presentation/widget/sale_details_sheet.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Sale ======
import '../../data/model/sale_model.dart';
import 'sale_item_card.dart';

class SaleDetailsSheet extends StatelessWidget {
  final SalesHistoryModel sale;
  final List<SaleItemModel> items;

  const SaleDetailsSheet({
    super.key,
    required this.sale,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: .85,
        maxChildSize: .95,
        minChildSize: .5,
        expand: false,
        builder: (context, controller) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "فاتورة #${sale.orderNumber}",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _infoTile(
                      context,
                      Iconss.person,
                      "العميل",
                      sale.displayCustomerName,
                    ),
                    if (sale.customerPhone.isNotEmpty)
                      _infoTile(
                        context,
                        Iconss.phone,
                        "الهاتف",
                        sale.customerPhone,
                      ),
                    _infoTile(
                      context,
                      Iconss.shoppingBag,
                      "نوع الطلب",
                      sale.orderTypeStringAr,
                    ),
                    _infoTile(
                      context,
                      Iconss.calendar,
                      "التاريخ",
                      _formatDate(sale.createdAt),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: theme.dividerColor),
                    Text(
                      "المنتجات",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...items.map(
                          (item) => SaleItemCard(item: item),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: theme.dividerColor),
                    _totalRow(
                      context,
                      "الإجمالي",
                      "${sale.total.toStringAsFixed(2)} ج.م",
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoTile(
      BuildContext context,
      IconData icon,
      String title,
      String value,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            "$title : ",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(
      BuildContext context,
      String title,
      String value,
      ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}