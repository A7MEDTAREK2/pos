// lib/feature/home/presentation/widgets/home_appbar.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/service/user_session.dart';
import '../../../auth/login/presentation/screen/login_screen.dart';

class HomeAppBar extends StatefulWidget {
  final VoidCallback? onNotificationsPressed;
  final VoidCallback? onSettingsPressed;

  const HomeAppBar({
    super.key,
    this.onNotificationsPressed,
    this.onSettingsPressed,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // 🎯 تحديث الوقت والتاريخ كل ثانية لحظياً
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 🎯 إلغاء التايمر عند التدمير لمنع تسريب الذاكرة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 جلب بيانات المستخدم المسجل حالياً من الجلسة (UserSession)
    final String currentUserName = UserSession.currentUser?.name ?? 'مستخدم النظام';
    final String currentUserRole = UserSession.currentUser?.role ?? 'كاشير';

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

          // ====== التاريخ والوقت (يتحدث لحظياً) ======
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
                  _formatDate(_now),
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
                  _formatTime(_now),
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
                  onPressed: widget.onNotificationsPressed ?? () {},
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

          const SizedBox(width: 16),

          // ====== اسم المستخدم والقائمة ======
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
                child: Text("👤 حساب المستخدم"),
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
                  currentUserName, // 👈 الاسم الحقيقي ديناميكياً
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                Text(
                  currentUserRole, // 👈 الدور الحقيقي ديناميكياً
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
  // دوال مساعدة للتنسيق
  // ============================================================
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
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    final ampm = date.hour >= 12 ? 'م' : 'ص';
    return '$hour:$minute:$second $ampm';
  }
}

enum UserMenuAction {
  switchAccount,
}