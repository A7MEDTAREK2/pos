// lib/feature/customer/presentation/screen/customer_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Home (لعمل Refresh للداشبورد) ======
import '../../../home/logic/home_cubit.dart';

// ====== Customer ======
import '../../data/model/customer_model.dart';
import '../../logic/customer_cubit.dart';
import '../../logic/customer_state.dart';
import '../widget/CustomerItem.dart';
import '../widget/add_customer.dart';
import '../widget/customer_appbar.dart';
import '../widget/customer_search.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CustomerCubit>().loadCustomers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colorsmanegments.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "جاري تحميل العملاء...",
            style: TxtStyle.bodyMedium.copyWith(
              color: Colorsmanegments.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Empty State
  // ============================================================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colorsmanegments.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconss.people,
              size: 60,
              color: Colorsmanegments.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "لا يوجد عملاء",
            style: TxtStyle.emptyTitle.copyWith(
              color: Colorsmanegments.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "قم بإضافة عميل جديد",
            style: TxtStyle.emptySubtitle,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _navigateToAddCustomer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorsmanegments.primary,
              foregroundColor: Colorsmanegments.textWhite,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            ),
            icon: Icon(
              Iconss.add,
              color: Colorsmanegments.textWhite,
            ),
            label: Text(
              "إضافة عميل",
              style: TxtStyle.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Error State
  // ============================================================
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colorsmanegments.danger.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconss.error,
              size: 50,
              color: Colorsmanegments.danger.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "حدث خطأ",
            style: TxtStyle.headerSmall.copyWith(
              color: Colorsmanegments.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              error,
              style: TxtStyle.bodyMedium.copyWith(
                color: Colorsmanegments.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            onPressed: () {
              context.read<CustomerCubit>().loadCustomers();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorsmanegments.primary,
              foregroundColor: Colorsmanegments.textWhite,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            ),
            icon: Icon(
              Iconss.refresh,
              color: Colorsmanegments.textWhite,
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

  // ============================================================
  // Navigation
  // ============================================================
  Future<void> _navigateToAddCustomer() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CustomerCubit>(),
          child: const AddCustomerScreen(),
        ),
      ),
    );

    if (mounted) {
      context.read<CustomerCubit>().loadCustomers();

      // 🌟 تحديث الداشبورد فوراً بعد إضافة العميل
      try {
        context.read<HomeCubit>().refreshDashboard();
      } catch (_) {}
    }
  }

  Future<void> _navigateToEditCustomer(CustomerModel customer) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CustomerCubit>(),
          child: AddCustomerScreen(customer: customer),
        ),
      ),
    );

    if (mounted) {
      context.read<CustomerCubit>().loadCustomers();

      // 🌟 تحديث الداشبورد فوراً بعد تعديل العميل
      try {
        context.read<HomeCubit>().refreshDashboard();
      } catch (_) {}
    }
  }

  // ============================================================
  // Delete Dialog
  // ============================================================
  Future<bool?> _showDeleteDialog(String customerName) {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Iconss.warning,
                color: Colorsmanegments.danger,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                "حذف العميل",
                style: TxtStyle.headerSmall,
              ),
            ],
          ),
          content: Text(
            "هل تريد حذف $customerName ؟",
            style: TxtStyle.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                foregroundColor: Colorsmanegments.textSecondary,
              ),
              child: Text(
                "إلغاء",
                style: TxtStyle.buttonPrimary,
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colorsmanegments.danger,
                foregroundColor: Colorsmanegments.textWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "حذف",
                style: TxtStyle.buttonMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanegments.background,

      appBar: const CustomerAppBar(),

      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCustomer,
        backgroundColor: Colorsmanegments.primary,
        foregroundColor: Colorsmanegments.textWhite,
        elevation: 6,
        child: Icon(
          Iconss.personAdd,
          size: 30,
        ),
        shape: const CircleBorder(),
        tooltip: 'إضافة عميل',
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomerSearch(
              controller: searchController,
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  context.read<CustomerCubit>().loadCustomers();
                } else {
                  context.read<CustomerCubit>().searchCustomers(value);
                }
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: BlocBuilder<CustomerCubit, CustomerState>(
                builder: (context, state) {
                  if (state is CustomerLoading) {
                    return _buildLoadingState();
                  }

                  if (state is CustomerSuccess) {
                    if (state.customers.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: state.customers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, index) {
                        final customer = state.customers[index];

                        return CustomerItem(
                          customer: customer,
                          onTap: () {
                            context.read<CustomerCubit>().selectCustomer(customer);
                          },
                          onEdit: () => _navigateToEditCustomer(customer),
                          onDelete: () async {
                            final result = await _showDeleteDialog(customer.name);

                            if (result == true) {
                              await context.read<CustomerCubit>().deleteCustomer(
                                customer.id!,
                              );

                              // 🌟 تحديث الداشبورد أيضاً فور حذف العميل
                              if (mounted) {
                                try {
                                  context.read<HomeCubit>().refreshDashboard();
                                } catch (_) {}
                              }
                            }
                          },
                        );
                      },
                    );
                  }

                  if (state is CustomerError) {
                    return _buildErrorState(state.error);
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}