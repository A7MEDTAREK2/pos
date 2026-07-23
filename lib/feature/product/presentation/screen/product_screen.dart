import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../logic/product_cubit.dart';
import '../../logic/product_state.dart';
import '../widget/product_table_row.dart';
import '../widget/add_product_dialog.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanegments.background,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            // الهيدر بيحتوي على زرار الرجوع والعنوان وزر الإضافة
            _buildHeader(context),
            const SizedBox(height: 20),

            // شريط البحث
            _buildSearchBar(context),
            const SizedBox(height: 20),

            // رأس الجدول لتوضيح البيانات
            _buildTableHeader(),

            // جسم الجدول بيتم تحديثه تلقائياً حسب حالة الـ Cubit
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  // حالة التحميل
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colorsmanegments.primary));
                  }
                  // حالة النجاح وعرض البيانات
                  else if (state is ProductSuccess) {
                    if (state.products.isEmpty) {
                      return const Center(child: Text("لا توجد منتجات مطابقة للبحث"));
                    }
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return ProductTableRow(product: state.products[index]);
                      },
                    );
                  }
                  // حالة الخطأ
                  else if (state is ProductError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colorsmanegments.red)));
                  }
                  return const Center(child: Text("جاري تحميل البيانات..."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تصميم شريط البحث (Search Bar)
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colorsmanegments.border),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          context.read<ProductCubit>().searchProducts(value);
        },
        decoration: InputDecoration(
          hintText: "ابحث باسم المنتج أو الباركود...",
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colorsmanegments.primary),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              searchController.clear();
              context.read<ProductCubit>().searchProducts('');
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // تصميم رأس الجدول
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colorsmanegments.border, width: 2)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text("صورة", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 4, child: Text("المنتج", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("الباركود", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("السعر", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text("الكمية", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text("إجراءات", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  // تصميم الهيدر مع زرار الرجوع
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // زرار الرجوع مع العنوان
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            const Text("إدارة المنتجات", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),

        // 🎯 زر إضافة منتج جديد (تم تصحيح طريقة فتح الديالوج ليعمل فوراً ويستقبل الأقسام)
        ElevatedButton.icon(
          onPressed: () {
            final productCubit = context.read<ProductCubit>();

            // استدعاء دالة التحديث في الخلفية للتأكد من جلب البيانات الجديدة
            productCubit.loadProducts();

            // فتح الديالوج فوراً وربطه بالـ Cubit لكي تظهر الأقسام بمجرد توفرها
            showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                value: productCubit,
                child: AddProductDialog(
                  categories: productCubit.state is ProductSuccess
                      ? (productCubit.state as ProductSuccess).categories
                      : [], // تمرير القائمة المتاحة حالياً وضمان عدم حدوث Crash
                ),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("إضافة منتج"),
        ),
      ],
    );
  }
}