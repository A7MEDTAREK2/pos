// lib/feature/reports/product_report/presentation/widgets/stock_Report_Table.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home/feature/reports/presentation/product_report/widget/product_table_header.dart';
import '../../../logic/product_report_cubit.dart';
import '../../../logic/product_report_state.dart';
import '../widget/product_table_row.dart';

class ProductReportTable extends StatelessWidget {
  const ProductReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ProductReportCubit, ProductReportState>(
      builder: (context, state) {
        if (state is! ProductReportLoaded) {
          return const SizedBox();
        }

        final products = state.products;
        final cubit = context.read<ProductReportCubit>();

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // ====== Header ======
              const ProductTableHeader(),

              // ====== Divider ======
              Container(
                height: 1,
                color: colorScheme.outlineVariant,
              ),

              // ====== Rows ======
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductTableRow(
                      index: index + 1,
                      productName: product.productName,
                      salesCount: product.salesCount,
                      totalQuantity: product.totalQuantity,
                      totalRevenue: product.totalRevenue,
                      isEven: index % 2 == 0,
                    );
                  },
                ),
              ),

              // ====== Footer ======
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  border: Border(
                    top: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ====== Total Count ======
                    Text(
                      'إجمالي النتائج: ${cubit.totalCount}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),

                    // ====== Pagination ======
                    Row(
                      children: [
                        _buildPaginationButton(
                          context,
                          icon: Icons.chevron_left,
                          isActive: cubit.page > 0,
                          onPressed: cubit.previousPage,
                        ),
                        const SizedBox(width: 4),
                        _buildPaginationNumber(
                          context,
                          '${cubit.page + 1}',
                          true,
                        ),
                        _buildPaginationNumber(
                          context,
                          '${cubit.totalPages}',
                          false,
                        ),
                        const SizedBox(width: 4),
                        _buildPaginationButton(
                          context,
                          icon: Icons.chevron_right,
                          isActive: cubit.page < cubit.totalPages,
                          onPressed: cubit.nextPage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaginationButton(
      BuildContext context, {
        required IconData icon,
        required bool isActive,
        required VoidCallback onPressed,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: isActive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : colorScheme.background,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? null
              : Border.all(color: colorScheme.outlineVariant, width: 1),
        ),
        child: IconButton(
          onPressed: isActive ? onPressed : null,
          icon: Icon(
            icon,
            size: 18,
            color: isActive
                ? colorScheme.onPrimary
                : colorScheme.onSurface.withOpacity(0.4),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 20,
        ),
      ),
    );
  }

  Widget _buildPaginationNumber(
      BuildContext context,
      String number,
      bool isSelected,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? null
              : Border.all(color: Colors.transparent, width: 1),
        ),
        child: Center(
          child: Text(
            number,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}