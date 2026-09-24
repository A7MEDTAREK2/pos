import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/inventory_cubit.dart';
import '../../logic/inventory_state.dart';


class InventoryMovementsScreen extends StatefulWidget {
  const InventoryMovementsScreen({super.key});

  @override
  State<InventoryMovementsScreen> createState() => _InventoryMovementsScreenState();
}

class _InventoryMovementsScreenState extends State<InventoryMovementsScreen> {
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadMovements();
  }

  void _loadMovements() {
    context.read<InventoryCubit>().fetchMovements(from: _fromDate, to: _toDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل حركات المخزون'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text('من: ${_fromDate.toString().split(' ')[0]}'),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _fromDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _fromDate = picked);
                      _loadMovements();
                    }
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text('إلى: ${_toDate.toString().split(' ')[0]}'),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _toDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _toDate = picked);
                      _loadMovements();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<InventoryCubit, InventoryState>(
              builder: (context, state) {
                if (state is InventoryLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is InventoryMovementsLoadedState) {
                  if (state.movements.isEmpty) {
                    return const Center(child: Text('لا توجد حركات مخزون في هذه الفترة'));
                  }

                  return ListView.separated(
                    itemCount: state.movements.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final move = state.movements[index];
                      final bool isIn = move.movementType == 'in';

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isIn ? Colors.green.shade100 : Colors.red.shade100,
                          child: Icon(
                            isIn ? Icons.add : Icons.remove,
                            color: isIn ? Colors.green : Colors.red,
                          ),
                        ),
                        title: Text(move.productName ?? 'منتج #${move.productId}'),
                        subtitle: Text('${move.note ?? "بدون ملاحظات"}\n${move.createdAt.toString().split('.')[0]}'),
                        trailing: Text(
                          '${isIn ? "+" : ""}${move.quantity.toInt()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isIn ? Colors.green : Colors.red,
                          ),
                        ),
                        isThreeLine: true,
                      );
                    },
                  );
                }

                return const Center(child: Text('حدد الفترة لعرض السجل'));
              },
            ),
          ),
        ],
      ),
    );
  }
}