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
  late bool canDiscount;
  late bool canDeleteInvoice;
  late bool canHoldOrders;

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
    canDiscount = user.canDiscount;
    canDeleteInvoice = user.canDeleteInvoice;
    canHoldOrders = user.canHoldOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 720,
        height: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====== Header ======
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                  Text(
                    'الصلاحيات - ${widget.user.name}',
                    style: TxtStyle.headerWhite.copyWith(fontSize: 20),
                  ),
                  const Spacer(),
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
                      children: [
                        _permissionItem(
                          title: 'إدارة المنتجات',
                          value: canManageProducts,
                          onChanged: (value) {
                            setState(() {
                              canManageProducts = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'الأقسام',
                      icon: Iconss.category,
                      children: [
                        _permissionItem(
                          title: 'إدارة الأقسام',
                          value: canManageCategories,
                          onChanged: (value) {
                            setState(() {
                              canManageCategories = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'العملاء',
                      icon: Iconss.customer,
                      children: [
                        _permissionItem(
                          title: 'إدارة العملاء',
                          value: canManageCustomers,
                          onChanged: (value) {
                            setState(() {
                              canManageCustomers = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'الموردين',
                      icon: Iconss.supplier,
                      children: [
                        _permissionItem(
                          title: 'إدارة الموردين',
                          value: canManageSuppliers,
                          onChanged: (value) {
                            setState(() {
                              canManageSuppliers = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'المخزون',
                      icon: Iconss.inventory,
                      children: [
                        _permissionItem(
                          title: 'إدارة المخزون',
                          value: canManageInventory,
                          onChanged: (value) {
                            setState(() {
                              canManageInventory = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'التقارير',
                      icon: Iconss.barChart,
                      children: [
                        _permissionItem(
                          title: 'إدارة التقارير',
                          value: canManageReports,
                          onChanged: (value) {
                            setState(() {
                              canManageReports = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'الإعدادات',
                      icon: Iconss.settings,
                      children: [
                        _permissionItem(
                          title: 'إدارة الإعدادات',
                          value: canManageSettings,
                          onChanged: (value) {
                            setState(() {
                              canManageSettings = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'المستخدمين',
                      icon: Iconss.users,
                      children: [
                        _permissionItem(
                          title: 'إدارة المستخدمين',
                          value: canManageUsers,
                          onChanged: (value) {
                            setState(() {
                              canManageUsers = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    _buildPermissionGroup(
                      title: 'نقطة البيع',
                      icon: Iconss.pos,
                      children: [
                        _permissionItem(
                          title: 'تطبيق الخصم',
                          value: canDiscount,
                          onChanged: (value) {
                            setState(() {
                              canDiscount = value!;
                            });
                          },
                        ),
                        _permissionItem(
                          title: 'حذف الفاتورة',
                          value: canDeleteInvoice,
                          onChanged: (value) {
                            setState(() {
                              canDeleteInvoice = value!;
                            });
                          },
                        ),
                        _permissionItem(
                          title: 'تعليق الطلبات',
                          value: canHoldOrders,
                          onChanged: (value) {
                            setState(() {
                              canHoldOrders = value!;
                            });
                          },
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
    required List<Widget> children,
  }) {
    return Container(
      width: 300,
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
              Text(
                title,
                style: TxtStyle.titleSmall.copyWith(
                  fontSize: 14,
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colorsmanegments.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Expanded(
            child: Text(
              title,
              style: TxtStyle.bodySmall,
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
      );
      print(updatedUser.toMap());
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