// lib/feature/customer/presentation/widget/customer_list.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Customer ======
import '../../data/model/customer_model.dart';
import 'CustomerItem.dart';

class CustomerList extends StatelessWidget {
  final List<CustomerModel> customers;
  final Function(CustomerModel)? onCustomerTap;
  final CustomerModel? selectedCustomer;

  const CustomerList({
    super.key,
    required this.customers,
    this.onCustomerTap,
    this.selectedCustomer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (customers.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        final isSelected = selectedCustomer?.id == customer.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Tooltip(
            message: "Ctrl + ${index + 1} - ${customer.name}",
            waitDuration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              transform: Matrix4.identity()..scale(isSelected ? 1.02 : 1.0),
              child: Material(
                elevation: isSelected ? 5 : 3,
                borderRadius: BorderRadius.circular(14),
                color: isSelected
                    ? colorScheme.primary.withOpacity(0.08)
                    : colorScheme.surface,
                child: InkWell(
                  onTap: () {
                    if (onCustomerTap != null) {
                      onCustomerTap!(customer);
                    }
                  },
                  borderRadius: BorderRadius.circular(14),
                  splashColor: colorScheme.primary.withOpacity(0.1),
                  highlightColor: colorScheme.primary.withOpacity(0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: CustomerItem(
                      customer: customer,
                      onTap: () {
                        if (onCustomerTap != null) {
                          onCustomerTap!(customer);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconss.people,
            size: 80,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "لا يوجد عملاء",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "قم بإضافة عميل جديد",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 30),
          Tooltip(
            message: "Ctrl + N - إضافة عميل جديد",
            waitDuration: const Duration(milliseconds: 300),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {},
              icon: Icon(
                Iconss.add,
                color: colorScheme.onPrimary,
              ),
              label: Text(
                "إضافة عميل جديد",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}