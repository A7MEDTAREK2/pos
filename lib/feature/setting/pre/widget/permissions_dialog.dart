// lib/feature/dashboard/presentation/widgets/permissions_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../data/model/users_model.dart';
import '../../logic/user_cubit.dart';

class PermissionsDialog extends StatefulWidget {
  final UserModel user;

  const PermissionsDialog({
    super.key,
    required this.user,
  });

  @override
  State<PermissionsDialog> createState() => _PermissionsDialogState();
}

class _PermissionsDialogState extends State<PermissionsDialog> {
  late bool canManageProducts;
  late bool canManageCategories;
  late bool canManageCustomers;
  late bool canManageSuppliers;
  late bool canManageInventory;
  late bool canManageReports;
  late bool canManageSettings;
  late bool canManageUsers;

  // صلاحيات نقطة البيع المفصلة والدقيقة
  late bool canSell;
  late bool canDiscount;
  late bool canDeleteInvoice;
  late bool canHoldOrders;
  late bool canPrintReceipt;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final user = widget.user;

    canManageProducts = user.canManageProducts;
    canManageCategories = user.canManageCategories;
    canManageCustomers = user.canManageCustomers;
    canManageSuppliers = user.canManageSuppliers;
    canManageInventory = user.canManageInventory;
    canManageReports = user.canManageReports;
    canManageSettings = user.canManageSettings;
    canManageUsers = user.canManageUsers;

