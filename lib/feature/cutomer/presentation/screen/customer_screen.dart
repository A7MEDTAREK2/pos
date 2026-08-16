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
  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            "جاري تحميل العملاء...",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Empty State
  // ============================================================
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconss.people,
              size: 60,
              color: colorScheme.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "لا يوجد عملاء",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "قم بإضافة عميل جديد",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 30),
          Tooltip(
            message: "Ctrl + N - إضافة عميل",
            waitDuration: const Duration(milliseconds: 300),
            child: ElevatedButton.icon(
              onPressed: _navigateToAddCustomer,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              ),
              icon: Icon(
                Iconss.add,
                color: colorScheme.onPrimary,
              ),
              label: Text(
                "إضافة عميل",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Error State
  // ============================================================
  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconss.error,
              size: 50,
              color: Colors.red.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "حدث خطأ",
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 25),
          Tooltip(
            message: "Ctrl + R - إعادة المحاولة",
            waitDuration: const Duration(milliseconds: 300),
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<CustomerCubit>().loadCustomers();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              ),
              icon: Icon(
                Iconss.refresh,
                color: colorScheme.onPrimary,
              ),
              label: Text(
                "إعادة المحاولة",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
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

      try {
        context.read<HomeCubit>().refreshDashboard();
      } catch (_) {}
    }
  }

  // ============================================================
  // Delete Dialog
  // ============================================================
  Future<bool?> _showDeleteDialog(String customerName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Iconss.warning,
                color: Colors.red,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                "حذف العميل",
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          content: Text(
            "هل تريد حذف $customerName ؟",
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            Tooltip(
              message: "Esc - إلغاء",
              waitDuration: const Duration(milliseconds: 300),
              child: TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(
                  foregroundColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
                child: Text(
                  "إلغاء",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            Tooltip(
              message: "Enter - حذف",
              waitDuration: const Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "حذف",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,

      appBar: const CustomerAppBar(),

      floatingActionButton: Tooltip(
        message: "Ctrl + N - إضافة عميل",
        waitDuration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: _navigateToAddCustomer,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 6,
          child: Icon(
            Iconss.personAdd,
            size: 30,
          ),
          shape: const CircleBorder(),
          tooltip: 'إضافة عميل',
        ),
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
                    return _buildLoadingState(context);
                  }

                  if (state is CustomerSuccess) {
                    if (state.customers.isEmpty) {
                      return _buildEmptyState(context);
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
                    return _buildErrorState(context, state.error);
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