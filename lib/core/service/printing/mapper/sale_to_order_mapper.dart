import '../../../../feature/cashier/data/model/pos_model.dart';
import '../../../../feature/reports/data/model/sale_detail_report.dart';


class SaleToOrderMapper {
  static OrderModel map(SaleDetailsModel sale) {

    return OrderModel(
      id: sale.saleId.toString(),

      orderNumber: sale.orderNumber,

      items: sale.items.map((item) {
        return {
          'productId': item.productId,
          'name': item.productName,
          'quantity': item.quantity,
          'price': item.price,
          'image': null,
          'note': '',
          'size': item.sizeName,
        };
      }).toList(),

      totalAmount: sale.total,

      orderType: OrderType.values[sale.orderType],

      orderStatus: OrderStatus.paid,

      customerName: sale.customerName,
      customerPhone: sale.customerPhone,
      customerAddress: sale.customerAddress,

      subtotal: sale.subtotal,
      discount: sale.discount,
      tax: sale.tax,
      deliveryFee: sale.deliveryFee,

      paymentMethod: sale.paymentMethod,

      createdAt: sale.createdAt,
    );
  }
}