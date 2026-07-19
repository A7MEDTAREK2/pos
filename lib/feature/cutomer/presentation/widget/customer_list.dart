import 'package:flutter/material.dart';
import '../../data/model/customer_model.dart';
import 'CustomerItem.dart';

class CustomerList extends StatelessWidget {
  // ====== متغيرات التحكم في الـ UI ======
  final Color primaryColor = Colors.blue;
  final Color cardColor = Colors.white;
  final Color emptyStateColor = Colors.grey;
  final double cardElevation = 3.0;
  final double cardBorderRadius = 14.0;
  final double itemSpacing = 12.0;
  final double emptyStateIconSize = 80.0;
  final double emptyStateFontSize = 18.0;
  final String emptyStateTitle = "لا يوجد عملاء";
  final String emptyStateSubtitle = "قم بإضافة عميل جديد";
  final String emptyStateIcon = "👤"; // أو استخدم Icons.person

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
    // ====== عرض رسالة إذا كانت القائمة فارغة ======
    if (customers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة أو إموجي
            Text(
              emptyStateIcon,
              style: TextStyle(
                fontSize: emptyStateIconSize,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              emptyStateTitle,
              style: TextStyle(
                fontSize: emptyStateFontSize,
                fontWeight: FontWeight.bold,
                color: emptyStateColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              emptyStateSubtitle,
              style: TextStyle(
                fontSize: emptyStateFontSize - 2,
                color: emptyStateColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 30),
            // زر إضافة عميل
            ElevatedButton.icon(
              onPressed: () {
                // يمكنك إضافة منطق الانتقال لشاشة الإضافة
                // Navigator.push(context, ...);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text("إضافة عميل جديد"),
            ),
          ],
        ),
      );
    }

    // ====== عرض القائمة ======
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: itemSpacing,
      ),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        final isSelected = selectedCustomer?.id == customer.id;

        return Padding(
          padding: EdgeInsets.only(bottom: itemSpacing),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()
              ..scale(isSelected ? 1.02 : 1.0),
            child: Material(
              elevation: isSelected ? cardElevation + 2 : cardElevation,
              borderRadius: BorderRadius.circular(cardBorderRadius),
              color: isSelected
                  ? primaryColor.withOpacity(0.08)
                  : cardColor,
              child: InkWell(
                onTap: () {
                  if (onCustomerTap != null) {
                    onCustomerTap!(customer);
                  }
                },
                borderRadius: BorderRadius.circular(cardBorderRadius),
                splashColor: primaryColor.withOpacity(0.1),
                highlightColor: primaryColor.withOpacity(0.05),
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
        );
      },
    );
  }
}