// lib/feature/category/presentation/screen/categories_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Category ======
import '../../data/model/category_model.dart';
import '../../logic/category_cubit.dart';
import '../../logic/category_state.dart';
import '../widget/AddCategoryDialog.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanegments.background,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: BlocConsumer<CategoryCubit, CategoryState>(
          listener: (context, state) {
            if (state is CategoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: TxtStyle.bodyMedium.copyWith(
                      color: Colorsmanegments.textWhite,
                    ),
                  ),
                  backgroundColor: Colorsmanegments.danger,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state),
                const SizedBox(height: 32),
                Expanded(
                  child: _buildGridContent(context, state),
                ),
                const Divider(height: 40),
                _buildFooter(state),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================
  Widget _buildHeader(BuildContext context, CategoryState state) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Iconss.arrowBack,
            size: 28,
            color: Colorsmanegments.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "إدارة المنتجات",
              style: TxtStyle.labelLarge.copyWith(
                color: Colorsmanegments.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "الأقسام",
              style: TxtStyle.headerMedium,
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // Grid Content
  // ============================================================
  Widget _buildGridContent(BuildContext context, CategoryState state) {
    if (state is CategoryLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colorsmanegments.primary,
        ),
      );
    }
    List<CategoryModel> categories = (state is CategorySuccess) ? state.categories : [];
    return GridView.builder(
      itemCount: categories.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (gridContext, index) {
        if (index == categories.length) return _buildCreateNewCard(context);
        return _buildCategoryCard(context, categories[index]);
      },
    );
  }

  // ============================================================
  // Category Card
  // ============================================================
  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colorsmanegments.border),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.blackOpacity10,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colorsmanegments.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconss.restaurant,
                  color: Colorsmanegments.textPrimary,
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Iconss.more,
                  color: Colorsmanegments.textSecondary,
                ),
                onSelected: (value) {
                  if (value == 'edit') _openEditCategoryDialog(context, category);
                  else if (value == 'delete') _showDeleteConfirmation(context, category);
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Iconss.edit, color: Colors.blue, size: 18),
                        SizedBox(width: 8),
                        Text('تعديل'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Iconss.delete,
                          color: Colorsmanegments.danger,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'حذف',
                          style: TxtStyle.danger,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: TxtStyle.titleSmall,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Iconss.success,
                    size: 8,
                    color: Colorsmanegments.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "قسم مفعل",
                    style: TxtStyle.bodySmall,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // ============================================================
  // Create New Card
  // ============================================================
  Widget _buildCreateNewCard(BuildContext context) {
    return InkWell(
      onTap: () => _openAddCategoryDialog(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colorsmanegments.card.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colorsmanegments.primary.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconss.addCircle,
              size: 40,
              color: Colorsmanegments.primary.withOpacity(0.7),
            ),
            const SizedBox(height: 12),
            Text(
              "إضافة قسم",
              style: TxtStyle.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              "إنشاء تصنيف جديد",
              style: TxtStyle.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Footer
  // ============================================================
  Widget _buildFooter(CategoryState state) {
    int count = (state is CategorySuccess) ? state.categories.length : 0;
    return Row(
      children: [
        Text(
          "عرض $count أقسام مفعلة حالياً.",
          style: TxtStyle.bodySmall,
        ),
      ],
    );
  }

  // ============================================================
  // Dialogs
  // ============================================================
  void _openAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddCategoryDialog(
        categoryCubit: context.read<CategoryCubit>(),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CategoryModel category) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'حذف القسم',
          style: TxtStyle.headerSmall,
        ),
        content: Text(
          'هل أنت متأكد من حذف قسم "${category.name}" نهائياً؟',
          style: TxtStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'إلغاء',
              style: TxtStyle.buttonPrimary,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorsmanegments.danger,
            ),
            onPressed: () {
              context.read<CategoryCubit>().deleteCategory(category.id!);
              Navigator.pop(dialogContext);
            },
            child: Text(
              'حذف',
              style: TxtStyle.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _openEditCategoryDialog(BuildContext context, CategoryModel category) {
    final TextEditingController controller = TextEditingController(text: category.name);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'تعديل اسم القسم',
          style: TxtStyle.headerSmall,
        ),
        content: TextFormField(
          controller: controller,
          style: TxtStyle.bodyMedium,
          decoration: InputDecoration(
            hintText: 'اسم القسم',
            hintStyle: TxtStyle.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colorsmanegments.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colorsmanegments.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'إلغاء',
              style: TxtStyle.buttonPrimary,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CategoryCubit>().updateExistingCategory(
                CategoryModel(id: category.id, name: controller.text),
              );
              Navigator.pop(dialogContext);
            },
            child: Text(
              'حفظ',
              style: TxtStyle.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }
}