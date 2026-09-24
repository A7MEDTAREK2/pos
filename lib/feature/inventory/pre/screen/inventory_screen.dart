// lib/feature/inventory/presentation/screen/inventory_screen.dart (أو المسار الخاص بها)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/service/audit_log_service.dart';

import '../../logic/inventory_cubit.dart';
import '../../logic/inventory_state.dart';
import '../widget/adjust_stock_dialog.dart';
import '../widget/stock_item_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 📝 تسجيل الدخول لشاشة المخزون
    AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'ENTER',
      module: 'المخزون',
      entityType: 'Screen',
      description: 'دخل إلى شاشة إدارة المخزون والتنبيهات',
    );

    context.read<InventoryCubit>().fetchStockItems();
  }

  @override
  void dispose() {
    // 📝 تسجيل الخروج من شاشة المخزون
    AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'EXIT',
      module: 'المخزون',
      entityType: 'Screen',
      description: 'خرج من شاشة إدارة المخزون والتنبيهات',
    );

    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المخزون والتنبيهات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            tooltip: 'تنبيهات نواقص المخزون',
            onPressed: () {
              context.read<InventoryCubit>().fetchLowStockAlerts();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchController.clear();
              context.read<InventoryCubit>().fetchStockItems();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث باسم المنتج أو الباركد...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<InventoryCubit>().fetchStockItems();
                  },
                ),
              ),
              onChanged: (value) {
                context.read<InventoryCubit>().fetchStockItems(search: value);
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<InventoryCubit, InventoryState>(
              listener: (context, state) {
                if (state is InventoryErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: ${state.message}'), backgroundColor: Colors.red),
                  );
                }
              },
              builder: (context, state) {
                if (state is InventoryLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is StockLoadedState) {
                  if (state.items.isEmpty) {
                    return const Center(child: Text('لا توجد منتجات في المخزون'));
                  }
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return StockItemCard(
                        item: item,
                        onEditTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AdjustStockDialog(
                              item: item,
                              onConfirm: (newQty, reason, note) {
                                context.read<InventoryCubit>().adjustStock(
                                  productId: item.id,
                                  newQuantity: newQty,
                                  reason: reason,
                                  note: note,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                if (state is LowStockLoadedState) {
                  if (state.items.isEmpty) {
                    return const Center(child: Text('لا توجد منتجات تحت الحد الأدنى حالياً'));
                  }
                  return Column(
                    children: [
                      Container(
                        color: Colors.amber.shade100,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'تنبيه: يتم عرض ${state.items.length} منتج وصل للحد الأدنى للمخزون',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return StockItemCard(
                              item: item,
                              onEditTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AdjustStockDialog(
                                    item: item,
                                    onConfirm: (newQty, reason, note) {
                                      context.read<InventoryCubit>().adjustStock(
                                        productId: item.id,
                                        newQuantity: newQty,
                                        reason: reason,
                                        note: note,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const Center(child: Text('قم بالبحث أو تحديث القائمة'));
              },
            ),
          ),
        ],
      ),
    );
  }
}