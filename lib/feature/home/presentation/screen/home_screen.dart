// lib/feature/home/presentation/screen/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Home ======
import '../../../setting/data/model/users_model.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import '../widget/MetricsGrid.dart';
import '../widget/appbab.dart';
import '../widget/quick_actions_grid.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return _buildLoadingState();
            }

            if (state is HomeError) {
              return _buildErrorState(state.message, context);
            }

            if (state is HomeSuccess) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🎯 تم إزالة userName لإلغاء الخطأ واستخدام البيانات الحية من الجلسة
                    const HomeAppBar(),
                    const SizedBox(height: 32),
                    // MetricsGrid(
                    //   todaySales: state.metrics.todaySales,
                    //   invoiceCount: state.metrics.invoiceCount,
                    //   totalProducts: state.metrics.totalProducts,
                    //   totalCustomers: state.metrics.totalCustomers,
                    // ),
                    const SizedBox(height: 32),
                    QuickActionsGrid(user: user),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // ============================================================
  // Loading State
  // ============================================================
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colorsmanegments.primary,
          ),
          const SizedBox(height: 16),
          Text(
            "جاري تحميل البيانات...",
            style: TxtStyle.bodyMedium.copyWith(
              color: Colorsmanegments.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Error State
  // ============================================================
  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconss.error,
            size: 64,
            color: Colorsmanegments.danger.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TxtStyle.danger.copyWith(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorsmanegments.primary,
              foregroundColor: Colorsmanegments.textWhite,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<HomeCubit>().loadDashboardData();
            },
            icon: Icon(
              Iconss.refresh,
              color: Colorsmanegments.textWhite,
              size: 18,
            ),
            label: Text(
              "إعادة المحاولة",
              style: TxtStyle.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }
}