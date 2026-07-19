import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../../core/theming/colors manegments.dart';

import '../logic/drive_cubit.dart';
import '../logic/drive_state.dart';
import 'card.dart';
import 'dialog.dart';


class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanegments.background,
      appBar: _buildAppBar(context),
      body: BlocConsumer<DriverCubit, DriverState>(
        listener: (context, state) {
          if (state is DriverOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colorsmanegments.success,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          if (state is DriverError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colorsmanegments.danger,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<DriverCubit>();
          final drivers = cubit.drivers;

          // فلترة المندوبين حسب البحث
          final filteredDrivers = _searchQuery.isEmpty
              ? drivers
              : drivers.where((driver) =>
          driver.name.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
              (driver.phone?.contains(_searchQuery) ?? false)).toList();

          return Column(
            children: [
              // ====== Search Bar ======
              _buildSearchBar(),
              // ====== Body ======
              Expanded(
                child: _buildBody(
                  context,
                  state,
                  filteredDrivers,
                  cubit,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colorsmanegments.card,
      elevation: 0,
      title: Text(
        'إدارة المندوبين',
        style: TxtStyle.headerLarge.copyWith(fontSize: 22),
      ),
      actions: [
        // ====== Refresh Button ======
        IconButton(
          onPressed: () {
            context.read<DriverCubit>().loadDrivers();
          },
          icon: Icon(
            Icons.refresh_rounded,
            color: Colorsmanegments.primary,
            size: 28,
          ),
          tooltip: 'تحديث القائمة',
        ),
        // ====== Add Button ======
        IconButton(
          onPressed: () {
            _showAddEditDialog(context, null);
          },
          icon: Icon(
            Icons.add_circle_rounded,
            color: Colorsmanegments.primary,
            size: 32,
          ),
          tooltip: 'إضافة مندوب جديد',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colorsmanegments.card,
      child: Container(
        decoration: BoxDecoration(
          color: Colorsmanegments.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colorsmanegments.border,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: Colorsmanegments.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'بحث عن مندوب...',
                  hintStyle: TxtStyle.bodySmall.copyWith(
                    color: Colorsmanegments.grey,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: TxtStyle.bodyMedium,
              ),
            ),
            if (_searchQuery.isNotEmpty)
              IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: Colorsmanegments.grey,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      DriverState state,
      List<dynamic> filteredDrivers,
      DriverCubit cubit,
      ) {
    if (state is DriverLoading && filteredDrivers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colorsmanegments.primary,
        ),
      );
    }

    if (filteredDrivers.isEmpty) {
      return _buildEmptyState(context);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2,
        ),
        itemCount: filteredDrivers.length,
        itemBuilder: (context, index) {
          final driver = filteredDrivers[index];
          return DriverCard(
            driver: driver,
            onEdit: () {
              _showAddEditDialog(context, driver);
            },
            onDelete: () {
              _showDeleteConfirmation(context, driver, cubit);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: 80,
            color: Colorsmanegments.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'لا يوجد مندوبين'
                : 'لا توجد نتائج للبحث',
            style: TxtStyle.titleMedium.copyWith(
              color: Colorsmanegments.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'أضف مندوب جديد بالضغط على زر +'
                : 'جرب كلمات بحث مختلفة',
            style: TxtStyle.bodySmall.copyWith(
              color: Colorsmanegments.grey,
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: Text(
                'مسح البحث',
                style: TxtStyle.buttonPrimary.copyWith(
                  color: Colorsmanegments.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, dynamic driver) {
    showDialog(
      context: context,
      builder: (_) => AddEditDriverDialog(
        driver: driver,
        onSaved: () {
          context.read<DriverCubit>().loadDrivers();
        },
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context,
      dynamic driver,
      DriverCubit cubit,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colorsmanegments.danger,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'تأكيد الحذف',
              style: TxtStyle.titleMedium,
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف المندوب "${driver.name}"؟',
          style: TxtStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TxtStyle.buttonPrimary,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorsmanegments.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteDriver(driver.id!);
            },
            child: Text(
              'حذف',
              style: TxtStyle.buttonMedium.copyWith(
                color: Colorsmanegments.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}