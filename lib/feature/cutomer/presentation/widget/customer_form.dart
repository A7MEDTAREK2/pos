import 'package:flutter/material.dart';

class CustomerForm extends StatelessWidget {
  // ====== متغيرات التحكم في الـ UI ======
  final Color primaryColor = Colors.blue.shade700;
  final Color focusColor = Colors.blue.shade100;
  final Color errorColor = Colors.red.shade700;
  final Color labelColor = Colors.grey.shade700;
  final Color textColor = Colors.grey.shade900;
  final double fieldBorderRadius = 12.0;
  final double fieldElevation = 2.0;
  final double fontSizeLabel = 14.0;
  final double fontSizeText = 16.0;
  final double fieldHeight = 55.0;
  final double fieldPadding = 4.0;
  final String nameLabel = "اسم العميل";
  final String phoneLabel = "رقم الهاتف";
  final String addressLabel = "العنوان";
  final String areaLabel = "المنطقة";
  final String notesLabel = "ملاحظات";
  final String nameHint = "أدخل اسم العميل";
  final String phoneHint = "أدخل رقم الهاتف";
  final String addressHint = "أدخل العنوان";
  final String areaHint = "أدخل المنطقة";
  final String notesHint = "أضف ملاحظات (اختياري)";
  final String nameError = "أدخل اسم العميل";
  final String phoneError = "أدخل رقم الهاتف";
  final String addressError = "أدخل العنوان";
  final String areaError = "أدخل المنطقة";

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController areaController;
  final TextEditingController notesController;

   CustomerForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.areaController,
    required this.notesController,
  });

  // ====== Widget مخصص للحقل ======
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    IconData? icon,
    bool isRequired = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(fieldBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: fontSizeText,
          color: textColor,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: fontSizeLabel,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: fontSizeText,
            color: Colors.grey.shade400,
          ),
          prefixIcon: icon != null
              ? Icon(
            icon,
            color: primaryColor,
            size: 22,
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldBorderRadius),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldBorderRadius),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldBorderRadius),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldBorderRadius),
            borderSide: BorderSide(
              color: errorColor,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldBorderRadius),
            borderSide: BorderSide(
              color: errorColor,
              width: 2.5,
            ),
          ),
          errorStyle: TextStyle(
            color: errorColor,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ====== اسم العميل ======
        _buildField(
          controller: nameController,
          label: nameLabel,
          hint: nameHint,
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return nameError;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // ====== رقم الهاتف ======
        _buildField(
          controller: phoneController,
          label: phoneLabel,
          hint: phoneHint,
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return phoneError;
            }
            // التحقق من صحة رقم الهاتف (10 أرقام على الأقل)
            if (value.trim().length < 10) {
              return "رقم الهاتف يجب أن يكون 10 أرقام على الأقل";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // ====== العنوان ======


        // ====== ملاحظات ======
        _buildField(
          controller: notesController,
          label: notesLabel,
          hint: notesHint,
          icon: Icons.note,
          maxLines: 4,
          isRequired: false,
          validator: (value) => null, // اختياري
        ),
      ],
    );
  }
}