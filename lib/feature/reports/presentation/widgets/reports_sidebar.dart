// lib/feature/reports/presentation/widgets/reports_sidebar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

   ReportsSidebar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.analytics_outlined, 'title': 'تقرير المبيعات'},
    {'icon': Icons.inventory_2_outlined, 'title': 'تقرير المنتجات'},
    {'icon': Icons.people_outline, 'title': 'تقرير العملاء'},
    {'icon': Icons.warehouse_outlined, 'title': 'تقرير المخزون'},
    {'icon': Icons.payment_outlined, 'title': 'تقرير طرق الدفع'},
    {'icon': Icons.shopping_bag_outlined, 'title': 'تقرير أنواع الطلبات'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 240,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== Title ======
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'التقارير',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Divider(height: 0, color: theme.dividerColor),

          const SizedBox(height: 12),

          // ====== Categories ======
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final item = categories[index];
                final isSelected = selectedIndex == index;

                return _buildSidebarItem(
                  context,
                  icon: item['icon'],
                  title: item['title'],
                  isSelected: isSelected,
                  onTap: () {
                    onChanged(index);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}