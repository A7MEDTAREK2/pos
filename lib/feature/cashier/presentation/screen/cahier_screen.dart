import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data_base/pos_database.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../driver/data/localdata.dart';
import '../../../driver/data/repo.dart';
import '../../../driver/logic/drive_cubit.dart';
import '../../../product/logic/product_cubit.dart';
// تأكد من استيراد الـ HomeCubit هنا حسب مسار المشروع عندك
import '../../../home/logic/home_cubit.dart';
import '../../logic/pos_cubit.dart';
import '../../logic/pos_state.dart';
import '../helper/pos_helpers.dart';
import '../widget/cart_panel.dart';
import '../widget/category_bar.dart';
import '../widget/products_grid.dart';
import '../widget/top_app_bar.dart';
import '../widget/product_search_bar.dart';

class PosCashierScreen extends StatefulWidget {
  const PosCashierScreen({super.key});

  @override
  State<PosCashierScreen> createState() => _PosCashierScreenState();
}

class _PosCashierScreenState extends State<PosCashierScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<OrderCubit>(),
        ),
        BlocProvider(
          create: (_) => DriverCubit(
            DriverRepository(
              DriverLocalDataSource(),
            ),
          )..loadDrivers(),
        )
      ],
      child: Scaffold(
        backgroundColor: Colorsmanegments.background,
        body: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            _handleOrderStateChanges(context, state);
          },
          builder: (context, state) {
            final cubit = context.watch<OrderCubit>();
            final cartItems = cubit.cartItems;

            final totals = PosHelpers.calculateTotals(
              cartItems,
              cubit.selectedOrderType,
              cubit.taxEnabled,
              cubit.taxPercent,
              cubit.deliveryFee,
              cubit.discount,
            );

            return Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const PosTopAppBar(),
                      ProductSearchBar(
                        controller: searchController,
                        onChanged: (value) {
                          context.read<ProductCubit>().searchProducts(value);
                        },
                        focusNode: null,
                      ),
                      const PosCategoryBar(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: PosProductsGrid(
                            onProductTap: (product) {
                              PosHelpers.handleProductTap(context, cubit, product);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CartPanel(
                  cartItems: cartItems,
                  totals: totals,
                  cubit: cubit,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleOrderStateChanges(BuildContext context, OrderState state) {
    if (state is OrderHeldSuccess) {
      PosHelpers.showSnackBar(context, "تم حفظ الأوردر", Colorsmanegments.success);
    }

    if (state is PaymentCompleteSuccess) {
      PosHelpers.showSnackBar(context, "تم الدفع بنجاح", Colorsmanegments.success);

      // 🎯 التحديث الفوري للوحة التحكم بمجرد نجاح الدفع
      try {
        context.read<HomeCubit>().refreshDashboard();
      } catch (_) {
        // لو الـ Cubit غير موجود في هذا السياق يتم تجاهله بأمان
      }
    }

    if (state is OrderError) {
      PosHelpers.showSnackBar(context, state.error, Colorsmanegments.danger);
    }
  }
}