    // قيم افتراضية أو مستخرجة من الموديل
    canSell = true; // افتراضياً أي مستخدم له صلاحية البيع الأساسية
    canDiscount = user.canDiscount;
    canDeleteInvoice = user.canDeleteInvoice;
    canHoldOrders = user.canHoldOrders;
    canPrintReceipt = true;
  }

  // دالة لتحديد أو إلغاء تحديد الكل
  void _toggleAll(bool value) {
    setState(() {
      canManageProducts = value;
      canManageCategories = value;
      canManageCustomers = value;
      canManageSuppliers = value;
      canManageInventory = value;
      canManageReports = value;
      canManageSettings = value;
      canManageUsers = value;
      canSell = value;
      canDiscount = value;
      canDeleteInvoice = value;
      canHoldOrders = value;
      canPrintReceipt = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool allSelected = canManageProducts &&
        canManageCategories &&
        canManageCustomers &&
        canManageSuppliers &&
        canManageInventory &&
        canManageReports &&
        canManageSettings &&
        canManageUsers &&
        canSell &&
        canDiscount &&
        canDeleteInvoice &&
        canHoldOrders &&
        canPrintReceipt;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 780,
        height: 650,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====== Header ======
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colorsmanegments.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconss.lock,
                    color: Colorsmanegments.textWhite,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'إدارة صلاحيات المستخدم: ${widget.user.name}',
                      style: TxtStyle.headerWhite.copyWith(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // زر تحديد/إلغاء تحديد الكل السريع
                  TextButton.icon(
                    onPressed: () => _toggleAll(!allSelected),
                    icon: Icon(
                      allSelected ? Icons.deselect : Icons.select_all,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      allSelected ? 'إلغاء الكل' : 'تحديد الكل',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Iconss.close,
                      color: Colorsmanegments.textWhite,
                    ),
                  ),
                ],
              ),
            ),

            // ====== Body ======
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildPermissionGroup(
                      title: 'المنتجات',
                      icon: Iconss.product,
                      isAllSelected: canManageProducts,
                      onToggleAll: (val) => setState(() => canManageProducts = val!),
                      children: [
                        _permissionItem(
                          title: 'إدارة المنتجات (إضافة/تعديل/حذف)',
                          value: canManageProducts,
                          onChanged: (val) => setState(() => canManageProducts = val!),
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'الأقسام',
                      icon: Iconss.category,
                      isAllSelected: canManageCategories,
                      onToggleAll: (val) => setState(() => canManageCategories = val!),
                      children: [
                        _permissionItem(
                          title: 'إدارة أقسام المنتجات',
                          value: canManageCategories,
                          onChanged: (val) => setState(() => canManageCategories = val!),
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'العملاء',
                      icon: Iconss.customer,
                      isAllSelected: canManageCustomers,
                      onToggleAll: (val) => setState(() => canManageCustomers = val!),
                      children: [
                        _permissionItem(
                          title: 'إدارة بيانات العملاء والديون',
                          value: canManageCustomers,
                          onChanged: (val) => setState(() => canManageCustomers = val!),
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'الموردين',
                      icon: Iconss.supplier,
                      isAllSelected: canManageSuppliers,
                      onToggleAll: (val) => setState(() => canManageSuppliers = val!),
                      children: [
                        _permissionItem(
                          title: 'إدارة الموردين وحساباتهم',
                          value: canManageSuppliers,
                          onChanged: (val) => setState(() => canManageSuppliers = val!),
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'المخزون',
                      icon: Iconss.inventory,
                      isAllSelected: canManageInventory,
                      onToggleAll: (val) => setState(() => canManageInventory = val!),
                      children: [
                        _permissionItem(
                          title: 'مراقبة وتعديل المخزون والتسويات',
                          value: canManageInventory,
                          onChanged: (val) => setState(() => canManageInventory = val!),
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'التقارير',
                      icon: Iconss.barChart,
                      isAllSelected: canManageReports,
                      onToggleAll: (val) => setState(() => canManageReports = val!),
                      children: [
                        _permissionItem(
                          title: 'عرض التقارير المالية والأرباح',
                          value: canManageReports,
                          onChanged: (val) => setState(() => canManageReports = val!),
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'الإعدادات',
                      icon: Iconss.settings,
                      isAllSelected: canManageSettings,
                      onToggleAll: (val) => setState(() => canManageSettings = val!),
                      children: [
                        _permissionItem(
                          title: 'تعديل إعدادات النظام والطابعة',
                          value: canManageSettings,
                          onChanged: (val) => setState(() => canManageSettings = val!),
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'المستخدمين',
                      icon: Iconss.users,
                      isAllSelected: canManageUsers,
                      onToggleAll: (val) => setState(() => canManageUsers = val!),
                      children: [
                        _permissionItem(
                          title: 'إدارة المستخدمين وصلاحياتهم',
                          value: canManageUsers,
                          onChanged: (val) => setState(() => canManageUsers = val!),
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'نقطة البيع (POS)',
                      icon: Iconss.pos,
                      isAllSelected: canSell && canDiscount && canDeleteInvoice && canHoldOrders && canPrintReceipt,
                      onToggleAll: (val) {
                        setState(() {
                          canSell = val!;
                          canDiscount = val;
                          canDeleteInvoice = val;
                          canHoldOrders = val;
                          canPrintReceipt = val;
                        });
                      },
                      children: [
                        _permissionItem(
                          title: 'إتمام عمليات البيع',
                          value: canSell,
                          onChanged: (val) => setState(() => canSell = val!),
                        ),
                        _permissionItem(
                          title: 'تطبيق الخصومات على الفاتورة',
                          value: canDiscount,
                          onChanged: (val) => setState(() => canDiscount = val!),
                        ),
                        _permissionItem(
                          title: 'حذف أو إلغاء الفواتير',
                          value: canDeleteInvoice,
                          onChanged: (val) => setState(() => canDeleteInvoice = val!),
                        ),
                        _permissionItem(
                          title: 'تعليق واسترجاع الطلبات',
                          value: canHoldOrders,
                          onChanged: (val) => setState(() => canHoldOrders = val!),
                        ),
                        _permissionItem(
                          title: 'إعادة طباعة الفواتير',
                          value: canPrintReceipt,
                          onChanged: (val) => setState(() => canPrintReceipt = val!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ====== Footer ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colorsmanegments.border),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: TxtStyle.buttonPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colorsmanegments.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isSaving ? null : _savePermissions,
                      child: _isSaving
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        'حفظ الصلاحيات',
                        style: TxtStyle.buttonMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionGroup({
    required String title,
    required IconData icon,
    required bool isAllSelected,
    required ValueChanged<bool?> onToggleAll,
    required List<Widget> children,
  }) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colorsmanegments.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colorsmanegments.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TxtStyle.titleSmall.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // زر اختيار القسم بالكامل مصغر
              SizedBox(
                height: 24,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'الكل',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    Checkbox(
                      value: isAllSelected,
                      onChanged: onToggleAll,
                      activeColor: Colorsmanegments.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _permissionItem({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colorsmanegments.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              style: TxtStyle.bodySmall.copyWith(fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }

  void _savePermissions() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final updatedUser = widget.user.copyWith(
        canManageProducts: canManageProducts,
        canManageCategories: canManageCategories,
        canManageCustomers: canManageCustomers,
        canManageSuppliers: canManageSuppliers,
        canManageInventory: canManageInventory,
        canManageReports: canManageReports,
        canManageSettings: canManageSettings,
        canManageUsers: canManageUsers,
        canDiscount: canDiscount,
        canDeleteInvoice: canDeleteInvoice,
        canHoldOrders: canHoldOrders,
        // يمكنك إضافة الحقول الإضافية في موديل المستخدم إذا أردت لاحقاً مثل canSell و canPrintReceipt
      );

      await context.read<UserCubit>().updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ الصلاحيات بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}