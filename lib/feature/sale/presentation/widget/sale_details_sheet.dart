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
                  color: Colorsmanegments.grey300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "فاتورة #${sale.orderNumber}",
                style: TxtStyle.headerSmall,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _infoTile(
                      Iconss.person,
                      "العميل",
                      sale.displayCustomerName,
                    ),
                    if (sale.customerPhone.isNotEmpty)
                      _infoTile(
                        Iconss.phone,
                        "الهاتف",
                        sale.customerPhone,
                      ),
                    _infoTile(
                      Iconss.shoppingBag,
                      "نوع الطلب",
                      sale.orderTypeStringAr,
                    ),
                    _infoTile(
                      Iconss.calendar,
                      "التاريخ",
                      _formatDate(sale.createdAt),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Text(
                      "المنتجات",
                      style: TxtStyle.titleCard,
                    ),
                    const SizedBox(height: 10),
                    ...items.map(
                          (item) => SaleItemCard(item: item),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    _totalRow(
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
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colorsmanegments.primary),
          const SizedBox(width: 10),
          Text(
            "$title : ",
            style: TxtStyle.labelBold,
          ),
          Expanded(
            child: Text(
              value,
              style: TxtStyle.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(
      String title,
      String value,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TxtStyle.totalMedium,
        ),
        Text(
          value,
          style: TxtStyle.totalLarge.copyWith(
            color: Colorsmanegments.success,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}