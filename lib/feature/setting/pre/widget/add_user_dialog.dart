// lib/feature/settings/presentation/widgets/add_user_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../data/model/users_model.dart';
import '../../logic/user_cubit.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _selectedRole = 'Cashier';
  String? _selectedStatus = 'Active';
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final confirmpass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 520,
        constraints: const BoxConstraints(
          maxHeight: 620,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====== Header ======
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconss.personAdd,
                    color: colorScheme.onPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'إضافة مستخدم جديد',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Iconss.close,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // ====== Body ======
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTextField(
                      context,
                      controller: nameController,
                      label: 'الاسم الكامل',
                      hint: 'أدخل الاسم الكامل',
                      icon: Iconss.person,
                    ),
                    const SizedBox(height: 14),

                    _buildTextField(
                      context,
                      controller: usernameController,
                      label: 'اسم المستخدم',
                      hint: 'أدخل اسم المستخدم',
                      icon: Iconss.person,
                    ),
                    const SizedBox(height: 14),

                    _buildPasswordField(
                      context,
                      controller: passwordController,
                      label: 'كلمة المرور',
                      hint: 'أدخل كلمة المرور',
                      icon: Iconss.lock,
                      obscure: _obscurePassword,
                      onToggle: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildPasswordField(
                      context,
                      controller: confirmpass,
                      label: 'تأكيد كلمة المرور',
                      hint: 'أعد كتابة كلمة المرور',
                      icon: Iconss.lock,
                      obscure: _obscureConfirm,
                      onToggle: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildTextField(
                      context,
                      controller: phoneController,
                      label: 'رقم الهاتف',
                      hint: 'أدخل رقم الهاتف',
                      icon: Iconss.phone,
                    ),
                    const SizedBox(height: 14),

                    _buildTextField(
                      context,
                      controller: emailController,
                      label: 'البريد الإلكتروني (اختياري)',
                      hint: 'أدخل البريد الإلكتروني',
                      icon: Iconss.email,
                    ),
                    const SizedBox(height: 14),

                    _buildDropdown(
                      context,
                      label: 'الدور',
                      value: _selectedRole!,
                      items: ['Admin', 'Manager', 'Cashier'],
                      icon: Iconss.role,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildDropdown(
                      context,
                      label: 'الحالة',
                      value: _selectedStatus!,
                      items: ['Active', 'Inactive'],
                      icon: Iconss.status,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),

            // ====== Footer ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: theme.dividerColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        final user = UserModel(
                          name: nameController.text.trim(),
                          username: usernameController.text.trim(),
                          password: passwordController.text.trim(),
                          phone: phoneController.text.trim(),
                          email: emailController.text.trim(),
                          role: _selectedRole!,
                          isActive: _selectedStatus == "Active",
                          canManageProducts: true,
                          canManageCategories: true,
                          canManageCustomers: true,
                          canManageSuppliers: true,
                          canManageInventory: true,
                          canManageReports: true,
                          canManageSettings: true,
                          canManageUsers: true,
                          canDiscount: true,
                          canDeleteInvoice: true,
                          canHoldOrders: true,
                        );

                        context.read<UserCubit>().addUser(user);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'حفظ',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildTextField(
      BuildContext context, {
        required String label,
        required String hint,
        required IconData icon,
        required TextEditingController controller,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        TextField(
          style: theme.textTheme.bodyMedium,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            prefixIcon: Icon(icon, color: colorScheme.primary, size: 20),
            filled: true,
            fillColor: colorScheme.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
      BuildContext context, {
        required String label,
        required String hint,
        required IconData icon,
        required bool obscure,
        required VoidCallback onToggle,
        required TextEditingController controller,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        TextField(
          obscureText: obscure,
          style: theme.textTheme.bodyMedium,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            prefixIcon: Icon(icon, color: colorScheme.primary, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Iconss.visibilityOff : Iconss.visibility,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                size: 20,
              ),
              onPressed: onToggle,
            ),
            filled: true,
            fillColor: colorScheme.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      BuildContext context, {
        required String label,
        required String value,
        required List<String> items,
        required IconData icon,
        required ValueChanged<String> onChanged,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: colorScheme.primary, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: (value) => onChanged(value!),
          ),
        ),
      ],
    );
  }
}