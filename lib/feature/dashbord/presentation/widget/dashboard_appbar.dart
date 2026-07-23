// lib/feature/dashboard/presentation/widgets/dashboard_appbar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class DashboardAppBar extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final String userName;
  final String userRole;

  const DashboardAppBar({
    super.key,
    this.onBackPressed,
    this.userName = 'أحمد محمد',
    this.userRole = 'مدير المتجر',
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        border: Border(
          bottom: BorderSide(color: Colorsmanegments.border),
        ),
      ),
      child: Row(
        children: [
          // ====== Logo ======
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/image/icons/logo.png",
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Text(
                'ModuPos',
                style: TxtStyle.headerMedium.copyWith(
                  color: Colorsmanegments.textPrimary,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ====== التاريخ والوقت ======
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colorsmanegments.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colorsmanegments.border),
            ),
            child: Row(
              children: [
                Icon(
                  Iconss.calendar,
                  size: 16,
                  color: Colorsmanegments.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_formatDate(now)} • ${_formatTime(now)}',
                  style: TxtStyle.bodySmall.copyWith(
                    color: Colorsmanegments.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ====== اسم المستخدم ======
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: TxtStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                userRole,
                style: TxtStyle.bodySmall.copyWith(
                  color: Colorsmanegments.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // ====== زر الرجوع ======
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onBackPressed ?? () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colorsmanegments.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colorsmanegments.border),
              ),
              child: Icon(
                Iconss.arrowForward,
                size: 18,
                color: Colorsmanegments.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final ampm = date.hour >= 12 ? 'م' : 'ص';
    return '$hour:$minute $ampm';
  }
}