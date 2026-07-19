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
    return BlocBuilder<SaleDetailsCubit, SaleDetailsState>(
      builder: (context, state) {
        if (state is SaleDetailsLoading) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colorsmanegments.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'جاري تحميل البيانات...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colorsmanegments.textSecondary,
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
            decoration: const BoxDecoration(
              color: Colorsmanegments.background,
              borderRadius: BorderRadius.vertical(
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
                      color: Colorsmanegments.grey300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ====== 1. Header ======
                _buildHeader(sale),
                const SizedBox(height: 16),

                // ====== 2. بيانات العميل ======
                _buildCustomerInfo(sale),
                const SizedBox(height: 12),

                // ====== 3. نوع الطلب + طريقة الدفع + التاريخ ======
                _buildOrderInfo(sale),
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
                            color: Colorsmanegments.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'المنتجات',
                            style: TxtStyle.titleCard,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colorsmanegments.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${items.length} منتج',
                          style: TxtStyle.badgeSmall.copyWith(
                            color: Colorsmanegments.primary,
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
                _buildSummary(sale),
                const SizedBox(height: 12),
              ],
            ),
          );
        }

        if (state is SaleDetailsError) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
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
                    color: Colorsmanegments.danger.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TxtStyle.bodyMedium.copyWith(
                      color: Colorsmanegments.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colorsmanegments.primary,
                      foregroundColor: Colorsmanegments.textWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'إغلاق',
                      style: TxtStyle.buttonMedium,
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
  Widget _buildHeader(SalesHistoryModel sale) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colorsmanegments.border),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
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
                      color: Colorsmanegments.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Iconss.receipt,
                      color: Colorsmanegments.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'فاتورة #${sale.orderNumber}',
                    style: TxtStyle.headerSmall.copyWith(
                      color: Colorsmanegments.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 44),
                child: Text(
                  _formatDate(sale.createdAt),
                  style: TxtStyle.bodySmall,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colorsmanegments.success,
                  Colorsmanegments.success.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colorsmanegments.success.withOpacity(0.3),
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
                  style: TxtStyle.totalLarge.copyWith(
                    color: Colorsmanegments.textWhite,
                  ),
                ),
                Text(
                  'ج.م',
                  style: TxtStyle.labelSmall.copyWith(
                    color: Colorsmanegments.textWhite.withOpacity(0.7),
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
  Widget _buildCustomerInfo(SalesHistoryModel sale) {
    final isCashCustomer = sale.displayCustomerName.isEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colorsmanegments.border),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
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
                  ? Colorsmanegments.border
                  : Colorsmanegments.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCashCustomer ? Iconss.person : Iconss.person,
              color: isCashCustomer
                  ? Colorsmanegments.textSecondary
                  : Colorsmanegments.primary,
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
                  style: TxtStyle.titleSmall.copyWith(
                    color: isCashCustomer
                        ? Colorsmanegments.textSecondary
                        : Colorsmanegments.textPrimary,
                  ),
                ),
                if (!isCashCustomer && sale.customerPhone.isNotEmpty)
                  Text(
                    sale.customerPhone,
                    style: TxtStyle.bodySmall,
                  ),
              ],
            ),
          ),
          if (isCashCustomer)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colorsmanegments.border,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'نقدي',
                style: TxtStyle.badgeSmall.copyWith(
                  color: Colorsmanegments.textSecondary,
                ),
              ),
            ),
          if (!isCashCustomer && sale.customerPhone.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colorsmanegments.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Iconss.phone,
                size: 18,
                color: Colorsmanegments.success,
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // 3. نوع الطلب + طريقة الدفع + التاريخ
  // ============================================================
  Widget _buildOrderInfo(SalesHistoryModel sale) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colorsmanegments.border),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoChip(
            icon: _getOrderTypeIcon(sale.orderType),
            label: sale.orderTypeStringAr,
            color: _getOrderTypeColor(sale.orderType),
          ),
          Container(
            width: 1,
            height: 24,
            color: Colorsmanegments.border,
          ),
          _buildInfoChip(
            icon: _getPaymentMethodIcon(sale.paymentMethod),
            label: sale.paymentMethod,
            color: _getPaymentMethodColor(sale.paymentMethod),
          ),
          Container(
            width: 1,
            height: 24,
            color: Colorsmanegments.border,
          ),
          _buildInfoChip(
            icon: Iconss.calendar,
            label: DateFormat('dd MMM yyyy').format(sale.createdAt),
            color: Colorsmanegments.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
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
          style: TxtStyle.bodySmall.copyWith(
            color: Colorsmanegments.textSecondary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 4. ملخص الحساب
  // ============================================================
  Widget _buildSummary(SalesHistoryModel sale) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colorsmanegments.border),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'الإجمالي الفرعي',
            sale.subtotal,
            color: Colorsmanegments.textSecondary,
          ),
          _buildSummaryRow(
            'الخصم',
            sale.discount,
            isDiscount: true,
            color: Colorsmanegments.danger,
          ),
          _buildSummaryRow(
            'الضريبة',
            sale.tax,
            color: Colorsmanegments.primary,
          ),
          _buildSummaryRow(
            'رسوم التوصيل',
            sale.deliveryFee,
            color: Colorsmanegments.warning,
          ),
          const Divider(height: 24, thickness: 1.5),
          _buildSummaryRow(
            'الإجمالي',
            sale.total,
            isTotal: true,
            color: Colorsmanegments.success,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
      String label,
      double value, {
        bool isTotal = false,
        bool isDiscount = false,
        Color color = Colorsmanegments.textSecondary,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? TxtStyle.totalMedium
                : TxtStyle.bodyMedium.copyWith(
              color: Colorsmanegments.textSecondary,
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}${value.toStringAsFixed(2)} ج.م',
            style: isTotal
                ? TxtStyle.totalLarge.copyWith(color: color)
                : TxtStyle.bodyMedium.copyWith(
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
        return Colorsmanegments.warning;
      case 1:
        return Colorsmanegments.success;
      case 2:
        return Colorsmanegments.primary;
      default:
        return Colorsmanegments.grey;
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
        return Colorsmanegments.success;
      case 'card':
        return Colorsmanegments.primary;
      case 'visa':
        return Colorsmanegments.indigo;
      case 'mastercard':
        return Colorsmanegments.danger;
      case 'mada':
        return Colorsmanegments.warning;

      default:
        return Colorsmanegments.grey;
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

    // تنسيق الوقت بصيغة 12 ساعة مع AM/PM
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