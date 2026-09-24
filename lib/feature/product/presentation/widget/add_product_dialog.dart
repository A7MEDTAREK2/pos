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
import '../../logic/product_state.dart';

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
  final _minimumStockController = TextEditingController(); // ✅ 1. تعريف الـ Controller للحد الأدنى

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
      _minimumStockController.text = p.minimumStock.toString(); // ✅ 2. جلب قيمة الحد الأدنى عند التعديل
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
    _minimumStockController.dispose(); // ✅ 3. التخلص من الـ Controller لمنع التسريب
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
      minimumStock: double.tryParse(_minimumStockController.text) ?? 0, // ✅ 4. إرسال قيمة الحد الأدنى للمنتج
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
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
                color: colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconss.product,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.productToEdit == null
                        ? "إضافة منتج جديد"
                        : "تعديل المنتج",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Iconss.close,
                      color: colorScheme.onPrimary,
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
                      context,
                      controller: _nameController,
                      label: "اسم المنتج",
                      icon: Iconss.food,
                    ),
                    const SizedBox(height: 14),

                    _buildTextField(
                      context,
                      controller: _barcodeController,
                      label: "الباركود",
                      icon: Iconss.qrCode,
                    ),
                    const SizedBox(height: 14),

                    _buildCategoryDropdownBloc(context),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            context,
                            controller: _costController,
                            label: "سعر التكلفة",
                            icon: Iconss.sales,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            context,
                            controller: _quantityController,
                            label: "الكمية",
                            icon: Iconss.numbers,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ✅ 5. حقل الحد الأدنى للمخزون المرئي في الواجهة
                    _buildTextField(
                      context,
                      controller: _minimumStockController,
                      label: "الحد الأدنى للمخزون للتنبيه",
                      icon: Iconss.numbers, // يمكنك استبدال الأيقونة بأيقونة تنبيه إن وجدت
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),

                    // ================= سعر البيع =================
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: _hasSizes
                          ? const SizedBox.shrink()
                          : _buildTextField(
                        context,
                        controller: _sellController,
                        label: "سعر البيع",
                        icon: Iconss.sell,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    if (!_hasSizes) const SizedBox(height: 14),

                    _buildImagePicker(context),
                    const SizedBox(height: 20),

                    _buildSizesSection(context),
                  ],
                ),
              ),
            ),

            // ================= Footer =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme.dividerColor),
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
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: Text(
                        "إلغاء",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        widget.productToEdit == null ? "حفظ المنتج" : "تحديث",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
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
  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String label,
        required IconData icon,
        TextInputType? keyboardType,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.labelMedium,
        prefixIcon: Icon(icon, size: 20, color: colorScheme.primary),
        filled: true,
        fillColor: colorScheme.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Widget: Category Dropdown with BlocBuilder
  // ============================================================
  Widget _buildCategoryDropdownBloc(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        List<CategoryModel> categoriesList = widget.categories;
        if (state is ProductSuccess) {
          categoriesList = state.categories;
        }

        final uniqueCategories = categoriesList
            .fold<Map<int, CategoryModel>>({}, (map, cat) {
          if (cat.id != null) map[cat.id!] = cat;
          return map;
        })
            .values
            .toList();

        return DropdownButtonFormField<int>(
          value: _selectedCategoryId,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: "القسم",
            labelStyle: theme.textTheme.labelMedium,
            prefixIcon: Icon(
              Iconss.category,
              size: 20,
              color: colorScheme.primary,
            ),
            filled: true,
            fillColor: colorScheme.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
          items: uniqueCategories
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
      },
    );
  }

  // ============================================================
  // Widget: Image Picker
  // ============================================================
  Widget _buildImagePicker(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
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
                color: colorScheme.outlineVariant,
                child: Icon(
                  Iconss.image,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _imagePath == null ? "اختر صورة المنتج" : "تم اختيار الصورة",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _imagePath == null
                      ? theme.textTheme.bodyMedium?.color?.withOpacity(0.6)
                      : theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Icon(
              Iconss.arrowForward,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Widget: Sizes Section
  // ============================================================
  Widget _buildSizesSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconss.size,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "هل المنتج له أحجام مختلفة؟",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                value: _hasSizes,
                activeColor: colorScheme.primary,
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
                Divider(color: theme.dividerColor, height: 1),
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
                            style: theme.textTheme.bodySmall,
                            decoration: InputDecoration(
                              hintText: "اسم الحجم (صغير)",
                              hintStyle: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                              ),
                              isDense: true,
                              filled: true,
                              fillColor: colorScheme.surface,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: colorScheme.outlineVariant,
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
                            style: theme.textTheme.bodySmall,
                            decoration: InputDecoration(
                              hintText: "السعر",
                              hintStyle: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                              ),
                              isDense: true,
                              filled: true,
                              fillColor: colorScheme.surface,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: colorScheme.outlineVariant,
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
                            color: Colors.red,
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
                      color: colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconss.add,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "إضافة حجم",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
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