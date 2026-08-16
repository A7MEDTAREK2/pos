// lib/feature/sale/presentation/widget/sales_loading_widget.dart

import 'package:flutter/material.dart';

class SalesLoadingWidget extends StatelessWidget {
  const SalesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}