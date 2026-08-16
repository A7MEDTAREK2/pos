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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: BlocConsumer<CategoryCubit, CategoryState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state),
                const SizedBox(height: 32),
                Expanded(
                  child: _buildGridContent(context, state),
                ),
                Divider(color: theme.dividerColor, height: 40),
                _buildFooter(context, state),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Tooltip(
          message: "Esc - رجوع",
          waitDuration: const Duration(milliseconds: 300),
          child: IconButton(
            icon: Icon(
              Iconss.arrowBack,
              size: 28,
              color: theme.textTheme.bodyLarge?.color,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "إدارة المنتجات",
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "الأقسام",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
    final colorScheme = Theme.of(context).colorScheme;

    if (state is CategoryLoading) {
      return const Center(
        child: CircularProgressIndicator(),
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
        return _buildCategoryCard(context, categories[index], index);
      },
    );
  }

  // ============================================================
  // Category Card
  // ============================================================
  Widget _buildCategoryCard(BuildContext context, CategoryModel category, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Tooltip(
      message: "Ctrl + ${index + 1} - ${category.name}",
      waitDuration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.08),
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
                    color: colorScheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconss.restaurant,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Iconss.more,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
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
                            color: Colors.red,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'حذف',
                            style: TextStyle(color: Colors.red),
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
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Iconss.success,
                      size: 8,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "قسم مفعل",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Create New Card
  // ============================================================
  Widget _buildCreateNewCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Tooltip(
      message: "Ctrl + N - إضافة قسم جديد",
      waitDuration: const Duration(milliseconds: 300),
      child: InkWell(
        onTap: () => _openAddCategoryDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconss.addCircle,
                size: 40,
                color: colorScheme.primary.withOpacity(0.7),
              ),
              const SizedBox(height: 12),
              Text(
                "إضافة قسم",
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                "إنشاء تصنيف جديد",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Footer
  // ============================================================
  Widget _buildFooter(BuildContext context, CategoryState state) {
    final theme = Theme.of(context);
    int count = (state is CategorySuccess) ? state.categories.length : 0;
    return Row(
      children: [
        Text(
          "عرض $count أقسام مفعلة حالياً.",
          style: theme.textTheme.bodySmall,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'حذف القسم',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'هل أنت متأكد من حذف قسم "${category.name}" نهائياً؟',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          Tooltip(
            message: "Esc - إلغاء",
            waitDuration: const Duration(milliseconds: 300),
            child: TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'إلغاء',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          Tooltip(
            message: "Enter - حذف",
            waitDuration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<CategoryCubit>().deleteCategory(category.id!);
                Navigator.pop(dialogContext);
              },
              child: Text(
                'حذف',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openEditCategoryDialog(BuildContext context, CategoryModel category) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TextEditingController controller = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'تعديل اسم القسم',
          style: theme.textTheme.titleLarge,
        ),
        content: Tooltip(
          message: "Ctrl + E - تعديل الاسم",
          waitDuration: const Duration(milliseconds: 300),
          child: TextFormField(
            controller: controller,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'اسم القسم',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              filled: true,
              fillColor: colorScheme.background,
            ),
          ),
        ),
        actions: [
          Tooltip(
            message: "Esc - إلغاء",
            waitDuration: const Duration(milliseconds: 300),
            child: TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'إلغاء',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          Tooltip(
            message: "Enter - حفظ",
            waitDuration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              onPressed: () {
                context.read<CategoryCubit>().updateExistingCategory(
                  CategoryModel(id: category.id, name: controller.text),
                );
                Navigator.pop(dialogContext);
              },
              child: Text(
                'حفظ',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}