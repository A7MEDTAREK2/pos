// lib/feature/home/presentation/widgets/home_appbar.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/service/user_session.dart';
import '../../../../core/theming/theme_cubit.dart';
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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String currentUserName = UserSession.currentUser?.name ?? 'مستخدم النظام';
    final String currentUserRole = UserSession.currentUser?.role ?? 'كاشير';

    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
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
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  Text(
                    'نظام نقاط البيع',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color,
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
              color: colorScheme.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(_now),
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 16,
                  color: theme.dividerColor,
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(_now),
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // ====== زر تبديل الثيم ======
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.dividerColor),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme(!isDarkMode);
              },
              icon: Icon(
                isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                size: 22,
                color: isDarkMode ? Colors.amber : const Color(0xFF6B7280),
              ),
              tooltip: isDarkMode ? 'الوضع الفاتح' : 'الوضع الداكن',
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
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: widget.onNotificationsPressed ?? () {},
                  icon: Icon(
                    Icons.notifications_none,
                    size: 22,
                    color: theme.textTheme.bodySmall?.color,
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

          // ====== زر حساب المستخدم ======
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.dividerColor),
            ),
            child: PopupMenuButton<UserMenuAction>(
              padding: EdgeInsets.zero,
              offset: const Offset(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              icon: Icon(
                Icons.person_outline,
                size: 22,
                color: theme.textTheme.bodySmall?.color,
              ),
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
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUserName,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                      Text(
                        currentUserRole,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: UserMenuAction.switchAccount,
                  child: Row(
                    children: [
                      const Icon(Icons.switch_account, size: 20, color: Color(0xFF2563EB)),
                      const SizedBox(width: 8),
                      Text(
                        "تبديل الحساب",
                        style: GoogleFonts.cairo(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
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