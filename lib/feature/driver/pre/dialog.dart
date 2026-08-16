import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../../core/theming/colors manegments.dart';

import '../data/model_drive.dart';
import '../logic/drive_cubit.dart';

class AddEditDriverDialog extends StatefulWidget {
  final dynamic driver;
  final VoidCallback onSaved;

  const AddEditDriverDialog({
    super.key,
    this.driver,
    required this.onSaved,
  });

  @override
  State<AddEditDriverDialog> createState() => _AddEditDriverDialogState();
}

class _AddEditDriverDialogState extends State<AddEditDriverDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  bool get isEditing => widget.driver != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.driver.name;
      _phoneController.text = widget.driver.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
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
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====== Header ======
            Row(
              children: [
                Icon(
                  isEditing ? Icons.edit_rounded : Icons.person_add_rounded,
                  color: colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  isEditing ? 'تعديل مندوب' : 'إضافة مندوب جديد',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ====== Form ======
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // ====== Name Field ======
                  TextFormField(
                    controller: _nameController,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'اسم المندوب *',
                      labelStyle: theme.textTheme.labelMedium,
                      hintText: 'أدخل اسم المندوب',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.primary, width: 2),
                      ),
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: colorScheme.background,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'اسم المندوب مطلوب';
                      }
                      if (value.trim().length < 2) {
                        return 'الاسم يجب أن يكون حرفين على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ====== Phone Field ======
                  TextFormField(
                    controller: _phoneController,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'رقم الهاتف (اختياري)',
                      labelStyle: theme.textTheme.labelMedium,
                      hintText: 'أدخل رقم الهاتف',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.primary, width: 2),
                      ),
                      prefixIcon: Icon(
                        Icons.phone_rounded,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: colorScheme.background,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length < 8) {
                          return 'رقم الهاتف يجب أن يكون 8 أرقام على الأقل';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ====== Actions ======
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: colorScheme.outlineVariant),
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
                    onPressed: _isLoading ? null : _saveDriver,
                    child: _isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                        : Text(
                      isEditing ? 'تحديث' : 'حفظ',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDriver() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final cubit = context.read<DriverCubit>();
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim();

      if (isEditing) {
        final updatedDriver = widget.driver.copyWith(
          name: name,
          phone: phone,
        );
        await cubit.updateDriver(updatedDriver);
      } else {
        final newDriver = DriverModel(
          name: name,
          phone: phone,
          isActive: true,
          createdAt: DateTime.now().toIso8601String(),
        );
        await cubit.addDriver(newDriver);
      }

      if (!mounted) return;

      widget.onSaved();
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // تم إزالة SnackBar
    }
  }
}