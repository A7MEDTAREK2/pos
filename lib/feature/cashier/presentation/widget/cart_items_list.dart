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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconss.cartEmpty,
              size: 30,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              "السلة فارغة",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProductImage(context, item),
          const SizedBox(width: 10),
          Expanded(
            child: _buildProductDetails(context, item),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${total.toStringAsFixed(2)} ج.م",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              _buildQuantityControls(context, item),
              const SizedBox(height: 4),
              _buildActionButtons(context, item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        color: colorScheme.background,
        child: Icon(
          Iconss.food,
          color: colorScheme.onSurface.withOpacity(0.3),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['size'] != null
              ? "${item['name']} (${item['size']})"
              : item['name'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "${item['price']} ج.م",
          style: theme.textTheme.bodySmall,
        ),
        if ((item['note'] ?? '').toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                Icon(
                  Iconss.note,
                  size: 11,
                  color: Colors.amber,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    item['note'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              color: colorScheme.onSurface.withOpacity(0.4),
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
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
              color: colorScheme.primary,
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
    final theme = Theme.of(context);

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
              color: Colors.amber,
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
              color: Colors.red,
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