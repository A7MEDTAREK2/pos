import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'keyboard_actions.dart';
import 'keyboard_intents.dart';

class KeyboardManager extends StatelessWidget {
  final Widget child;
  final KeyboardActions actions;

  const KeyboardManager({
    super.key,
    required this.child,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const {

        /// F1
        SingleActivator(LogicalKeyboardKey.f1):
        PaymentIntent(),

        /// F2
        SingleActivator(LogicalKeyboardKey.f2):
        HoldOrderIntent(),

        /// F3
        SingleActivator(LogicalKeyboardKey.f3):
        NewOrderIntent(),

        /// F4
        SingleActivator(LogicalKeyboardKey.f4):
        SearchIntent(),

        /// F5
        SingleActivator(LogicalKeyboardKey.f5):
        RefreshIntent(),

        /// F6
        SingleActivator(LogicalKeyboardKey.f6):
        OpenHoldingOrdersIntent(),

        /// Ctrl + P
        SingleActivator(
          LogicalKeyboardKey.keyP,
          control: true,
        ): PrintIntent(),
      },
      child: Actions(
        actions: {

          PaymentIntent: CallbackAction<PaymentIntent>(
            onInvoke: (_) {
              actions.onPayment?.call();
              return null;
            },
          ),

          HoldOrderIntent: CallbackAction<HoldOrderIntent>(
            onInvoke: (_) {
              actions.onHoldOrder?.call();
              return null;
            },
          ),

          NewOrderIntent: CallbackAction<NewOrderIntent>(
            onInvoke: (_) {
              actions.onNewOrder?.call();
              return null;
            },
          ),

          SearchIntent: CallbackAction<SearchIntent>(
            onInvoke: (_) {
              actions.onSearch?.call();
              return null;
            },
          ),

          RefreshIntent: CallbackAction<RefreshIntent>(
            onInvoke: (_) {
              actions.onRefresh?.call();
              return null;
            },
          ),

          OpenHoldingOrdersIntent:
          CallbackAction<OpenHoldingOrdersIntent>(
            onInvoke: (_) {
              actions.onHoldingOrders?.call();
              return null;
            },
          ),

          PrintIntent: CallbackAction<PrintIntent>(
            onInvoke: (_) {
              actions.onPrint?.call();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}