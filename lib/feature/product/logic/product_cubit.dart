import 'package:flutter_bloc/flutter_bloc.dart';

import '../../category/data/model/category_model.dart';
import '../../category/data/repo/local_rapo.dart';
import '../../home/logic/home_cubit.dart';
import '../data/model/product_model.dart';
import '../data/repo/local_rapo.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;
  final HomeCubit _homeCubit;

  ProductCubit(
      this._productRepository,
      this._categoryRepository,
      this._homeCubit,
      ) : super(ProductInitial());

  List<CategoryModel> _cachedCategories = [];
  List<ProductModel> _allProducts = [];

  Future<void> loadProducts({int? filterCategoryId}) async {
    emit(ProductLoading());

    try {
      _cachedCategories = await _categoryRepository.fetchAllCategories();

      List<ProductModel> products;

      if (filterCategoryId != null) {
        products = await _productRepository.fetchProductsByCategory(
          filterCategoryId,
        );
      } else {
        products = await _productRepository.fetchAllProducts();
      }

      _allProducts = products;

      emit(
        ProductSuccess(
          products: products,
          categories: _cachedCategories,
          selectedCategoryId: filterCategoryId,
        ),
      );
    } catch (e) {
      emit(ProductError("حدث خطأ أثناء تحميل البيانات: $e"));
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      final isSuccess = await _productRepository.addProduct(product);

      if (isSuccess) {
        final currentState = state;

        int? currentFilter;

        if (currentState is ProductSuccess) {
          currentFilter = currentState.selectedCategoryId;
        }

        await loadProducts(filterCategoryId: currentFilter);

        await _homeCubit.refreshDashboard();
      } else {
        emit(ProductError("فشل في إضافة المنتج"));
      }
    } catch (e) {
      emit(ProductError("خطأ أثناء الإضافة: $e"));
    }
  }

  Future<void> updateExistingProduct(ProductModel product) async {
    try {
      final isSuccess = await _productRepository.updateProduct(product);

      if (isSuccess) {
        final currentState = state;

        int? currentFilter;

        if (currentState is ProductSuccess) {
          currentFilter = currentState.selectedCategoryId;
        }

        await loadProducts(filterCategoryId: currentFilter);

        await _homeCubit.refreshDashboard();
      } else {
        emit(ProductError("فشل في تعديل المنتج"));
      }
    } catch (e) {
      emit(ProductError("خطأ أثناء التعديل: $e"));
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final isSuccess = await _productRepository.removeProduct(id);

      if (isSuccess) {
        final currentState = state;

        int? currentFilter;

        if (currentState is ProductSuccess) {
          currentFilter = currentState.selectedCategoryId;
        }

        await loadProducts(filterCategoryId: currentFilter);

        await _homeCubit.refreshDashboard();
      } else {
        emit(ProductError("فشل في حذف المنتج"));
      }
    } catch (e) {
      emit(ProductError("خطأ أثناء الحذف: $e"));
    }
  }
  void searchProducts(String query) {
    if (state is! ProductSuccess) return;

    final currentState = state as ProductSuccess;

    if (query.trim().isEmpty) {
      emit(
        ProductSuccess(
          products: _allProducts,
          categories: currentState.categories,
          selectedCategoryId: currentState.selectedCategoryId,
        ),
      );
      return;
    }

    final filtered = _allProducts.where((product) {
      return product.name.toLowerCase().contains(
        query.toLowerCase(),
      );
    }).toList();

    emit(
      ProductSuccess(
        products: filtered,
        categories: currentState.categories,
        selectedCategoryId: currentState.selectedCategoryId,
      ),
    );
  }
}