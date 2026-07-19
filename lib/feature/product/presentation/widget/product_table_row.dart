// lib/feature/product/presentation/widget/product_table_row.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Category ======
import '../../../category/data/model/category_model.dart';

// ====== Product ======
import '../../data/model/product_model.dart';
import '../../logic/product_cubit.dart';
import '../../logic/product_state.dart';
import '../widget/add_product_dialog.dart';

class ProductTableRow extends StatelessWidget {
  final ProductModel product;

  const ProductTableRow({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colorsmanegments.border),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ====== 1. عمود الصورة ======
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: (product.image != null &&
                  product.image!.isNotEmpty &&
                  File(product.image!).existsSync())
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.file(
                  File(product.image!),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(
                Iconss.image,
                size: 30,
                color: Colorsmanegments.textSecondary,
              ),
            ),
          ),

          // ====== 2. اسم المنتج ======
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    product.name,
                    style: TxtStyle.tableRowBold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (product.hasSizes) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colorsmanegments.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${product.sizes!.length} أحجام",
                      style: TxtStyle.badgeSmall.copyWith(
                        color: Colorsmanegments.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ====== 3. الباركود ======
          Expanded(
            flex: 2,
            child: Text(
              product.barcode ?? "---",
              style: TxtStyle.tableRow,
              textAlign: TextAlign.center,
            ),
          ),

          // ====== 4. السعر ======
          Expanded(
            flex: 2,
            child: product.hasSizes
                ? Text(
              "من ${product.displayPrice.toStringAsFixed(2)} ج.م",
              style: TxtStyle.tableRowBold.copyWith(
                color: Colorsmanegments.primary,
              ),
              textAlign: TextAlign.center,
            )
                : Text(
              "${product.sellPrice} ج.م",
              style: TxtStyle.tableRow,
              textAlign: TextAlign.center,
            ),
          ),

          // ====== 5. الكمية ======
          Expanded(
            flex: 1,
            child: Text(
              "${product.quantity}",
              style: TxtStyle.tableRow,
              textAlign: TextAlign.center,
            ),
          ),

          // ====== 6. الإجراءات ======
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Iconss.edit,
                    size: 18,
                    color: Colorsmanegments.primary,
                  ),
                  onPressed: () {
                    final productCubit = context.read<ProductCubit>();
                    final state = productCubit.state;
                    final categories = (state is ProductSuccess)
                        ? state.categories
                        : <CategoryModel>[];

                    showDialog(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: productCubit,
                        child: AddProductDialog(
                          categories: categories,
                          productToEdit: product,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(

                    Iconss.delete,
                    size: 18,
                    color: Colorsmanegments.danger,
                  ),
                  onPressed: () {
                    context.read<ProductCubit>().deleteProduct(product.id!);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}