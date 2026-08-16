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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: _buildAppBar(context),
      body: BlocConsumer<DriverCubit, DriverState>(
        listener: (context, state) {
          // تم إزالة جميع SnackBars
        },
        builder: (context, state) {
          final cubit = context.read<DriverCubit>();
          final drivers = cubit.drivers;

          final filteredDrivers = _searchQuery.isEmpty
              ? drivers
              : drivers.where((driver) =>
          driver.name.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
              (driver.phone?.contains(_searchQuery) ?? false)).toList();

          return Column(
            children: [
              _buildSearchBar(context),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      title: Text(
        'إدارة المندوبين',
        style: theme.textTheme.headlineMedium?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.read<DriverCubit>().loadDrivers();
          },
          icon: Icon(
            Icons.refresh_rounded,
            color: colorScheme.primary,
            size: 28,
          ),
          tooltip: 'تحديث القائمة',
        ),
        IconButton(
          onPressed: () {
            _showAddEditDialog(context, null);
          },
          icon: Icon(
            Icons.add_circle_rounded,
            color: colorScheme.primary,
            size: 32,
          ),
          tooltip: 'إضافة مندوب جديد',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: colorScheme.surface,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: colorScheme.onSurface.withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'بحث عن مندوب...',
                  hintStyle: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
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
                  color: colorScheme.onSurface.withOpacity(0.5),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state is DriverLoading && filteredDrivers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline_rounded,
            size: 80,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'لا يوجد مندوبين'
                : 'لا توجد نتائج للبحث',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'أضف مندوب جديد بالضغط على زر +'
                : 'جرب كلمات بحث مختلفة',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
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
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'تأكيد الحذف',
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف المندوب "${driver.name}"؟',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
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
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}