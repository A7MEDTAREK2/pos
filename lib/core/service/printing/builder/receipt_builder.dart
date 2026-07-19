// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
//
// import '../models/receipt_model.dart';
//
// class ReceiptBuilder {
//   Future<List<int>> build(ReceiptModel receipt) async {
//     final profile = await CapabilityProfile.load();
//
//     final generator = Generator(
//       PaperSize.mm80,
//       profile,
//     );
//
//     final bytes = <int>[];
//
//     // Reset
//     bytes.addAll(generator.reset());
//
//     // ==========================
//     // Store
//     // ==========================
//
//     bytes.addAll(
//       generator.text(
//         receipt.storeName,
//         styles: const PosStyles(
//           align: PosAlign.center,
//           bold: true,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//       ),
//     );
//
//     if (receipt.phone != null && receipt.phone!.isNotEmpty) {
//       bytes.addAll(
//         generator.text(
//           receipt.phone!,
//           styles: const PosStyles(
//             align: PosAlign.center,
//           ),
//         ),
//       );
//     }
//
//     if (receipt.address != null && receipt.address!.isNotEmpty) {
//       bytes.addAll(
//         generator.text(
//           receipt.address!,
//           styles: const PosStyles(
//             align: PosAlign.center,
//           ),
//         ),
//       );
//     }
//
//     bytes.addAll(generator.hr());
//
//     //==========================
//     // Order Info
//     //==========================
//
//     bytes.addAll(generator.text("Order : ${receipt.orderNumber}"));
//     bytes.addAll(generator.text("Cashier : ${receipt.cashier}"));
//     bytes.addAll(generator.text("Customer : ${receipt.customerName}"));
//     bytes.addAll(generator.text("Payment : ${receipt.paymentMethod}"));
//     bytes.addAll(generator.text("Type : ${receipt.orderType}"));
//
//     bytes.addAll(generator.hr());
//
//     //==========================
//     // Items
//     //==========================
//
//     for (final item in receipt.items) {
//       final name = item.size == null
//           ? item.productName
//           : "${item.productName} (${item.size})";
//
//       bytes.addAll(
//         generator.row([
//           PosColumn(
//             text: item.quantity.toString(),
//             width: 2,
//           ),
//           PosColumn(
//             text: name,
//             width: 6,
//           ),
//           PosColumn(
//             text: item.total.toStringAsFixed(2),
//             width: 4,
//             styles: const PosStyles(
//               align: PosAlign.right,
//             ),
//           ),
//         ]),
//       );
//     }
//
//     bytes.addAll(generator.hr());
//
//     //==========================
//     // Totals
//     //==========================
//
//     bytes.addAll(generator.text(
//       "Subtotal : ${receipt.subtotal.toStringAsFixed(2)}",
//     ));
//
//     bytes.addAll(generator.text(
//       "Discount : ${receipt.discount.toStringAsFixed(2)}",
//     ));
//
//     bytes.addAll(generator.text(
//       "Tax : ${receipt.tax.toStringAsFixed(2)}",
//     ));
//
//     bytes.addAll(generator.text(
//       "Delivery : ${receipt.deliveryFee.toStringAsFixed(2)}",
//     ));
//
//     bytes.addAll(generator.hr());
//
//     bytes.addAll(
//       generator.text(
//         "TOTAL : ${receipt.total.toStringAsFixed(2)}",
//         styles: const PosStyles(
//           bold: true,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//       ),
//     );
//
//     bytes.addAll(generator.hr());
//
//     bytes.addAll(
//       generator.text(
//         "Thank You",
//         styles: const PosStyles(
//           align: PosAlign.center,
//           bold: true,
//         ),
//       ),
//     );
//
//     bytes.addAll(generator.feed(3));
//
//     bytes.addAll(generator.cut());
//
//     return bytes;
//   }
// }