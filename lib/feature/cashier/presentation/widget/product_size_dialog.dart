// lib/feature/cashier/presentation/widget/product_size_dialog.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Product ======
import '../../../product/data/model/product_model.dart';

class ProductSizeDialog extends StatelessWidget {
  final ProductModel product;
  final void Function(ProductSize size) onSizeSelected;

  const ProductSizeDialog({
    super.key,
    required this.product,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ============================================================
            // Header
            // ============================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colorsmanegments.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Iconss.size,
                        color: Colorsmanegments.textWhite,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "اختر الحجم",
                        style: TxtStyle.bodyMedium.copyWith(
                          color: Colorsmanegments.textWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Iconss.close,
                          color: Colorsmanegments.textWhite,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: TxtStyle.headerWhite.copyWith(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            // ============================================================
            // Sizes List
            // ============================================================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: product.sizes!.map((size) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pop(context);
                        onSizeSelected(size);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colorsmanegments.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colorsmanegments.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colorsmanegments.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Iconss.food,
                                color: Colorsmanegments.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                size.sizeName,
                                style: TxtStyle.titleSmall,
                              ),
                            ),
                            Text(
                              "${size.price.toStringAsFixed(2)} ج.م",
                              style: TxtStyle.buttonPrimary.copyWith(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Iconss.arrowForward,
                              color: Colorsmanegments.textSecondary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}