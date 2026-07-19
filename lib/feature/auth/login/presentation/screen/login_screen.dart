// lib/feature/auth/presentation/screen/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../../core/service/user_session.dart';
import '../../../../../core/theming/colors manegments.dart';
import '../../../../../core/theming/icons.dart';
import '../../../../../core/theming/txt_style.dart';
import '../../../../../core/widgets/app_botton.dart';
import '../../../../../core/widgets/txtfield.dart';

// ====== Home ======
import '../../../../home/presentation/screen/home_screen.dart';
import '../../../../home/data/data_source/local_data_source.dart';
import '../../../../home/data/repo/local_rapo.dart';
import '../../../../home/logic/home_cubit.dart';

// ====== Auth ======
import '../../../../setting/data/datasorce/UserLocalDataSource.dart';
import '../../../../setting/data/model/users_model.dart';
import '../../../../setting/data/repo/repo_user.dart';
import '../../data/data_source/local_data_source.dart';
import '../../data/repo/local_rapo.dart';
import '../../logic/auth_cubit.dart';
import '../../logic/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(
        AuthRepository(
          UserRepository(
            )

          ),
      ),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) =>
              const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is AuthSuccess) {
            Navigator.of(context).pop();
            UserSession.login(state.user);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(
                  user: state.user,
                ),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "مرحباً ${state.user.username}",
                  style: TxtStyle.bodyMedium.copyWith(
                    color: Colorsmanegments.textWhite,
                  ),
                ),
                backgroundColor: Colorsmanegments.success,
              ),
            );
          }

          if (state is AuthError) {
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TxtStyle.bodyMedium.copyWith(
                    color: Colorsmanegments.textWhite,
                  ),
                ),
                backgroundColor: Colorsmanegments.danger,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colorsmanegments.background,
          body: Center(
            child: Container(
              width: 820,
              height: 500,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colorsmanegments.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colorsmanegments.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colorsmanegments.blackOpacity10,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ====== Logo ======
                  Expanded(
                    child: Center(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Image.asset(
                          "assets/image/icons/logo.png",
                          width: 280,
                          height: 280,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                  // ====== Login Form ======
                  Expanded(
                    child: Builder(
                      builder: (blocContext) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "مرحباً بعودتك",
                              style: TxtStyle.headerMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "سجل الدخول للمتابعة",
                              style: TxtStyle.bodyMedium.copyWith(
                                color: Colorsmanegments.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 25),

                            // ====== Username Field ======
                            Txtfield(
                              hintText: "اسم المستخدم",
                              prefixIcon: Icon(
                                Iconss.person,
                                color: Colorsmanegments.primary,
                                size: 22,
                              ),
                              controller: username,
                              isPassword: false,
                            ),
                            const SizedBox(height: 12),

                            // ====== Password Field ======
                            Txtfield(
                              hintText: "كلمة المرور",
                              prefixIcon: Icon(
                                Iconss.lock,
                                color: Colorsmanegments.primary,
                                size: 22,
                              ),
                              controller: password,
                              isPassword: true,
                            ),
                            const SizedBox(height: 22),

                            // ====== Login Button ======
                            AppBotton(
                              width: double.infinity,
                              txt: "تسجيل الدخول",
                              onTap: () {
                                blocContext.read<AuthCubit>().login(
                                  username.text.trim(),
                                  password.text.trim(),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}