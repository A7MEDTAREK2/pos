import 'package:flutter/material.dart';
import '../../../../../core/theming/txt_style.dart';
import '../../../product/data/model/product_model.dart' hide OrderType;
import '../../data/model/pos_model.dart';
import '../../logic/pos_cubit.dart';
import '../widget/product_size_dialog.dart';

class PosHelpers {
  static void showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  static void handleProductTap(
      BuildContext context,
      OrderCubit orderCubit,
      ProductModel product,
      ) {
    if (product.hasSizes) {
      showDialog(
        context: context,
        builder: (_) => ProductSizeDialog(
          product: product,
          onSizeSelected: (size) {
            orderCubit.addToCart({
              'productId': product.id.toString(),
              'name': product.name,
              'price': size.price,
              'image': product.image,
              'note': "",
              'size': size.sizeName,
              'categoryName': product.categoryId,
              'categoryName': product.categoryName ?? "General",

            });
          },
        ),
      );
    } else {
      orderCubit.addToCart({
        'productId': product.id.toString(),
        'name': product.name,
        'price': product.sellPrice ?? 0,
        'image': product.image,
        'note': "",
        'categoryName': product.categoryId,
        'categoryName': product.categoryName ?? "General",


      });
    }
  }

  static PosTotals calculateTotals(
      List<Map<String, dynamic>> cartItems,
      OrderType orderType,
      bool taxEnabled,
      double taxPercent,
      double deliveryFee,
      double discount,
      ) {
    double subTotal = cartItems.fold(
      0.0,
          (sum, item) => sum + ((item['price'] as num) * (item['quantity'] as int)),
    );

    double tax = taxEnabled ? subTotal * (taxPercent / 100) : 0;
    double delivery = orderType == OrderType.delivery ? deliveryFee : 0;
    double finalTotal = subTotal + tax + delivery - discount;

    return PosTotals(
      subTotal: subTotal,
      tax: tax,
      delivery: delivery,
      discount: discount,
      finalTotal: finalTotal,
    );
  }
}

class PosTotals {
  final double subTotal;
  final double tax;
  final double delivery;
  final double discount;
  final double finalTotal;

  PosTotals({
    required this.subTotal,
    required this.tax,
    required this.delivery,
    required this.discount,
    required this.finalTotal,
  });
}