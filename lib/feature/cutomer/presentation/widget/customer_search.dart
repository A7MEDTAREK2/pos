import 'package:flutter/material.dart';

class CustomerSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const CustomerSearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "بحث بالاسم أو الهاتف",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}