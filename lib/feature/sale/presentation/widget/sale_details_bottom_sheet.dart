// lib/feature/sale/presentation/widget/sale_details_bottom_sheet.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Sale ======
import '../../data/model/sale_model.dart';
import '../../data/repo/local_rapo.dart';
import '../../logic/sale_cubit.dart';
import '../../logic/sale_details_cubit.dart';
import '../../logic/sale_details_state.dart';
import '../../logic/sale_state.dart';
import 'sale_item_card.dart';

class SaleDetailsBottomSheet {
  const SaleDetailsBottomSheet._();

  static Future<void> show(
      BuildContext context,
      int saleId,
      ) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return BlocProvider(
          create: (_) => SaleDetailsCubit(
            repository: context.read<SalesHistoryCubit>().repository,
          )..loadDetails(saleId),
          child: const _SaleDetailsView(),
        );
      },
    );
  }
}

class _SaleDetailsView extends StatelessWidget {
  const _SaleDetailsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<SaleDetailsCubit, SaleDetailsState>(
      builder: (context, state) {
        if (state is SaleDetailsLoading) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'جاري تحميل البيانات...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is SaleDetailsSuccess) {
          final sale = state.sale;
          final items = state.items;

          return Container(
            height: MediaQuery.of(context).size.height * 0.92,
            decoration: BoxDecoration(
              color: colorScheme.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== مؤشر السحب ======
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ====== 1. Header ======
                _buildHeader(context, sale),
                const SizedBox(height: 16),

                // ====== 2. بيانات العميل ======
                _buildCustomerInfo(context, sale),
                const SizedBox(height: 12),

                // ====== 3. نوع الطلب + طريقة الدفع + التاريخ ======
                _buildOrderInfo(context, sale),
                const SizedBox(height: 16),

                // ====== 4. عنوان المنتجات ======
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Iconss.product,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'المنتجات',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${items.length} منتج',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ====== 5. قائمة المنتجات ======
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return SaleItemCard(item: item);
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // ====== 6. ملخص الحساب ======
                _buildSummary(context, sale),
                const SizedBox(height: 12),
              ],
            ),
          );
        }

        if (state is SaleDetailsError) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconss.error,
                    size: 60,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'إغلاق',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  // ============================================================
  // 1. Header
  // ============================================================
  Widget _buildHeader(BuildContext context, SalesHistoryModel sale) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Iconss.receipt,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'فاتورة #${sale.orderNumber}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 44),
                child: Text(
                  _formatDate(sale.createdAt),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.green.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${sale.total.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ج.م',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 2. بيانات العميل
  // ============================================================
  Widget _buildCustomerInfo(BuildContext context, SalesHistoryModel sale) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCashCustomer = sale.displayCustomerName.isEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCashCustomer
                  ? colorScheme.outlineVariant
                  : colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCashCustomer ? Iconss.person : Iconss.person,
              color: isCashCustomer
                  ? theme.textTheme.bodyMedium?.color?.withOpacity(0.5)
                  : colorScheme.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sale.displayCustomerName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isCashCustomer
                        ? theme.textTheme.bodyMedium?.color?.withOpacity(0.5)
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (!isCashCustomer && sale.customerPhone.isNotEmpty)
                  Text(
                    sale.customerPhone,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          if (isCashCustomer)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'نقدي',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (!isCashCustomer && sale.customerPhone.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Iconss.phone,
                size: 18,
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // 3. نوع الطلب + طريقة الدفع + التاريخ
  // ============================================================
  Widget _buildOrderInfo(BuildContext context, SalesHistoryModel sale) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoChip(
            context,
            icon: _getOrderTypeIcon(sale.orderType),
            label: sale.orderTypeStringAr,
            color: _getOrderTypeColor(sale.orderType),
          ),
          Container(
            width: 1,
            height: 24,
            color: theme.dividerColor,
          ),
          _buildInfoChip(
            context,
            icon: _getPaymentMethodIcon(sale.paymentMethod),
            label: sale.paymentMethod,
            color: _getPaymentMethodColor(sale.paymentMethod),
          ),
          Container(
            width: 1,
            height: 24,
            color: theme.dividerColor,
          ),
          _buildInfoChip(
            context,
            icon: Iconss.calendar,
            label: DateFormat('dd MMM yyyy').format(sale.createdAt),
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
      }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 4. ملخص الحساب
  // ============================================================
  Widget _buildSummary(BuildContext context, SalesHistoryModel sale) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            context,
            'الإجمالي الفرعي',
            sale.subtotal,
              color: colorScheme.onSurface.withOpacity(0.3)
          ),
          _buildSummaryRow(
            context,
            'الخصم',
            sale.discount,
            isDiscount: true,
            color: Colors.red,
          ),
          _buildSummaryRow(
            context,
            'الضريبة',
            sale.tax,
            color: colorScheme.primary,
          ),
          _buildSummaryRow(
            context,
            'رسوم التوصيل',
            sale.deliveryFee,
            color: Colors.amber,
          ),
          Divider(color: theme.dividerColor, height: 24, thickness: 1.5),
          _buildSummaryRow(
            context,
            'الإجمالي',
            sale.total,
            isTotal: true,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
      BuildContext context,
      String label,
      double value, {
        bool isTotal = false,
        bool isDiscount = false,
        Color color = Colors.grey,
      }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            )
                : theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}${value.toStringAsFixed(2)} ج.م',
            style: isTotal
                ? theme.textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            )
                : theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // دوال مساعدة
  // ============================================================
  Color _getOrderTypeColor(int type) {
    switch (type) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.green;
      case 2:
        return const Color(0xFF2563EB);
      default:
        return Colors.grey;
    }
  }

  IconData _getOrderTypeIcon(int type) {
    switch (type) {
      case 0:
        return Iconss.takeaway;
      case 1:
        return Iconss.dining;
      case 2:
        return Iconss.delivery;
      default:
        return Iconss.help;
    }
  }

  Color _getPaymentMethodColor(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Colors.green;
      case 'card':
        return const Color(0xFF2563EB);
      case 'visa':
        return const Color(0xFF4F46E5);
      case 'mastercard':
        return Colors.red;
      case 'mada':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Iconss.cash;
      case 'card':
        return Iconss.creditCard;
      case 'visa':
        return Iconss.creditCard;
      case 'mastercard':
        return Iconss.creditCard;
      case 'mada':
        return Iconss.creditCard;
      default:
        return Iconss.payment;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    final timeFormat = DateFormat('hh:mm a');

    if (difference.inDays == 0) {
      return 'اليوم • ${timeFormat.format(date)}';
    } else if (difference.inDays == 1) {
      return 'أمس • ${timeFormat.format(date)}';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام • ${timeFormat.format(date)}';
    } else {
      return '${DateFormat('dd MMM yyyy').format(date)} • ${timeFormat.format(date)}';
    }
  }
}