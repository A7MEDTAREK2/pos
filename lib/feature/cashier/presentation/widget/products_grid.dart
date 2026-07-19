import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../../product/data/model/product_model.dart';
import '../../../product/logic/product_cubit.dart';
import '../../../product/logic/product_state.dart';
import '../../logic/pos_cubit.dart';

class PosProductsGrid extends StatelessWidget {
  final Function(ProductModel) onProductTap;

  const PosProductsGrid({
    super.key,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<OrderCubit>();

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductSuccess) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.72,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];

              return _buildProductCard(context, cubit, product);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildProductCard(
      BuildContext context,
      OrderCubit orderCubit,
      ProductModel product,
      ) {
    return Material(
      color: Colorsmanegments.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => onProductTap(product),
        child: Ink(
          decoration: BoxDecoration(
            color: Colorsmanegments.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colorsmanegments.border),
            boxShadow: [
              BoxShadow(
                color: Colorsmanegments.blackOpacity10,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colorsmanegments.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: product.image != null && product.image!.isNotEmpty
                          ? Image.file(
                        File(product.image!),
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                      )
                          : Icon(
                        Iconss.food,
                        size: 70,
                        color: Colorsmanegments.blueGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TxtStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.hasSizes
                      ? "من ${product.displayPrice.toStringAsFixed(2)} ج.م"
                      : "${product.sellPrice ?? 0} ج.م",
                  style: TxtStyle.titleSmall.copyWith(
                    color: Colorsmanegments.primary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colorsmanegments.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => onProductTap(product),
                    icon: Icon(
                      Iconss.add,
                      color: Colorsmanegments.textWhite,
                      size: 18,
                    ),
                    label: Text(
                      "إضافة",
                      style: TxtStyle.buttonSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}