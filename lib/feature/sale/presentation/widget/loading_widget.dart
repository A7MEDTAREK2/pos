import 'package:flutter/material.dart';

class SalesLoadingWidget extends StatelessWidget {
  const SalesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}