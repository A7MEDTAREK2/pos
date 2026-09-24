// lib/feature/supplier/presentation/widget/adjust_stock_dialog.dart

import 'package:flutter/material.dart';

import '../../data/model/supplier_model.dart';

class SupplierItem extends StatelessWidget {
  final SupplierModel supplier;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const SupplierItem({
    super.key,
    required this.supplier,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        leading: CircleAvatar(
          child: Icon(
            supplier.isActive
                ? Icons.business
                : Icons.business_outlined,
          ),
        ),
        title: Text(
          supplier.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (supplier.phone.isNotEmpty)
                Text('الهاتف: ${supplier.phone}'),

              if (supplier.address.isNotEmpty)
                Text('العنوان: ${supplier.address}'),

              const SizedBox(height: 4),

              Text(
                supplier.isActive
                    ? 'نشط'
                    : 'غير نشط',
                style: TextStyle(
                  color: supplier.isActive
                      ? Colors.green
                      : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit();
                break;

              case 'toggle':
                onToggleStatus();
                break;

              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 8),
                  Text('تعديل'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    supplier.isActive
                        ? Icons.block_outlined
                        : Icons.check_circle_outline,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    supplier.isActive
                        ? 'تعطيل'
                        : 'تفعيل',
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text('حذف'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}