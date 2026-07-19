// lib/feature/product/presentation/widget/add_product_dialog.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Category ======
import '../../../category/data/model/category_model.dart';

// ====== Product ======
import '../../data/model/product_model.dart';
import '../../logic/product_cubit.dart';

class AddProductDialog extends StatefulWidget {
  final List<CategoryModel> categories;
  final ProductModel? productToEdit;

  const AddProductDialog({
    super.key,
    required this.categories,
    this.productToEdit,
  });

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _SizeRow {
  final TextEditingController nameController;
  final TextEditingController priceController;

  _SizeRow({String name = '', String price = ''})
      : nameController = TextEditingController(text: name),
        priceController = TextEditingController(text: price);

  void dispose() {
    nameController.dispose();
    priceController.dispose();
  }
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _costController = TextEditingController();
  final _sellController = TextEditingController();
  final _quantityController = TextEditingController();

  int? _selectedCategoryId;
  String? _imagePath;

  bool _hasSizes = false;
  final List<_SizeRow> _sizeRows = [];

  @override
  void initState() {
    super.initState();

    if (widget.productToEdit != null) {
      final p = widget.productToEdit!;

      _nameController.text = p.name;
      _barcodeController.text = p.barcode ?? '';
      _costController.text = p.costPrice.toString();
      _sellController.text = p.sellPrice.toString();
      _quantityController.text = p.quantity.toString();
      _selectedCategoryId = p.categoryId;
      _imagePath = p.image;

      if (p.hasSizes) {
        _hasSizes = true;
        for (final size in p.sizes!) {
          _sizeRows.add(
            _SizeRow(
              name: size.sizeName,
              price: size.price.toString(),
            ),
          );
        }
      }
    }

    if (_sizeRows.isEmpty) {
      _sizeRows.add(_SizeRow());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _costController.dispose();
    _sellController.dispose();
    _quantityController.dispose();
    for (final row in _sizeRows) {
      row.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && mounted) {
        setState(() {
          _imagePath = result.files.single.path;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _addSizeRow() {
    setState(() {
      _sizeRows.add(_SizeRow());
    });
  }

  void _removeSizeRow(int index) {
    setState(() {
      _sizeRows[index].dispose();
      _sizeRows.removeAt(index);
      if (_sizeRows.isEmpty) {
        _sizeRows.add(_SizeRow());
      }
    });
  }

  List<ProductSize>? _buildSizesFromRows() {
    if (!_hasSizes) return null;

    final result = <ProductSize>[];

    for (final row in _sizeRows) {
      final name = row.nameController.text.trim();
      final price = double.tryParse(row.priceController.text.trim());

      if (name.isNotEmpty && price != null) {
        result.add(ProductSize(sizeName: name, price: price));
      }
    }

    return result.isEmpty ? null : result;
  }

  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty || _selectedCategoryId == null) {
      return;
    }

    final sizes = _buildSizesFromRows();

    final product = ProductModel(
      id: widget.productToEdit?.id,
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.trim(),
      categoryId: _selectedCategoryId!,
      costPrice: double.tryParse(_costController.text) ?? 0,
      sellPrice: double.tryParse(_sellController.text) ?? 0,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      image: _imagePath,
      createdAt:
      widget.productToEdit?.createdAt ?? DateTime.now().toIso8601String(),
      sizes: sizes,
    );

    if (widget.productToEdit == null) {
      await context.read<ProductCubit>().addProduct(product);
    } else {
      await context.read<ProductCubit>().updateExistingProduct(product);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uniqueCategories = widget.categories
        .fold<Map<int, CategoryModel>>({}, (map, cat) {
      if (cat.id != null) map[cat.id!] = cat;
      return map;
    })
        .values
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ================= Header =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colorsmanegments.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconss.product,
                    color: Colorsmanegments.textWhite,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.productToEdit == null
                        ? "إضافة منتج جديد"
                        : "تعديل المنتج",
                    style: TxtStyle.headerWhite.copyWith(fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Iconss.close,
                      color: Colorsmanegments.textWhite,
                    ),
                  ),
                ],
              ),
            ),

            // ================= Body =================
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: "اسم المنتج",
                      icon: Iconss.food,
                    ),
                    const SizedBox(height: 14),

                    _buildTextField(
                      controller: _barcodeController,
                      label: "الباركود",
                      icon: Iconss.qrCode,
                    ),
                    const SizedBox(height: 14),

                    _buildCategoryDropdown(uniqueCategories),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _costController,
                            label: "سعر التكلفة",
                            icon: Iconss.sales,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _quantityController,
                            label: "الكمية",
                            icon: Iconss.numbers,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ================= سعر البيع =================
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: _hasSizes
                          ? const SizedBox.shrink()
                          : _buildTextField(
                        controller: _sellController,
                        label: "سعر البيع",
                        icon: Iconss.sell,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    if (!_hasSizes) const SizedBox(height: 14),

                    _buildImagePicker(),
                    const SizedBox(height: 20),

                    _buildSizesSection(),
                  ],
                ),
              ),
            ),

            // ================= Footer =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colorsmanegments.border),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colorsmanegments.border),
                      ),
                      child: Text(
                        "إلغاء",
                        style: TxtStyle.buttonPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colorsmanegments.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        widget.productToEdit == null ? "حفظ المنتج" : "تحديث",
                        style: TxtStyle.buttonMedium,
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

  // ============================================================
  // Widget: TextField
  // ============================================================
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TxtStyle.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TxtStyle.labelMedium,
        prefixIcon: Icon(icon, size: 20, color: Colorsmanegments.primary),
        filled: true,
        fillColor: Colorsmanegments.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colorsmanegments.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colorsmanegments.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Widget: Category Dropdown
  // ============================================================
  Widget _buildCategoryDropdown(List<CategoryModel> categories) {
    return DropdownButtonFormField<int>(
      value: _selectedCategoryId,
      style: TxtStyle.bodyMedium,
      decoration: InputDecoration(
        labelText: "القسم",
        labelStyle: TxtStyle.labelMedium,
        prefixIcon: Icon(
          Iconss.category,
          size: 20,
          color: Colorsmanegments.primary,
        ),
        filled: true,
        fillColor: Colorsmanegments.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colorsmanegments.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colorsmanegments.primary,
            width: 1.5,
          ),
        ),
      ),
      items: categories
          .map(
            (category) => DropdownMenuItem<int>(
          value: category.id,
          child: Text(category.name),
        ),
      )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategoryId = value;
        });
      },
    );
  }

  // ============================================================
  // Widget: Image Picker
  // ============================================================
  Widget _buildImagePicker() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colorsmanegments.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colorsmanegments.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _imagePath != null
                  ? Image.file(
                File(_imagePath!),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 48,
                height: 48,
                color: Colorsmanegments.border,
                child: Icon(
                  Iconss.image,
                  color: Colorsmanegments.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _imagePath == null ? "اختر صورة المنتج" : "تم اختيار الصورة",
                style: TxtStyle.bodyMedium.copyWith(
                  color: _imagePath == null
                      ? Colorsmanegments.textSecondary
                      : Colorsmanegments.textPrimary,
                ),
              ),
            ),
            Icon(
              Iconss.arrowForward,
              color: Colorsmanegments.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Widget: Sizes Section
  // ============================================================
  Widget _buildSizesSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colorsmanegments.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colorsmanegments.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconss.size,
                size: 18,
                color: Colorsmanegments.primary,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "هل المنتج له أحجام مختلفة؟",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              Switch(
                value: _hasSizes,
                activeColor: Colorsmanegments.primary,
                onChanged: (value) {
                  setState(() {
                    _hasSizes = value;
                  });
                },
              ),
            ],
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: !_hasSizes
                ? const SizedBox.shrink()
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 12),

                ...List.generate(_sizeRows.length, (index) {
                  final row = _sizeRows[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: row.nameController,
                            style: TxtStyle.bodySmall,
                            decoration: InputDecoration(
                              hintText: "اسم الحجم (صغير)",
                              hintStyle: TxtStyle.hintSmall,
                              isDense: true,
                              filled: true,
                              fillColor: Colorsmanegments.card,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colorsmanegments.border,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: row.priceController,
                            keyboardType: TextInputType.number,
                            style: TxtStyle.bodySmall,
                            decoration: InputDecoration(
                              hintText: "السعر",
                              hintStyle: TxtStyle.hintSmall,
                              isDense: true,
                              filled: true,
                              fillColor: Colorsmanegments.card,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colorsmanegments.border,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Iconss.removeCircle,
                            color: Colorsmanegments.danger,
                            size: 20,
                          ),
                          onPressed: () => _removeSizeRow(index),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 4),

                InkWell(
                  onTap: _addSizeRow,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colorsmanegments.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconss.add,
                          size: 16,
                          color: Colorsmanegments.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "إضافة حجم",
                          style: TxtStyle.buttonPrimary.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}