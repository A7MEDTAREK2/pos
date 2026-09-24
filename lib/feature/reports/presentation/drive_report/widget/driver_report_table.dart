import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../logic/report/driver_report_cubit.dart';
import '../../../logic/report/driver_report_state.dart';
import 'driver_table_header.dart';
import 'driver_table_row.dart';

class DriverReportTable extends StatelessWidget {
  const DriverReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<DriverReportCubit, DriverReportState>(
      builder: (context, state) {
        if (state is! DriverReportLoaded) {
          return const SizedBox();
        }

        final drivers = state.drivers;
        final cubit = context.read<DriverReportCubit>();

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
              const DriverTableHeader(),
              Container(
                height: 1,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: drivers.length,
                  separatorBuilder: (_, __) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return DriverTableRow(
                      index: index + 1,
                      driverName: driver.driverName,
                      totalOrders: driver.totalOrders,
                      totalDeliveryFees: driver.totalDeliveryFees,
                      isEven: index % 2 == 0,
                    );
                  },
                ),
              ),
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
                    Text(
                      'إجمالي النتائج: ${cubit.totalCount}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
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
                          isActive: cubit.page < cubit.totalPages - 1,
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