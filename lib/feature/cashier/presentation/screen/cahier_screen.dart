import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data_base/pos_database.dart';
import '../../../../core/keyboard/keyboard_shortcuts.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../driver/data/localdata.dart';
import '../../../driver/data/repo.dart';
import '../../../driver/logic/drive_cubit.dart';
import '../../../product/data/model/product_model.dart' hide OrderType;
import '../../data/model/pos_model.dart';
import '../../../product/logic/product_cubit.dart';
import '../../../home/logic/home_cubit.dart';
import '../../logic/pos_cubit.dart';
import '../../logic/pos_state.dart';
import '../helper/pos_helpers.dart';
import '../widget/cart_panel.dart';
import '../widget/category_bar.dart';
import '../widget/products_grid.dart';
import '../widget/top_app_bar.dart';
import '../widget/product_search_bar.dart';

// ====== Imports للـ Dialogs ======
import '../widget/edit_amount_dialog.dart';
import '../widget/notes_dialog.dart';
import '../widget/delete_item_dialog.dart';

class PosCashierScreen extends StatefulWidget {
  const PosCashierScreen({super.key});

  @override
  State<PosCashierScreen> createState() => _PosCashierScreenState();
}

class _PosCashierScreenState extends State<PosCashierScreen> {
  final FocusNode searchFocusNode = FocusNode();
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
      child: AppKeyboardShortcuts(
        shortcuts: {
          // ====== F1 - إنهاء الطلب ======
          const SingleActivator(LogicalKeyboardKey.f1): () {
            final cubit = context.read<OrderCubit>();
            if (cubit.cartItems.isNotEmpty && cubit.currentOrder != null) {
              PosHelpers.showPaymentDialog(
                context,
                cubit,
                cubit.totalAmount,
                cubit.selectedOrderType,
              );
            }
          },

          // ====== F2 - البحث عن المنتجات ======
          const SingleActivator(LogicalKeyboardKey.f2): () {
            searchFocusNode.requestFocus();
            searchController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: searchController.text.length,
            );
          },

          // ====== F3 - أوردر جديد ======
          const SingleActivator(LogicalKeyboardKey.f3): () {
            context.read<HomeCubit>().refreshDashboard();
            context.read<OrderCubit>().clearCart();
          },

          // ====== F4 - حفظ الأوردر ======
          const SingleActivator(LogicalKeyboardKey.f4): () {
            final cubit = context.read<OrderCubit>();
            if (cubit.currentOrder != null) {
              cubit.holdOrder();
            }
          },

          // ====== F5 - الطلبات المعلقة ======
          const SingleActivator(LogicalKeyboardKey.f5): () {
            PosHelpers.showPendingOrdersDialog(context);
          },

          // ====== Ctrl + 1 - تيك أواي ======
          const SingleActivator(LogicalKeyboardKey.digit1, control: true): () {
            _changeOrderType(context, 0);
          },

          // ====== Ctrl + 2 - صالة ======
          const SingleActivator(LogicalKeyboardKey.digit2, control: true): () {
            _changeOrderType(context, 1);
          },

          // ====== Ctrl + 3 - دليفري ======
          const SingleActivator(LogicalKeyboardKey.digit3, control: true): () {
            _changeOrderType(context, 2);
          },

          // ====== Ctrl + T - تعديل الضريبة ======
          const SingleActivator(LogicalKeyboardKey.keyT, control: true): () {
            final cubit = context.read<OrderCubit>();
            _editValue(
              context: context,
              title: "الضريبة",
              currentValue: cubit.taxPercent,
              onSave: (v) => cubit.setTaxPercent(v),
            );
          },

          // ====== Ctrl + R - تعديل رسوم التوصيل ======
          const SingleActivator(LogicalKeyboardKey.keyR, control: true): () {
            final cubit = context.read<OrderCubit>();
            _editValue(
              context: context,
              title: "رسوم التوصيل",
              currentValue: cubit.deliveryFee,
              onSave: (v) => cubit.setDeliveryFee(v),
            );
          },

          // ====== Ctrl + C - تعديل الخصم ======
          const SingleActivator(LogicalKeyboardKey.keyC, control: true): () {
            final cubit = context.read<OrderCubit>();
            _editValue(
              context: context,
              title: "الخصم",
              currentValue: cubit.discount,
              onSave: (v) => cubit.setDiscount(v),
            );
          },

          // ====== Ctrl + X - مسح السلة ======
          const SingleActivator(LogicalKeyboardKey.keyX, control: true): () {
            final cubit = context.read<OrderCubit>();
            if (cubit.cartItems.isNotEmpty) {
              _showClearCartConfirmation(context);
            }
          },

          // ====== Ctrl + N - إضافة ملاحظة ======
          const SingleActivator(LogicalKeyboardKey.keyN, control: true): () {
            final cubit = context.read<OrderCubit>();
            if (cubit.cartItems.isNotEmpty) {
              _openNotesDialog(context);
            }
          },

          // ====== Delete - حذف العنصر ======
          const SingleActivator(LogicalKeyboardKey.delete): () {
            final cubit = context.read<OrderCubit>();
            if (cubit.cartItems.isNotEmpty) {
              _deleteLastItem(context);
            }
          },

          // ====== Esc - إغلاق/رجوع ======
          const SingleActivator(LogicalKeyboardKey.escape): () {
            Navigator.pop(context);
          },
        },
        child: Scaffold(
          backgroundColor: Colorsmanegments.background,
          body: SafeArea(
            child: BlocConsumer<OrderCubit, OrderState>(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // القسم الأيمن (المنتجات والبحث)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          const PosTopAppBar(),
                          ProductSearchBar(
                            controller: searchController,
                            focusNode: searchFocusNode,
                            onChanged: (value) {
                              context.read<ProductCubit>().searchProducts(value);
                            },
                          ),
                          const PosCategoryBar(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
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

                    // القسم الأيسر (سلة الطلبات)
                    SizedBox(
                      width: 550,
                      child: CartPanel(
                        cartItems: cartItems,
                        totals: totals,
                        cubit: cubit,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ====== Helper Methods ======

  void _changeOrderType(BuildContext context, int index) {
    final cubit = context.read<OrderCubit>();
    cubit.changeOrderType(OrderType.values[index]);
  }

  Future<void> _editValue({
    required BuildContext context,
    required String title,
    required double currentValue,
    required Function(double) onSave,
  }) async {
    final value = await showDialog<double>(
      context: context,
      builder: (_) => EditAmountDialog(
        title: title,
        value: currentValue,
      ),
    );

    if (value != null) {
      onSave(value);
    }
  }

  void _showClearCartConfirmation(BuildContext context) {
    final cubit = context.read<OrderCubit>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('مسح السلة'),
        content: const Text('هل أنت متأكد من مسح جميع المنتجات من السلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              cubit.clearCart();
              Navigator.pop(context);
            },
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  void _openNotesDialog(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final firstItem = cubit.cartItems.first;
    final controller = TextEditingController(text: firstItem['note'] ?? "");

    showDialog(
      context: context,
      builder: (_) => NotesDialog(controller: controller),
    ).then((result) {
      if (result != null && result is String) {
        cubit.updateItemNote(
          firstItem['productId'],
          result,
          size: firstItem['size'],
        );
      }
    });
  }

  void _deleteLastItem(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final lastItem = cubit.cartItems.last;

    showDialog(
      context: context,
      builder: (_) => DeleteItemDialog(
        itemName: lastItem['name'],
        onDelete: () {
          cubit.removeItem(lastItem['productId'], size: lastItem['size']);
        },
      ),
    );
  }

  void _handleOrderStateChanges(BuildContext context, OrderState state) {
    // تم إزالة جميع الـ SnackBar
    if (state is PaymentCompleteSuccess) {
      try {
        context.read<HomeCubit>().refreshDashboard();
      } catch (_) {}
    }
  }
}