import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// الرجاء تعديل مسارات الاستيراد بناءً على هيكل مجلدات مشروعك الفعلي
import '../../logic/purchase_cubit.dart';
import '../../logic/purchase_state.dart';
import '../../data/model/purchase_product_model.dart';

class PurchaseProductsScreen extends StatefulWidget {
  const PurchaseProductsScreen({super.key});

  @override
  State<PurchaseProductsScreen> createState() => _PurchaseProductsScreenState();
}

class _PurchaseProductsScreenState extends State<PurchaseProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final Map<String, String> _unitsMap = {
    'piece': 'قطعة',
    'kg': 'كيلو',
    'gram': 'جرام',
    'liter': 'لتر',
    'ml': 'مل',
    'box': 'كرتونة',
    'pack': 'عبوة',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchaseCubit>().loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getUnitArabic(String unitCode) {
    return _unitsMap[unitCode] ?? unitCode;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أصناف المشتريات'),
          centerTitle: true,
        ),
        body: BlocBuilder<PurchaseCubit, PurchaseState>(
          builder: (context, state) {
            if (state is PurchaseLoading || state is PurchaseInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PurchaseError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<PurchaseCubit>().loadData(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is PurchaseLoaded) {
              final allProducts = state.purchaseProducts;

              final filteredProducts = allProducts.where((product) {
                if (_searchQuery.isEmpty) return true;
                final query = _searchQuery.toLowerCase();
                return product.name.toLowerCase().contains(query) ||
                    (product.barcode?.toLowerCase().contains(query) ?? false);
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'إدارة أصناف المشتريات',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'إجمالي الأصناف: ${allProducts.length}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showProductDialog(context: context),
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة صنف'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search Field
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'بحث باسم الصنف أو الباركود...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Products List
                    Expanded(
                      child: filteredProducts.isEmpty
                          ? const Center(
                        child: Text(
                          'لا توجد أصناف تطابق بحثك',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                          : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              product.name,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: product.isActive
                                                    ? Colors.green.withOpacity(0.1)
                                                    : Colors.red.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                product.isActive ? 'نشط' : 'غير نشط',
                                                style: TextStyle(
                                                  color: product.isActive ? Colors.green : Colors.red,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'الباركود: ${product.barcode?.isNotEmpty == true ? product.barcode : "لا يوجد"}',
                                          style: TextStyle(color: Colors.grey.shade700),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            _buildInfoChip(context, 'الوحدة: ${_getUnitArabic(product.unit)}'),
                                            const SizedBox(width: 8),
                                            _buildInfoChip(context, 'الكمية: ${product.quantity}'),
                                            const SizedBox(width: 8),
                                            _buildInfoChip(
                                              context,
                                              'التكلفة: ${product.costPrice.toStringAsFixed(2)} ج.م',
                                              isPrice: true,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        tooltip: 'تعديل',
                                        icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                        onPressed: () => _showProductDialog(
                                          context: context,
                                          productToEdit: product,
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'حذف',
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () => _showDeleteDialog(context, product),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String text, {bool isPrice = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPrice ? Colors.blue.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isPrice ? Colors.blue.shade200 : Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isPrice ? FontWeight.bold : FontWeight.normal,
          color: isPrice ? Colors.blue.shade700 : Colors.black87,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PurchaseProductModel product) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text('هل أنت متأكد من حذف الصنف "${product.name}"؟\nلا يمكن التراجع عن هذا الإجراء.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  if (product.id != null) {
                    context.read<PurchaseCubit>().deletePurchaseProduct(product.id!);
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('حذف', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProductDialog({
    required BuildContext context,
    PurchaseProductModel? productToEdit,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<PurchaseCubit>(),
          child: _ProductFormDialog(
            productToEdit: productToEdit,
            unitsMap: _unitsMap,
          ),
        );
      },
    );
  }
}

class _ProductFormDialog extends StatefulWidget {
  final PurchaseProductModel? productToEdit;
  final Map<String, String> unitsMap;

  const _ProductFormDialog({
    this.productToEdit,
    required this.unitsMap,
  });

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _costPriceController;
  late String _selectedUnit;

  bool get isEdit => widget.productToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productToEdit?.name ?? '');
    _barcodeController = TextEditingController(text: widget.productToEdit?.barcode ?? '');
    _costPriceController = TextEditingController(
      text: isEdit ? widget.productToEdit!.costPrice.toString() : '',
    );
    _selectedUnit = widget.productToEdit?.unit ?? 'piece';
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

      final cubit = context.read<PurchaseCubit>();

      if (isEdit) {
        final updatedProduct = widget.productToEdit!.copyWith(
          name: name,
          barcode: barcode.isEmpty ? null : barcode,
          unit: _selectedUnit,
          costPrice: costPrice,
        );
        cubit.updatePurchaseProduct(updatedProduct);
      } else {
        // الاستدلال بالتمرير المسمى (Named Parameters) بناءً على دالة الكيوبت الموجودة بالمشروع
        await cubit.addPurchaseProduct(
          name: name,
          barcode: barcode.isEmpty ? null : barcode,
          unit: _selectedUnit,
          costPrice: costPrice,
        );
      }

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
        title: Text(isEdit ? 'تعديل صنف' : 'إضافة صنف مشتريات جديد'),
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
            child: Text(isEdit ? 'حفظ التعديلات' : 'إضافة الصنف'),
          ),
        ],
      ),
    );
  }
}