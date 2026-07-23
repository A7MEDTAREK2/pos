// lib/feature/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ====== Core ======
import '../../core/theming/colors manegments.dart';
import '../../core/theming/txt_style.dart';

// ====== Auth ======
import '../auth/login/presentation/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
              Colorsmanegments.grey900,
              Colorsmanegments.textPrimary,
            ]
                : [
              const Color(0xFFE0F2FE),
              Colorsmanegments.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const SizedBox(height: 24),
              // ====== Logo ======
              Image.asset("assets/image/icons/logo1.png",width: 300,height: 200,),
              const SizedBox(height: 24),

              // ====== App Name ======
              Text(
                "ModuPOS",
                style: TxtStyle.headerLarge.copyWith(
                  fontSize: 42,
                  letterSpacing: 2,
                  color: isDark
                      ? Colorsmanegments.textWhite
                      : Colorsmanegments.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              // ====== Subtitle ======
              Text(
                "Smart Point of Sale",
                style: TxtStyle.bodyMedium.copyWith(
                  fontSize: 16,
                  color: isDark
                      ? Colorsmanegments.textWhite.withOpacity(0.7)
                      : Colorsmanegments.textSecondary,
                ),
              ),

              const SizedBox(height: 40),

              // ====== Loading Animation ======
              Lottie.asset(
                "assets/inmi/loading.json",
                width: 200,
                height: 200,
              ),

              const Spacer(flex: 2),

              // ====== Footer ======
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  "Developed by Ahmed Tarek",
                  style: TxtStyle.bodySmall.copyWith(
                    fontSize: 12,
                    color: isDark
                        ? Colorsmanegments.textWhite.withOpacity(0.3)
                        : Colorsmanegments.textSecondary.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}