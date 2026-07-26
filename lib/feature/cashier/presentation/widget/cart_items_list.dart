import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../logic/pos_cubit.dart';

import 'delete_item_dialog.dart';
import 'notes_dialog.dart';

class CartItemsList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final OrderCubit cubit;

  const CartItemsList({
    super.key,
    required this.items,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconss.cartEmpty,
              size: 30,
              color: Colorsmanegments.grey,
            ),
            const SizedBox(height: 12),
            Text(
              "السلة فارغة",
              style: TxtStyle.emptyTitle,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final total = (item['price'] as num).toDouble() * (item['quantity'] as int);

        return _buildCartItem(context, item, total);
      },
    );
  }

  Widget _buildCartItem(
      BuildContext context,
      Map<String, dynamic> item,
      double total,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colorsmanegments.border),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.blackOpacity10,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProductImage(item),
          const SizedBox(width: 10),
          Expanded(
            child: _buildProductDetails(item),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${total.toStringAsFixed(2)} ج.م",
                style: TxtStyle.tableRowBold.copyWith(
                  color: Colorsmanegments.primary,
                ),
              ),
              const SizedBox(height: 4),
              _buildQuantityControls(item),
              const SizedBox(height: 4),
              _buildActionButtons(context, item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(Map<String, dynamic> item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: item['image'] != null && (item['image'] as String).isNotEmpty
          ? Image.file(
        File(item['image']),
        width: 42,
        height: 42,
        fit: BoxFit.cover,
      )
          : Container(
        width: 42,
        height: 42,
        color: Colorsmanegments.background,
        child: Icon(
          Iconss.food,
          color: Colorsmanegments.blueGrey,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildProductDetails(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['size'] != null
              ? "${item['name']} (${item['size']})"
              : item['name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TxtStyle.tableRowBold,
        ),
        const SizedBox(height: 2),
        Text(
          "${item['price']} ج.م",
          style: TxtStyle.bodySmall,
        ),
        if ((item['note'] ?? '').toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                Icon(
                  Iconss.note,
                  size: 11,
                  color: Colorsmanegments.orange,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    item['note'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TxtStyle.badgeWarning,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuantityControls(Map<String, dynamic> item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: "Ctrl + - - تقليل الكمية",
          waitDuration: const Duration(milliseconds: 300),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Iconss.removeCircle,
              size: 18,
            ),
            onPressed: () {
              cubit.decrementItem(
                item['productId'],
                size: item['size'],
              );
            },
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "${item['quantity']}",
          style: TxtStyle.tableRowBold,
        ),
        const SizedBox(width: 4),
        Tooltip(
          message: "Ctrl + + - زيادة الكمية",
          waitDuration: const Duration(milliseconds: 300),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Iconss.addCircle,
              color: Colorsmanegments.primary,
              size: 18,
            ),
            onPressed: () {
              cubit.incrementItem(
                item['productId'],
                size: item['size'],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: "Ctrl + N - إضافة ملاحظة",
          waitDuration: const Duration(milliseconds: 300),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: "ملاحظة",
            onPressed: () {
              _showNotesDialog(context, item);
            },
            icon: Icon(
              Iconss.noteOutline,
              color: Colorsmanegments.orange,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: "Delete - حذف العنصر",
          waitDuration: const Duration(milliseconds: 300),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: "حذف",
            onPressed: () {
              _showDeleteDialog(context, item);
            },
            icon: Icon(
              Iconss.delete,
              color: Colorsmanegments.danger,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _showNotesDialog(BuildContext context, Map<String, dynamic> item) async {
    final controller = TextEditingController(text: item['note'] ?? "");
    final result = await showDialog<String>(
      context: context,
      builder: (_) => NotesDialog(controller: controller),
    );

    if (result != null) {
      cubit.updateItemNote(item['productId'], result, size: item['size']);
    }
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (_) => DeleteItemDialog(
        itemName: item['name'],
        onDelete: () {
          cubit.removeItem(item['productId'], size: item['size']);
        },
      ),
    );
  }
}