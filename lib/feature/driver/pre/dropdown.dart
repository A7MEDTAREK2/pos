import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/drive_cubit.dart';
import '../logic/drive_state.dart';

class DriverDropdown extends StatelessWidget {
  final String? selectedDriverName;
  final Function(String?) onDriverSelected;
  final String? hintText;
  final String? labelText;

  const DriverDropdown({
    super.key,
    required this.selectedDriverName,
    required this.onDriverSelected,
    this.hintText,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        if (state is DriverLoading) {
          return const SizedBox(
            height: 56,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (state is DriversLoaded) {
          final drivers = state.drivers;

          if (drivers.isEmpty) {
            return _buildEmptyState(context);
          }

          return DropdownButtonFormField<String>(
            value: selectedDriverName,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: labelText ?? 'المندوب',
              labelStyle: theme.textTheme.labelMedium,
              hintText: hintText ?? 'اختر المندوب',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              filled: true,
              fillColor: colorScheme.background,
            ),
            isExpanded: true,
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('بدون مندوب'),
              ),
              ...drivers.map((driver) {
                return DropdownMenuItem<String>(
                  value: driver.name,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          driver.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (driver.phone != null && driver.phone!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            driver.phone!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
            onChanged: onDriverSelected,
          );
        }

        if (state is DriverError) {
          return _buildErrorState(context, state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.amber,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'لا يوجد مندوبين، أضف مندوب أولاً',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 13,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<DriverCubit>().loadDrivers();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'إعادة تحميل',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.red.withOpacity(0.05),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<DriverCubit>().loadDrivers();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'إعادة المحاولة',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}