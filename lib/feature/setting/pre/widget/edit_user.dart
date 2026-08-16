import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../data/model/users_model.dart';
import '../../logic/user_cubit.dart';

class EditUserDialog extends StatefulWidget {
  final UserModel user;

  const EditUserDialog({
    super.key,
    required this.user,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late String _selectedRole;
  late bool _isActive;
  bool _isSaving = false;

  final List<String> _roles = [
    'Admin',
    'Manager',
    'Cashier',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _usernameController = TextEditingController(text: widget.user.username);
    _passwordController = TextEditingController(text: widget.user.password);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
    _selectedRole = widget.user.role ?? 'cashier';
    _isActive = widget.user.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 500,
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
                    Iconss.edit,
                    color: colorScheme.onPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'تعديل المستخدم',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Iconss.close,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // ====== Body ======
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      enabled: widget.user.id != 1,
                      controller: _nameController,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: 'الاسم',
                        labelStyle: theme.textTheme.labelMedium,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.background,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الاسم مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      enabled: widget.user.id != 1,
                      controller: _usernameController,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: 'اسم المستخدم',
                        labelStyle: theme.textTheme.labelMedium,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.background,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'اسم المستخدم مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      enabled: widget.user.id != 1,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        labelStyle: theme.textTheme.labelMedium,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.background,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'كلمة المرور مطلوبة';
                        }
                        if (value.length < 4) {
                          return 'كلمة المرور يجب أن تكون 4 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      enabled: widget.user.id != 1,
                      controller: _phoneController,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        labelStyle: theme.textTheme.labelMedium,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.background,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      enabled: widget.user.id != 1,
                      controller: _emailController,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        labelStyle: theme.textTheme.labelMedium,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.background,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: 'الدور',
                        labelStyle: theme.textTheme.labelMedium,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: colorScheme.background,
                      ),
                      items: _roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: widget.user.id == 1
                          ? null
                          : (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Switch(
                          value: _isActive,
                          onChanged: widget.user.id == 1
                              ? null
                              : (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                          activeColor: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isActive ? 'نشط' : 'غير نشط',
                          style: theme.textTheme.bodyMedium,
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
                  top: BorderSide(color: theme.dividerColor),
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
                      onPressed: _isSaving ? null : _saveUser,
                      child: _isSaving
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                          : Text(
                        'حفظ التعديلات',
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

  void _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedUser = widget.user.copyWith(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        role: _selectedRole,
        isActive: _isActive,
      );

      await context.read<UserCubit>().updateUser(updatedUser);

      if (mounted) {
        // تم إزالة SnackBar
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        // تم إزالة SnackBar
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}