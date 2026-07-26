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
    if (customers.isEmpty) {
      return _buildEmptyState();
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
                    ? Colorsmanegments.primary.withOpacity(0.08)
                    : Colorsmanegments.card,
                child: InkWell(
                  onTap: () {
                    if (onCustomerTap != null) {
                      onCustomerTap!(customer);
                    }
                  },
                  borderRadius: BorderRadius.circular(14),
                  splashColor: Colorsmanegments.primary.withOpacity(0.1),
                  highlightColor: Colorsmanegments.primary.withOpacity(0.05),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconss.people,
            size: 80,
            color: Colorsmanegments.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "لا يوجد عملاء",
            style: TxtStyle.emptyTitle.copyWith(
              color: Colorsmanegments.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "قم بإضافة عميل جديد",
            style: TxtStyle.emptySubtitle,
          ),
          const SizedBox(height: 30),
          Tooltip(
            message: "Ctrl + N - إضافة عميل جديد",
            waitDuration: const Duration(milliseconds: 300),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colorsmanegments.primary,
                foregroundColor: Colorsmanegments.textWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {},
              icon: Icon(
                Iconss.add,
                color: Colorsmanegments.textWhite,
              ),
              label: Text(
                "إضافة عميل جديد",
                style: TxtStyle.buttonMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}