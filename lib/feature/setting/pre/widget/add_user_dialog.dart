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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 520,
        constraints: const BoxConstraints(
          maxHeight: 620, // ✅ تحديد أقصى ارتفاع
        ),
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
                    Iconss.personAdd,
                    color: Colorsmanegments.textWhite,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'إضافة مستخدم جديد',
                    style: TxtStyle.headerWhite.copyWith(fontSize: 20),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                // ✅ جعل المحتوى قابل للتمرير
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ====== Full Name ======
                    _buildTextField(
                      controller: nameController,
                      label: 'الاسم الكامل',
                      hint: 'أدخل الاسم الكامل',
                      icon: Iconss.person,
                    ),
                    const SizedBox(height: 14),

                    // ====== Username ======
                    _buildTextField(
                      controller: usernameController,
                      label: 'اسم المستخدم',
                      hint: 'أدخل اسم المستخدم',
                      icon: Iconss.person,
                    ),
                    const SizedBox(height: 14),

                    // ====== Password ======
                    _buildPasswordField(
                      controller : passwordController,
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

                    // ====== Confirm Password ======
                    _buildPasswordField(
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

                    // ====== Phone ======
                    _buildTextField(
                      controller: phoneController,
                      label: 'رقم الهاتف',
                      hint: 'أدخل رقم الهاتف',
                      icon: Iconss.phone,
                    ),
                    const SizedBox(height: 14),

                    // ====== Email ======
                    _buildTextField(
                      controller: emailController,
                      label: 'البريد الإلكتروني (اختياري)',
                      hint: 'أدخل البريد الإلكتروني',
                      icon: Iconss.email,
                    ),
                    const SizedBox(height: 14),

                    // ====== Role ======
                    _buildDropdown(
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

                    // ====== Status ======
                    _buildDropdown(
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
                    const SizedBox(height: 4), // ✅ مسافة صغيرة في النهاية
                  ],
                ),
              ),
            ),

            // ====== Footer ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colorsmanegments.border)),
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
                      child: Text('إلغاء', style: TxtStyle.buttonPrimary),
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
                      onPressed: () {
                        print("NAME => ${nameController.text}");
                        print("USERNAME => ${usernameController.text}");
                        print("PASSWORD => ${passwordController.text}");
                        print("PHONE => ${phoneController.text}");
                        print("EMAIL => ${emailController.text}");
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
                        print(user.toMap());

                        context.read<UserCubit>().addUser(user);

                        Navigator.pop(context);
                      },
                      child: Text('حفظ', style: TxtStyle.buttonMedium),
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon, required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TxtStyle.labelMedium),
        const SizedBox(height: 4),
        TextField(
          style: TxtStyle.bodyMedium,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TxtStyle.hint,
            prefixIcon: Icon(icon, color: Colorsmanegments.primary, size: 20),
            filled: true,
            fillColor: Colorsmanegments.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colorsmanegments.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colorsmanegments.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggle, required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TxtStyle.labelMedium),
        const SizedBox(height: 4),
        TextField(
          obscureText: obscure,
          style: TxtStyle.bodyMedium,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TxtStyle.hint,
            prefixIcon: Icon(icon, color: Colorsmanegments.primary, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Iconss.visibilityOff : Iconss.visibility,
                color: Colorsmanegments.textSecondary,
                size: 20,
              ),
              onPressed: onToggle,
            ),
            filled: true,
            fillColor: Colorsmanegments.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colorsmanegments.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colorsmanegments.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TxtStyle.labelMedium),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colorsmanegments.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colorsmanegments.border),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            style: TxtStyle.bodyMedium,

            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colorsmanegments.primary, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8, // ✅ تقليل الـ padding الرأسي
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
