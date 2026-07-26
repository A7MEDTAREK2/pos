import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppKeyboardShortcuts extends StatelessWidget {
  final Widget child;
  final Map<ShortcutActivator, VoidCallback> shortcuts;

  const AppKeyboardShortcuts({
    super.key,
    required this.child,
    required this.shortcuts,
  });

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        for (final entry in shortcuts.entries)
          entry.key: entry.value,
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}