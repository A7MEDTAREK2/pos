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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),

            _buildSearchBar(context),
            const SizedBox(height: 20),

            _buildTableHeader(context),

            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductSuccess) {
                    if (state.products.isEmpty) {
                      return Center(
                        child: Text(
                          "لا توجد منتجات مطابقة للبحث",
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return ProductTableRow(product: state.products[index]);
                      },
                    );
                  } else if (state is ProductError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      "جاري تحميل البيانات...",
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          context.read<ProductCubit>().searchProducts(value);
        },
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: "ابحث باسم المنتج أو الباركود...",
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.primary,
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
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

  Widget _buildTableHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "صورة",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "المنتج",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "الباركود",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "السعر",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "الكمية",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "إجراءات",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: theme.textTheme.bodyLarge?.color,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Text(
              "إدارة المنتجات",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        ElevatedButton.icon(
          onPressed: () {
            final productCubit = context.read<ProductCubit>();
            productCubit.loadProducts();

            showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                value: productCubit,
                child: AddProductDialog(
                  categories: productCubit.state is ProductSuccess
                      ? (productCubit.state as ProductSuccess).categories
                      : [],
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          icon: Icon(
            Icons.add,
            color: colorScheme.onPrimary,
          ),
          label: Text(
            "إضافة منتج",
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}