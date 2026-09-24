import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/purchase_item_model.dart';
import '../../logic/purchase_cubit.dart';
import '../../logic/purchase_state.dart';
import '../widget/add_purchase_product_dialog.dart';
import '../widget/purchase_item.dart';
import '../widget/purchase_product_row.dart';
import '../widget/purchase_summary.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({
    super.key,
  });

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchaseCubit>().loadData();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('فاتورة شراء جديدة'),
        ),
        body: BlocConsumer<PurchaseCubit, PurchaseState>(
          listener: (context, state) {
            if (state is PurchaseSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تم حفظ فاتورة الشراء وتحديث المخزن بنجاح',
                  ),
                ),
              );

              Navigator.pop(context);
            }

            if (state is PurchaseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PurchaseLoading || state is PurchaseInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is PurchaseSaving) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is PurchaseLoaded) {
              return _buildContent(context, state);
            }

            if (state is PurchaseError) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<PurchaseCubit>().loadData();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      PurchaseLoaded state,
      ) {
    final cubit = context.read<PurchaseCubit>();
    final search = searchController.text.trim().toLowerCase();

    final products = state.purchaseProducts.where((product) {
      if (search.isEmpty) return true;

      return product.name.toLowerCase().contains(search) ||
          (product.barcode ?? '').toLowerCase().contains(search);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------- العمود الأيمن: قائمة المنتجات للبحث والإضافة -----------------
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, state),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'بحث عن منتج بالاسم أو الباركود',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          )
                              : null,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (_) {
                              return BlocProvider.value(
                                value: context.read<PurchaseCubit>(),
                                child: const AddPurchaseProductDialog(),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة صنف'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: products.isEmpty
                      ? const Center(
                    child: Text('لا توجد منتجات متطابقة'),
                  )
                      : ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return PurchaseProductRow(
                        product: products[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // ----------------- العمود الأيسر: الأصناف المضافة للفاتورة وملخص الشراء -----------------
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'أصناف الفاتورة المختارة',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${state.items.length} صنف',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // قائمة الأصناف المضافة
                Expanded(
                  child: state.items.isEmpty
                      ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'اضغط على المنتجات من القائمة المجاورة لإضافتها هنا',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return PurchaseItemWidget(
                        item: state.items[index],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // ملخص الإجمالي والخصم
                const PurchaseSummary(),

                const SizedBox(height: 12),

                // زر حفظ الفاتورة
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: state.items.isEmpty ||
                        state.selectedSupplierId == null
                        ? null
                        : () {
                      cubit.savePurchase();
                    },
                    icon: const Icon(
                      Icons.save_outlined,
                    ),
                    label: const Text(
                      'حفظ فاتورة الشراء',
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

  Widget _buildHeader(
      BuildContext context,
      PurchaseLoaded state,
      ) {
    final cubit = context.read<PurchaseCubit>();

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: state.selectedSupplierId,
            decoration: const InputDecoration(
              labelText: 'المورد',
              prefixIcon: Icon(
                Icons.local_shipping_outlined,
              ),
            ),
            items: state.suppliers.map((supplier) {
              final id = supplier['id'] as int;
              final name = supplier['name']?.toString() ?? '';

              return DropdownMenuItem<int>(
                value: id,
                child: Text(name),
              );
            }).toList(),
            onChanged: cubit.selectSupplier,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'الإجمالي: ${state.total.toStringAsFixed(2)} ج.م',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}