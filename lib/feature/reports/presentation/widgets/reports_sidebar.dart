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
    return Container(
      width: 240,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: const Color(0xFFE5E7EB))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== Title ======
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'التقارير',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
          ),

          const Divider(height: 0, color: Color(0xFFE5E7EB)),

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

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
