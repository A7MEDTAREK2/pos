import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  // ====== متغيرات التحكم في الـ UI ======
  final Color primaryColor = Colors.blue.shade700;
  final Color backgroundColor = Colors.grey.shade50;
  final double fabSize = 60.0;
  final double fabElevation = 6.0;
  final double fabIconSize = 30.0;
  final String emptyStateTitle = "لا يوجد عملاء";
  final String emptyStateSubtitle = "قم بإضافة عميل جديد";
  final String errorTitle = "حدث خطأ";
  final String retryButtonText = "إعادة المحاولة";

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

  // ====== عرض حالة التحميل ======
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 16),
          Text(
            "جاري تحميل العملاء...",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ====== عرض الحالة الفارغة ======
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 60,
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            emptyStateTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            emptyStateSubtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              _navigateToAddCustomer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 14,
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text(
              "إضافة عميل",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====== عرض حالة الخطأ ======
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            errorTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
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
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 14,
              ),
            ),
            icon: const Icon(Icons.refresh),
            label: Text(
              retryButtonText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====== التنقل لإضافة عميل ======
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
    }
  }

  // ====== التنقل لتعديل عميل ======
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
    }
  }

  // ====== عرض مربع حوار الحذف ======
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
                Icons.warning_amber_rounded,
                color: Colors.red.shade600,
                size: 28,
              ),
              const SizedBox(width: 10),
              const Text(
                "حذف العميل",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            "هل تريد حذف $customerName ؟",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
              ),
              child: const Text(
                "إلغاء",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "حذف",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
    return Scaffold(
      backgroundColor: backgroundColor,

      // ====== الـ AppBar الجديد ======
      appBar:  CustomerAppBar(
      ),

      // ====== زر الإضافة العائم ======
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCustomer,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: fabElevation,
        child: Icon(
          Icons.person_add,
          size: fabIconSize,
        ),
        shape: const CircleBorder(),
        tooltip: 'إضافة عميل',
      ),

      // ====== المحتوى ======
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ====== شريط البحث ======
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

            // ====== قائمة العملاء ======
            Expanded(
              child: BlocBuilder<CustomerCubit, CustomerState>(
                builder: (context, state) {
                  // حالة التحميل
                  if (state is CustomerLoading) {
                    return _buildLoadingState();
                  }

                  // حالة النجاح
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
                              context.read<CustomerCubit>().deleteCustomer(
                                customer.id!,
                              );
                            }
                          },
                        );
                      },
                    );
                  }

                  // حالة الخطأ
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