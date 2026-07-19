// lib/feature/cashier/presentation/widget/new_customer_dialog.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

class NewCustomerDialog extends StatefulWidget {
  final String phone;
  final Function(String name, String area, String address) onSave;

  const NewCustomerDialog({
    super.key,
    required this.phone,
    required this.onSave,
  });

  @override
  State<NewCustomerDialog> createState() => _NewCustomerDialogState();
}

class _NewCustomerDialogState extends State<NewCustomerDialog> {
  final nameController = TextEditingController();
  final areaController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Row(
        children: [
          Icon(
            Iconss.personAdd,
            color: Colorsmanegments.primary,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            "عميل جديد",
            style: TxtStyle.headerSmall,
          ),
        ],
      ),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====== رقم الهاتف (للقراءة فقط) ======
            TextField(
              enabled: false,
              style: TxtStyle.bodyMedium.copyWith(
                color: Colorsmanegments.textSecondary,
              ),
              decoration: InputDecoration(
                labelText: "رقم الهاتف",
                labelStyle: TxtStyle.labelMedium,
                prefixIcon: Icon(
                  Iconss.phone,
                  color: Colorsmanegments.textSecondary,
                  size: 20,
                ),
                hintText: widget.phone,
                hintStyle: TxtStyle.hint,
                filled: true,
                fillColor: Colorsmanegments.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colorsmanegments.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colorsmanegments.border),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ====== اسم العميل ======
            TextField(
              controller: nameController,
              style: TxtStyle.bodyMedium,
              decoration: InputDecoration(
                labelText: "اسم العميل",
                labelStyle: TxtStyle.labelMedium,
                prefixIcon: Icon(
                  Iconss.person,
                  color: Colorsmanegments.primary,
                  size: 20,
                ),
                filled: true,
                fillColor: Colorsmanegments.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colorsmanegments.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colorsmanegments.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ====== المنطقة ======
            TextField(
              controller: areaController,
              style: TxtStyle.bodyMedium,
              decoration: InputDecoration(
                labelText: "المنطقة",
                labelStyle: TxtStyle.labelMedium,
                prefixIcon: Icon(
                  Iconss.location,
                  color: Colorsmanegments.primary,
                  size: 20,
                ),
                filled: true,
                fillColor: Colorsmanegments.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colorsmanegments.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colorsmanegments.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ====== العنوان ======
            TextField(
              controller: addressController,
              style: TxtStyle.bodyMedium,
              decoration: InputDecoration(
                labelText: "العنوان",
                labelStyle: TxtStyle.labelMedium,
                prefixIcon: Icon(
                  Iconss.location,
                  color: Colorsmanegments.primary,
                  size: 20,
                ),
                filled: true,
                fillColor: Colorsmanegments.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colorsmanegments.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colorsmanegments.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "إلغاء",
            style: TxtStyle.buttonPrimary,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colorsmanegments.primary,
            foregroundColor: Colorsmanegments.textWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            widget.onSave(
              nameController.text,
              areaController.text,
              addressController.text,
            );
            Navigator.pop(context);
          },
          child: Text(
            "حفظ",
            style: TxtStyle.buttonMedium,
          ),
        ),
      ],
    );
  }
}