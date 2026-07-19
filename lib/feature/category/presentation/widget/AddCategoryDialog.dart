// lib/feature/category/presentation/widget/add_category_dialog.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Category ======
import '../../logic/category_cubit.dart';

class AddCategoryDialog extends StatefulWidget {
  final CategoryCubit categoryCubit;

  const AddCategoryDialog({
    Key? key,
    required this.categoryCubit,
  }) : super(key: key);

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Iconss.category,
            color: Colorsmanegments.primary,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            "إضافة قسم جديد",
            style: TxtStyle.headerSmall,
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: TextFormField(
            controller: _nameController,
            autofocus: true,
            textAlign: TextAlign.right,
            style: TxtStyle.bodyMedium,
            decoration: InputDecoration(
              hintText: "اكتب اسم القسم (مثال: كريب، مشويات)",
              hintStyle: TxtStyle.hint,
              prefixIcon: Icon(
                Iconss.category,
                color: Colorsmanegments.primary.withOpacity(0.6),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colorsmanegments.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colorsmanegments.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colorsmanegments.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colorsmanegments.danger,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colorsmanegments.danger,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colorsmanegments.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "برجاء إدخال اسم القسم";
              }
              if (value.trim().length < 2) {
                return "اسم القسم يجب أن يكون على الأقل حرفين";
              }
              return null;
            },
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: Text(
            "إلغاء",
            style: TxtStyle.buttonPrimary,
          ),
        ),
        ElevatedButton(
          onPressed: _submitData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colorsmanegments.primary,
            foregroundColor: Colorsmanegments.textWhite,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconss.add,
                color: Colorsmanegments.textWhite,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "حفظ",
                style: TxtStyle.buttonMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final categoryName = _nameController.text.trim();
      widget.categoryCubit.addNewCategory(categoryName);
      Navigator.pop(context);
    }
  }
}