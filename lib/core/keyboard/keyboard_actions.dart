import 'dart:ui';

class KeyboardActions {
  final VoidCallback? onNewOrder;
  final VoidCallback? onPayment;
  final VoidCallback? onHoldOrder;
  final VoidCallback? onSearch;
  final VoidCallback? onHoldingOrders;
  final VoidCallback? onPrint;
  final VoidCallback? onRefresh;

  const KeyboardActions({
    this.onNewOrder,
    this.onPayment,
    this.onHoldOrder,
    this.onSearch,
    this.onHoldingOrders,
    this.onPrint,
    this.onRefresh,
  });
}