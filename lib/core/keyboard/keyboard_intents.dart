import 'package:flutter/widgets.dart';

class NewOrderIntent extends Intent {
  const NewOrderIntent();
}

class PaymentIntent extends Intent {
  const PaymentIntent();
}

class HoldOrderIntent extends Intent {
  const HoldOrderIntent();
}

class SearchIntent extends Intent {
  const SearchIntent();
}

class OpenHoldingOrdersIntent extends Intent {
  const OpenHoldingOrdersIntent();
}

class PrintIntent extends Intent {
  const PrintIntent();
}

class RefreshIntent extends Intent {
  const RefreshIntent();
}