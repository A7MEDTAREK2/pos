// lib/feature/sale/presentation/widget/sale_item_card.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Sale ======
import '../../data/model/sale_model.dart';

class SaleItemCard extends StatelessWidget {
  final SaleItemModel item;
  final bool showNote;
  final bool isCompact;

  const SaleItemCard({
    super.key,
    required this.item,
    this.showNote = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final total = item.quantity * item.price;

    return Container(
      margin: EdgeInsets.only(bottom: isCompact ? 6 : 10),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(isCompact ? 10 : 14),
        border: Border.all(
          color: Colorsmanegments.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: isCompact ? 4 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 10 : 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildQuantityBadge(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductName(),
                  const SizedBox(height: 4),
                  _buildProductDetails(),
                  if (showNote && item.note != null && item.note!.isNotEmpty)
                    _buildNote(),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildTotalPrice(total),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityBadge() {
    return Container(
      width: isCompact ? 32 : 40,
      height: isCompact ? 32 : 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colorsmanegments.primary,
            Colorsmanegments.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.primary.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${item.quantity}',
          style: TxtStyle.badge.copyWith(
            fontSize: isCompact ? 14 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      item.productName,
      style: TextStyle(
        fontSize: isCompact ? 14 : 16,
        fontWeight: FontWeight.w600,
        color: Colorsmanegments.textPrimary,
        height: 1.2,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProductDetails() {
    final hasSize = item.sizeName != null && item.sizeName!.isNotEmpty;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '${item.price.toStringAsFixed(2)} ج.م',
          style: TxtStyle.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildDotDivider(),
        Text(
          '× ${item.quantity}',
          style: TxtStyle.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        if (hasSize) ...[
          _buildDotDivider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colorsmanegments.primary.withOpacity(0.1),
                  Colorsmanegments.primary.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Colorsmanegments.primary.withOpacity(0.2),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconss.size,
                  size: 12,
                  color: Colorsmanegments.primary,
                ),
                const SizedBox(width: 3),
                Text(
                  item.sizeName!,
                  style: TxtStyle.badgeSmall.copyWith(
                    color: Colorsmanegments.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDotDivider() {
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        color: Colorsmanegments.border,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildNote() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colorsmanegments.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colorsmanegments.warning.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Iconss.noteOutline,
            size: 13,
            color: Colorsmanegments.warning,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              item.note!,
              style: TxtStyle.bodySmall.copyWith(
                color: Colorsmanegments.textSecondary,
                fontStyle: FontStyle.italic,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPrice(double total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colorsmanegments.success.withOpacity(0.1),
            Colorsmanegments.success.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colorsmanegments.success.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isCompact ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: Colorsmanegments.success,
            ),
          ),
          Text(
            'ج.م',
            style: TxtStyle.labelSmall.copyWith(
              color: Colorsmanegments.success.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}