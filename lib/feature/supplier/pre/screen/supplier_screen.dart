// lib/feature/supplier/presentation/screen/AddPurchaseScreen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/supplier_model.dart';
import '../../logic/supplier_cubit.dart';
import '../../logic/supplier_state.dart';
import '../widget/supplier_dialog.dart';
import '../widget/supplier_item.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupplierCubit>().loadSuppliers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<SupplierCubit>(),
        child: const SupplierDialog(),
      ),
    );
  }

  void _openEditDialog(SupplierModel supplier) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<SupplierCubit>(),
        child: SupplierDialog(
          supplier: supplier,
        ),
      ),
    );
  }

  Future<void> _deleteSupplier(
      SupplierModel supplier,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف المورد'),
          content: Text(
            'هل أنت متأكد من حذف "${supplier.name}"؟',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && supplier.id != null) {
      await context
          .read<SupplierCubit>()
          .deleteSupplier(supplier.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الموردين'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      context
                          .read<SupplierCubit>()
                          .searchSuppliers(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'بحث باسم المورد أو رقم الهاتف...',
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      suffixIcon: _searchController
                          .text.isNotEmpty
                          ? IconButton(
                        onPressed: () {
                          _searchController.clear();

                          context
                              .read<SupplierCubit>()
                              .loadSuppliers();

                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.clear,
                        ),
                      )
                          : null,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                ElevatedButton.icon(
                  onPressed: _openAddDialog,
                  icon: const Icon(
                    Icons.add,
                  ),
                  label: const Text(
                    'إضافة مورد',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Expanded(
              child: BlocConsumer<SupplierCubit, SupplierState>(
                listener: (context, state) {
                  if (state is SupplierError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is SupplierLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is SupplierLoaded) {
                    if (state.suppliers.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.separated(
                      itemCount: state.suppliers.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final supplier =
                        state.suppliers[index];

                        return SupplierItem(
                          supplier: supplier,
                          onEdit: () {
                            _openEditDialog(supplier);
                          },
                          onDelete: () {
                            _deleteSupplier(supplier);
                          },
                          onToggleStatus: () {
                            context
                                .read<SupplierCubit>()
                                .toggleSupplierStatus(
                              supplier,
                            );
                          },
                        );
                      },
                    );
                  }

                  if (state is SupplierError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(state.message),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<SupplierCubit>()
                                  .loadSuppliers();
                            },
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  return _buildEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.business_outlined,
            size: 72,
            color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color,
          ),
          const SizedBox(height: 16),
          const Text(
            'لا يوجد موردين حتى الآن',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ابدأ بإضافة أول مورد',
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _openAddDialog,
            icon: const Icon(Icons.add),
            label: const Text('إضافة مورد'),
          ),
        ],
      ),
    );
  }
}