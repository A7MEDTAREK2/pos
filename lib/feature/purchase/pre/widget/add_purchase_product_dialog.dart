import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/purchase_cubit.dart';
import '../../logic/purchase_state.dart';

class AddPurchaseProductDialog extends StatefulWidget {
  const AddPurchaseProductDialog({
    super.key,
  });

  @override
  State<AddPurchaseProductDialog> createState() =>
      _AddPurchaseProductDialogState();
}

class _AddPurchaseProductDialogState
    extends State<AddPurchaseProductDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _costPriceController = TextEditingController();

  String _unit = 'piece';

  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _costPriceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final cubit = context.read<PurchaseCubit>();

    final costPrice =
        double.tryParse(_costPriceController.text.trim()) ?? 0;

    await cubit.addPurchaseProduct(
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      unit: _unit,
      costPrice: costPrice,
    );

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    // لو الإضافة نجحت، الـ Cubit هيعمل PurchaseLoaded
    if (cubit.state is! PurchaseError) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.inventory_2_outlined),
            SizedBox(width: 10),
            Text('إضافة صنف مشتريات'),
          ],
        ),
        content: SizedBox(
          width: 450,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =========================
                // Product Name
                // =========================
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'اسم الصنف *',
                    hintText: 'مثال: مياه معدنية',
                    prefixIcon: Icon(
                      Icons.inventory_2_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'اسم الصنف مطلوب';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // =========================
                // Barcode
                // =========================
                TextFormField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(
                    labelText: 'الباركود',
                    hintText: 'اختياري',
                    prefixIcon: Icon(
                      Icons.qr_code_2_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =========================
                // Unit + Cost
                // =========================
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _unit,
                        decoration: const InputDecoration(
                          labelText: 'الوحدة',
                          prefixIcon: Icon(
                            Icons.straighten_outlined,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'piece',
                            child: Text('قطعة'),
                          ),
                          DropdownMenuItem(
                            value: 'kg',
                            child: Text('كيلو'),
                          ),
                          DropdownMenuItem(
                            value: 'gram',
                            child: Text('جرام'),
                          ),
                          DropdownMenuItem(
                            value: 'liter',
                            child: Text('لتر'),
                          ),
                          DropdownMenuItem(
                            value: 'box',
                            child: Text('كرتونة'),
                          ),
                          DropdownMenuItem(
                            value: 'pack',
                            child: Text('عبوة'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            _unit = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextFormField(
                        controller: _costPriceController,
                        keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'سعر التكلفة',
                          hintText: '0.00',
                          prefixIcon: Icon(
                            Icons.payments_outlined,
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'السعر مطلوب';
                          }

                          final price =
                          double.tryParse(value.trim());

                          if (price == null) {
                            return 'السعر غير صحيح';
                          }

                          if (price < 0) {
                            return 'السعر لا يمكن أن يكون سالبًا';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // =========================
                // Info
                // =========================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'الكمية ستبدأ من 0 وسيتم تحديثها تلقائيًا عند تسجيل فواتير الشراء.',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving
                ? null
                : () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(
              Icons.add,
            ),
            label: Text(
              _saving ? 'جاري الإضافة...' : 'إضافة الصنف',
            ),
          ),
        ],
      ),
    );
  }
}