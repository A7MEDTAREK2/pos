import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/purchase_product_model.dart';
import '../../logic/purchase_cubit.dart';

class PurchaseProductRow extends StatelessWidget {
  final PurchaseProductModel product;

  const PurchaseProductRow({
    super.key,
    required this.product,
  });

  // خريطة الوحدات لترجمتها داخل نافذة التعديل
  static const Map<String, String> _unitsMap = {
    'piece': 'قطعة',
    'kg': 'كيلو',
    'gram': 'جرام',
    'liter': 'لتر',
    'ml': 'مل',
    'box': 'كرتونة',
    'pack': 'عبوة',
  };

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<PurchaseCubit>(),
          child: _ProductEditDialog(
            productToEdit: product,
            unitsMap: _unitsMap,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () {
                context.read<PurchaseCubit>().addProduct(product);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'التكلفة: ${product.costPrice.toStringAsFixed(2)} ج.م',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          // زر تعديل الصنف
          IconButton(
            tooltip: 'تعديل الصنف',
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () => _showEditDialog(context),
          ),
          // زر إضافة الصنف للفاتورة
          IconButton(
            tooltip: 'إضافة للفاتورة',
            icon: Icon(Icons.add_circle_outline, color: colors.primary),
            onPressed: () {
              context.read<PurchaseCubit>().addProduct(product);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------- نافذة التعديل ----------------
class _ProductEditDialog extends StatefulWidget {
  final PurchaseProductModel productToEdit;
  final Map<String, String> unitsMap;

  const _ProductEditDialog({
    required this.productToEdit,
    required this.unitsMap,
  });

  @override
  State<_ProductEditDialog> createState() => _ProductEditDialogState();
}

class _ProductEditDialogState extends State<_ProductEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _costPriceController;
  late String _selectedUnit;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productToEdit.name);
    _barcodeController = TextEditingController(text: widget.productToEdit.barcode ?? '');
    _costPriceController = TextEditingController(
      text: widget.productToEdit.costPrice.toString(),
    );
    _selectedUnit = widget.productToEdit.unit;
    if (!widget.unitsMap.containsKey(_selectedUnit)) {
      _selectedUnit = 'piece';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _costPriceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final barcode = _barcodeController.text.trim();
      final costPrice = double.tryParse(_costPriceController.text) ?? 0.0;

      final updatedProduct = widget.productToEdit.copyWith(
        name: name,
        barcode: barcode.isEmpty ? null : barcode,
        unit: _selectedUnit,
        costPrice: costPrice,
      );

      context.read<PurchaseCubit>().updatePurchaseProduct(updatedProduct);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('تعديل صنف مشتريات'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الصنف *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(
                    labelText: 'الباركود (اختياري)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedUnit,
                  decoration: const InputDecoration(
                    labelText: 'الوحدة *',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.unitsMap.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedUnit = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _costPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'سعر التكلفة *',
                    border: OutlineInputBorder(),
                    suffixText: 'ج.م',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'هذا الحقل مطلوب';
                    if (double.tryParse(value) == null) return 'أدخل رقماً صحيحاً';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('حفظ التعديلات'),
          ),
        ],
      ),
    );
  }
}