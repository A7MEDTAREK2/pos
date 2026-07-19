// lib/feature/home/presentation/widgets/home_appbar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/service/user_session.dart';
import '../../../auth/login/presentation/screen/login_screen.dart';


class HomeAppBar extends StatelessWidget {
  final String userName;
  final String userRole;
  final VoidCallback? onNotificationsPressed;
  final VoidCallback? onSettingsPressed;

  const HomeAppBar({
    super.key,
    this.userName = 'أحمد محمد',
    this.userRole = 'مدير المتجر',
    this.onNotificationsPressed,
    this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
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
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ModuPOS',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  Text(
                    'نظام نقاط البيع',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // ====== التاريخ والوقت ======
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(now),
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 16,
                  color: const Color(0xFFE5E7EB),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(now),
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // ====== زر الإشعارات ======
          Stack(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onNotificationsPressed ?? () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    size: 22,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDC2626),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          // ====== زر الإعدادات ======


          const SizedBox(width: 16),

          // ====== صورة المستخدم ======



          const SizedBox(width: 12),

          // ====== اسم المستخدم ======
          PopupMenuButton<UserMenuAction>(
            onSelected: (value) {
              switch (value) {
                case UserMenuAction.switchAccount:
                  UserSession.logout();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                        (route) => false,
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text("👤 تبديل المستخدم"),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: UserMenuAction.switchAccount,
                child: Row(
                  children: [
                    Icon(Icons.switch_account),
                    SizedBox(width: 8),
                    Text("تبديل الحساب"),
                  ],
                ),
              ),

            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                Text(
                  userRole,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ============================================================
  // دوال مساعدة
  // ============================================================
  String _getInitials(String name) {
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}';
    }
    return name.isNotEmpty ? name[0] : 'م';
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
enum UserMenuAction {
  switchAccount,
}