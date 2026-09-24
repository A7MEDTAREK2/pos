import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/purchase_item_model.dart';
import '../../logic/purchase_cubit.dart';

class PurchaseItemWidget extends StatelessWidget {
  final PurchaseItemModel item;

  const PurchaseItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colors.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                item.productName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context
                        .read<PurchaseCubit>()
                        .decrementQuantity(item.purchaseProductId);
                  },
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  width: 45,
                  alignment: Alignment.center,
                  child: Text(
                    '${item.quantity}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context
                        .read<PurchaseCubit>()
                        .incrementQuantity(item.purchaseProductId);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 110,
              child: Text(
                item.costPrice.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120,
              child: Text(
                item.total.toStringAsFixed(2),
                textAlign: TextAlign.end,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              tooltip: 'حذف',
              onPressed: () {
                context
                    .read<PurchaseCubit>()
                    .removeItem(item.purchaseProductId);
              },
              icon: Icon(
                Icons.delete_outline,
                color: colors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}