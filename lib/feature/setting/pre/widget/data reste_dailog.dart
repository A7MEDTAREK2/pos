// lib/feature/settings/presentation/widgets/reset_data_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/data_mange/data_mange/cubit_mange.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class ResetDataDialog extends StatefulWidget {
  const ResetDataDialog({super.key});

  @override
  State<ResetDataDialog> createState() => _ResetDataDialogState();
}

class _ResetDataDialogState extends State<ResetDataDialog> {
  String selectedOption = 'بدء وردية جديدة';
  final TextEditingController confirmController = TextEditingController();

  bool get canExecute => confirmController.text.trim() == "DELETE";

  @override
  void dispose() {
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 650, // ✅ من 750 إلى 650
        constraints: const BoxConstraints(
          maxHeight: 560, // ✅ تحديد أقصى ارتفاع
        ),
        padding: const EdgeInsets.all(24), // ✅ تقليل الـ padding
        decoration: BoxDecoration(
          color: Colorsmanegments.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colorsmanegments.shadowDark,
              blurRadius: 40,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView( // ✅ جعل المحتوى قابل للتمرير
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ============================================================
              // HEADER
              // ============================================================
              _buildHeader(),

              const SizedBox(height: 8),

              // ============================================================
              // WARNING CARD
              // ============================================================
              _buildWarningCard(),

              const SizedBox(height: 12),

              // ============================================================
              // RESET OPTIONS
              // ============================================================
              _buildResetOptions(),

              const SizedBox(height: 16),

              // ============================================================
              // BACKUP CARD
              // ============================================================
              _buildBackupCard(),

              const SizedBox(height: 16),

              // ============================================================
              // CONFIRMATION
              // ============================================================
              _buildConfirmation(),

              const SizedBox(height: 16),

              // ============================================================
              // BOTTOM BUTTONS
              // ============================================================
              _buildBottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 48, // ✅ من 60 إلى 48
          height: 48, // ✅ من 60 إلى 48
          decoration: BoxDecoration(
            color: Colorsmanegments.danger.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Iconss.warning,
            size: 28, // ✅ من 36 إلى 28
            color: Colorsmanegments.danger,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'إعادة تهيئة البيانات',
          style: TxtStyle.headerMedium.copyWith(
            fontSize: 20, // ✅ من 24 إلى 20
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'هذه العملية قد تؤدي إلى حذف بيانات من النظام ولا يمكن التراجع عنها.',
          style: TxtStyle.bodySmall.copyWith(
            color: Colorsmanegments.textSecondary,
            fontSize: 12, // ✅ من 14 إلى 12
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ============================================================
  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colorsmanegments.danger.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colorsmanegments.danger.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Iconss.warning,
            size: 16,
            color: Colorsmanegments.danger,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'هام جداً',
                  style: TxtStyle.labelBold.copyWith(
                    color: Colorsmanegments.danger,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '• يفضل إنشاء نسخة احتياطية قبل التنفيذ.\n• لا تغلق البرنامج أثناء التنفيذ.',
                  style: TxtStyle.bodySmall.copyWith(
                    color: Colorsmanegments.textSecondary,
                    fontSize: 11,
                    height: 1.4,
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
  Widget _buildResetOptions() {
    final options = [
      {
        'icon': Iconss.restart,
        'title': 'بدء وردية جديدة',
        'description': 'إعادة تعيين عداد الطلبات فقط.',
      },
      {
        'icon': Iconss.deleteSales,
        'title': 'حذف جميع المبيعات',
        'description': 'حذف الفواتير مع الاحتفاظ بالمنتجات والعملاء.',
      },
      {
        'icon': Iconss.people,
        'title': 'حذف العملاء',
        'description': 'حذف جميع العملاء والعناوين فقط.',
      },
      {
        'icon': Iconss.deleteForever,
        'title': 'إعادة تهيئة كاملة',
        'description': 'حذف جميع البيانات والبدء من جديد.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر العملية',
          style: TxtStyle.labelBold,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colorsmanegments.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colorsmanegments.border,
              width: 1,
            ),
          ),
          child: Column(
            children: options.map((option) {
              final isFirst = options.indexOf(option) == 0;
              final isLast = options.indexOf(option) == options.length - 1;

              return Column(
                children: [
                  if (!isFirst) ...[
                    const Divider(height: 2, thickness: 0.5),
                  ],
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Row(
                      children: [
                        Icon(
                          option['icon'] as IconData,
                          size: 16,
                          color: Colorsmanegments.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          option['title'] as String,
                          style: TxtStyle.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      option['description'] as String,
                      style: TxtStyle.bodySmall.copyWith(
                        color: Colorsmanegments.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    value: option['title'] as String,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedOption = value;
                      });
                    },
                    activeColor: Colorsmanegments.primary,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ============================================================
  Widget _buildBackupCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colorsmanegments.primary.withOpacity(0.08),
            Colorsmanegments.primary.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colorsmanegments.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colorsmanegments.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Iconss.backup,
              size: 20,
              color: Colorsmanegments.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'يوصى بإنشاء نسخة احتياطية قبل التنفيذ.',
              style: TxtStyle.bodySmall.copyWith(
                color: Colorsmanegments.textPrimary,
                fontSize: 12,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorsmanegments.primary,
              foregroundColor: Colorsmanegments.textWhite,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () { context.read<MaintenanceCubit>().backupDatabase();},
            icon: Icon(
              Iconss.backup,
              size: 16,
              color: Colorsmanegments.textWhite,
            ),
            label: Text(
              'نسخ احتياطي',
              style: TxtStyle.buttonSmall.copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  Widget _buildConfirmation() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colorsmanegments.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colorsmanegments.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'للتأكيد اكتب:',
                style: TxtStyle.bodySmall.copyWith(
                  color: Colorsmanegments.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'DELETE',
                style: TxtStyle.labelBold.copyWith(
                  color: Colorsmanegments.danger,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: confirmController,
            onChanged: (_) {
              setState(() {});
            },
            textDirection: TextDirection.ltr,
            style: TxtStyle.bodySmall,
            decoration: InputDecoration(
              hintText: 'اكتب DELETE',
              hintStyle: TxtStyle.hintSmall,
              filled: true,
              fillColor: Colorsmanegments.card,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colorsmanegments.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colorsmanegments.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colorsmanegments.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(
                color: Colorsmanegments.border,
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TxtStyle.buttonPrimary.copyWith(fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: canExecute
                  ? Colorsmanegments.danger
                  : Colorsmanegments.danger.withOpacity(0.5),
              foregroundColor: Colorsmanegments.textWhite,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            onPressed: canExecute
                ? () {
              final cubit = context.read<MaintenanceCubit>();

              switch (selectedOption) {
                case 'بدء وردية جديدة':
                  cubit.restartShift();
                  break;

                case 'حذف جميع المبيعات':
                  cubit.deleteSales();
                  break;

                case 'حذف العملاء':
                  cubit.deleteCustomers();
                  break;

                case 'إعادة تهيئة كاملة':
                  cubit.deleteAllData();
                  break;
              }

              Navigator.pop(context);
            }
                : null,
            child: Text(
              'تنفيذ',
              style: TxtStyle.buttonLarge.copyWith(
                color: Colorsmanegments.textWhite,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}