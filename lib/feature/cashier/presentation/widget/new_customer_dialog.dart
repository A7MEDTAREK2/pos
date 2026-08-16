// lib/feature/cashier/presentation/widget/new_customer_dialog.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class NewCustomerDialog extends StatefulWidget {
  final String? initialPhone;
  final Function(String phone, String name, String area, String address) onSave;

  const NewCustomerDialog({
    super.key,
    this.initialPhone,
    required this.onSave,
  });

  @override
  State<NewCustomerDialog> createState() => _NewCustomerDialogState();
}

class _NewCustomerDialogState extends State<NewCustomerDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController phoneController;
  late final TextEditingController nameController;
  late final TextEditingController areaController;
  late final TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.initialPhone ?? '');
    nameController = TextEditingController();
    areaController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    areaController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSave(
      phoneController.text.trim(),
      nameController.text.trim(),
      areaController.text.trim(),
      addressController.text.trim(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Row(
        children: [
          Icon(
            Iconss.personAdd,
            color: colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            "عميل جديد",
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
      content: SizedBox(
        width: 350,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: "Ctrl + 1 - رقم الهاتف",
                  waitDuration: const Duration(milliseconds: 300),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "برجاء إدخال رقم الهاتف";
                      }
                      if (value.trim().length != 11) {
                        return "رقم الهاتف يجب أن يكون 11 رقماً بالضبط";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "رقم الهاتف",
                      labelStyle: theme.textTheme.labelMedium,
                      prefixIcon: Icon(
                        Iconss.phone,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: colorScheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Tooltip(
                  message: "Ctrl + 2 - اسم العميل",
                  waitDuration: const Duration(milliseconds: 300),
                  child: TextFormField(
                    controller: nameController,
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "برجاء إدخال اسم العميل";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "اسم العميل",
                      labelStyle: theme.textTheme.labelMedium,
                      prefixIcon: Icon(
                        Iconss.person,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: colorScheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Tooltip(
                  message: "Ctrl + 3 - المنطقة",
                  waitDuration: const Duration(milliseconds: 300),
                  child: TextFormField(
                    controller: areaController,
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "برجاء إدخال المنطقة";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "المنطقة",
                      labelStyle: theme.textTheme.labelMedium,
                      prefixIcon: Icon(
                        Iconss.location,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: colorScheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Tooltip(
                  message: "Ctrl + 4 - العنوان",
                  waitDuration: const Duration(milliseconds: 300),
                  child: TextFormField(
                    controller: addressController,
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "برجاء إدخال تفاصيل العنوان";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "العنوان",
                      labelStyle: theme.textTheme.labelMedium,
                      prefixIcon: Icon(
                        Iconss.location,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: colorScheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Tooltip(
          message: "Esc - إلغاء",
          waitDuration: const Duration(milliseconds: 300),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "إلغاء",
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        Tooltip(
          message: "Enter - حفظ",
          waitDuration: const Duration(milliseconds: 300),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _validateAndSave,
            child: Text(
              "حفظ",
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}