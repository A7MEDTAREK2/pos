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
    return Dialog(
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
                  color: Colorsmanegments.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  isEditing ? 'تعديل مندوب' : 'إضافة مندوب جديد',
                  style: TxtStyle.titleMedium.copyWith(
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colorsmanegments.grey,
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
                    decoration: InputDecoration(
                      labelText: 'اسم المندوب *',
                      hintText: 'أدخل اسم المندوب',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: Colorsmanegments.grey,
                      ),
                    ),
                    style: TxtStyle.bodyMedium,
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
                    decoration: InputDecoration(
                      labelText: 'رقم الهاتف (اختياري)',
                      hintText: 'أدخل رقم الهاتف',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(
                        Icons.phone_rounded,
                        color: Colorsmanegments.grey,
                      ),
                    ),
                    style: TxtStyle.bodyMedium,
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
                    onPressed: _isLoading ? null : _saveDriver,
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      isEditing ? 'تحديث' : 'حفظ',
                      style: TxtStyle.buttonMedium,
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
        // ====== Update ======
        final updatedDriver = widget.driver.copyWith(
          name: name,
          phone: phone,
        );
        await cubit.updateDriver(updatedDriver);
      } else {
        // ====== Add ======
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: ${e.toString()}'),
          backgroundColor: Colorsmanegments.danger,
        ),
      );
    }
  }
}