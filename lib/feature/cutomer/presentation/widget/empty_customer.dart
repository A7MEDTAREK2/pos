import 'package:flutter/material.dart';

class EmptyCustomer extends StatelessWidget {
  const EmptyCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
          Text("لا يوجد عملاء"),
        ],
      ),
    );
  }
}