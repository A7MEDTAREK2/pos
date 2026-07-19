import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../../category/logic/category_cubit.dart';
import '../../../category/logic/category_state.dart';
import '../../../product/logic/product_cubit.dart';

class PosCategoryBar extends StatelessWidget {
  const PosCategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is! CategorySuccess) {
            return const SizedBox();
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = state.categories[index];

              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  context.read<ProductCubit>().loadProducts(
                    filterCategoryId: category.id,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colorsmanegments.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colorsmanegments.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconss.restaurant,
                        color: Colorsmanegments.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category.name,
                        style: TxtStyle.labelBold,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}