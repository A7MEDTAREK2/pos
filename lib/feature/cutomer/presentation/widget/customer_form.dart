// lib/feature/customer/presentation/widget/customer_form.dart

import 'package:flutter/material.dart';
import 'package:path/path.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class CustomerForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController areaController;
  final TextEditingController notesController;

  // ====== FocusNodes للتنقل بالكيبورد ======
  final FocusNode? nameFocusNode;
  final FocusNode? phoneFocusNode;
  final FocusNode? addressFocusNode;
  final FocusNode? areaFocusNode;
  final FocusNode? notesFocusNode;

  const CustomerForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.areaController,
    required this.notesController,
    this.nameFocusNode,
    this.phoneFocusNode,
    this.addressFocusNode,
    this.areaFocusNode,
    this.notesFocusNode,
  });

  // ====== Widget مخصص للحقل ======
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    IconData? icon,
    bool isRequired = true,
    VoidCallback? onFieldSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Tooltip(
        message: _getFieldTooltip(label),
        waitDuration: const Duration(milliseconds: 300),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TxtStyle.bodyMedium,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context as BuildContext).requestFocus(nextFocusNode);
            } else {
              onFieldSubmitted?.call();
            }
          },
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TxtStyle.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            hintText: hint,
            hintStyle: TxtStyle.hint,
            prefixIcon: icon != null
                ? Icon(
              icon,
              color: Colorsmanegments.primary,
              size: 22,
            )
                : null,
            filled: true,
            fillColor: Colorsmanegments.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colorsmanegments.border,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colorsmanegments.border,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colorsmanegments.primary,
                width: 2.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colorsmanegments.danger,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colorsmanegments.danger,
                width: 2.5,
              ),
            ),
            errorStyle: TxtStyle.danger.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 12 : 0,
            ),
          ),
          validator: isRequired ? validator : null,
        ),
      ),
    );
  }

  String _getFieldTooltip(String label) {
    switch (label) {
      case "اسم العميل":
        return "Ctrl + 1 - اسم العميل";
      case "رقم الهاتف":
        return "Ctrl + 2 - رقم الهاتف";
      case "العنوان":
        return "Ctrl + 3 - العنوان";
      case "المنطقة":
        return "Ctrl + 4 - المنطقة";
      default:
        return label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ====== اسم العميل ======
        _buildField(
          controller: nameController,
          label: "اسم العميل",
          hint: "أدخل اسم العميل",
          icon: Iconss.person,
          focusNode: nameFocusNode ?? FocusNode(),
          nextFocusNode: phoneFocusNode,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "أدخل اسم العميل";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // ====== رقم الهاتف ======
        _buildField(
          controller: phoneController,
          label: "رقم الهاتف",
          hint: "أدخل رقم الهاتف",
          icon: Iconss.phone,
          focusNode: phoneFocusNode ?? FocusNode(),
          nextFocusNode: addressFocusNode,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "أدخل رقم الهاتف";
            }
            if (value.trim().length < 11) {
              return "رقم الهاتف يجب ألا يقل عن 11 رقماً";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // ====== العنوان ======
        _buildField(
          controller: addressController,
          label: "العنوان",
          hint: "أدخل العنوان",
          icon: Iconss.location,
          focusNode: addressFocusNode ?? FocusNode(),
          nextFocusNode: areaFocusNode,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "أدخل العنوان";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // ====== المنطقة ======
        _buildField(
          controller: areaController,
          label: "المنطقة",
          hint: "أدخل المنطقة",
          icon: Iconss.map,
          focusNode: areaFocusNode ?? FocusNode(),
          nextFocusNode: notesFocusNode,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "أدخل المنطقة";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}