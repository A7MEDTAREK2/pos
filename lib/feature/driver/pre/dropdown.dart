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
            decoration: InputDecoration(
              labelText: labelText ?? 'المندوب',
              hintText: hintText ?? 'اختر المندوب',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
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
                      const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey,
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
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
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
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'لا يوجد مندوبين، أضف مندوب أولاً',
              style: TextStyle(
                color: Colors.grey.shade600,
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
            child: const Text('إعادة تحميل'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.red.shade50,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
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
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}