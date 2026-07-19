import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../logic/product_cubit.dart';
import '../../logic/product_state.dart';
import '../widget/product_table_row.dart';
import '../widget/add_product_dialog.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

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
            const SizedBox(height: 24),

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
                      return const Center(child: Text("لا توجد منتجات مضافة"));
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

  // تصميم رأس الجدول
  // تصميم رأس الجدول
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colorsmanegments.border, width: 2)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text("صورة", style: TextStyle(fontWeight: FontWeight.bold))), // أضفنا عمود الصورة
          Expanded(flex: 4, child: Text("المنتج", style: TextStyle(fontWeight: FontWeight.bold))), // زاد الـ flex عشان يتناسب مع الصف
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
              onPressed: () => Navigator.pop(context), // العودة للشاشة السابقة
            ),
            const SizedBox(width: 8),
            const Text("إدارة المنتجات", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),

        // زر إضافة منتج جديد
        ElevatedButton.icon(
          onPressed: () {
            // 1. خزن الـ Cubit في متغير عشان نستخدمه جوه الـ Dialog
            final productCubit = context.read<ProductCubit>();
            final state = productCubit.state;

            if (state is ProductSuccess) {
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value( // 2. استخدم .value للربط
                  value: productCubit, // 3. مرر الـ Cubit الحالي هنا
                  child: AddProductDialog(categories: state.categories),
                ),
              );
            }
          },
          icon: const Icon(Icons.add),
          label: const Text("إضافة منتج"),
        ),
      ],
    );
  }
}