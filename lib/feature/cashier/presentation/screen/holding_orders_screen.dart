// lib/feature/cashier/presentation/screen/holding_orders_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Cashier ======
import '../../data/model/pos_model.dart';
import '../../logic/pos_cubit.dart';
import '../../logic/pos_state.dart';

class HoldingOrdersScreen extends StatefulWidget {
  const HoldingOrdersScreen({super.key});

  @override
  State<HoldingOrdersScreen> createState() => _HoldingOrdersScreenState();
}

class _HoldingOrdersScreenState extends State<HoldingOrdersScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchText = "";

  int selectedTabIndex = 0;
  String searchQuery = '';
  final List<String> tabs = ['الكل', 'صالة', 'دليفري', 'تيك أواي'];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderCubit>().fetchHoldingOrders();
    });

    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    List<OrderModel> filtered = List.from(orders);

    // Filter حسب النوع
    switch (selectedTabIndex) {
      case 1:
        filtered =
            filtered.where((e) => e.orderType == OrderType.dineIn).toList();
        break;

      case 2:
        filtered =
            filtered.where((e) => e.orderType == OrderType.delivery).toList();
        break;

      case 3:
        filtered =
            filtered.where((e) => e.orderType == OrderType.takeAway).toList();
        break;
    }

    // Filter حسب البحث
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();

      filtered = filtered.where((e) {
        final orderNumberMatch =
        e.orderNumber.toString().startsWith(query);

        final customerNameMatch =
            e.customerName?.trim().toLowerCase().contains(query) ?? false;

        final phoneMatch =
            e.customerPhone?.trim().contains(query) ?? false;

        final tableMatch =
            e.tableNumber?.trim().toLowerCase().contains(query) ?? false;
        return orderNumberMatch ||
            customerNameMatch ||
            phoneMatch ||
            tableMatch;
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الأوردرات المحجوزة',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Iconss.arrowBack,
            color: theme.textTheme.bodyLarge?.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(context),
          _buildSearchBar(context),
          Expanded(
            child: BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is HoldingOrdersLoaded) {
                  final orders = _filterOrders(state.holdingOrders);

                  if (orders.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      return _buildOrderCard(context, orders[index]);
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(
          tabs.length,
              (index) => Expanded(child: _buildTabItem(context, index)),
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, int index) {
    final isSelected = selectedTabIndex == index;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getTabIcon(index),
                size: 18,
                color: isSelected
                    ? colorScheme.onPrimary
                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
              const SizedBox(width: 6),
              Text(
                tabs[index],
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTabIcon(int index) {
    switch (index) {
      case 0:
        return Iconss.listAlt;
      case 1:
        return Iconss.tableRestaurant;
      case 2:
        return Iconss.delivery;
      case 3:
        return Iconss.takeaway;
      default:
        return Iconss.listAlt;
    }
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: searchController,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'ابحث برقم الأوردر أو اسم العميل أو رقم الطاولة',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            fontFamily: 'Cairo',
          ),
          prefixIcon: Icon(
            Iconss.search,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Iconss.clear,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
            onPressed: () => searchController.clear(),
          )
              : null,
          filled: true,
          fillColor: colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "أوردر #${order.orderNumber}",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${order.items.length} صنف",
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${_getOrderType(order.orderType)} | ${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getOrderColor(order.orderType).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getOrderIcon(order.orderType),
                      size: 16,
                      color: _getOrderColor(order.orderType),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _getOrderType(order.orderType),
                      style: TextStyle(
                        color: _getOrderColor(order.orderType),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 24,
            color: theme.dividerColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (order.customerName != null && order.customerName!.isNotEmpty)
                    Text(
                      "👤 ${order.customerName}",
                      style: theme.textTheme.bodyMedium,
                    ),
                  if (order.customerPhone != null && order.customerPhone!.isNotEmpty)
                    Text(
                      "📞 ${order.customerPhone}",
                      style: theme.textTheme.bodyMedium,
                    ),
                  if (order.tableNumber != null && order.tableNumber!.isNotEmpty)
                    Text(
                      "🍽 ${order.tableNumber}",
                      style: theme.textTheme.bodyMedium,
                    ),
                  if (order.customerAddress != null && order.customerAddress!.isNotEmpty)
                    Text(
                      "📍 ${order.customerAddress}",
                      style: theme.textTheme.bodySmall,
                    ),
                  if ((order.customerName == null || order.customerName!.isEmpty) &&
                      (order.tableNumber == null || order.tableNumber!.isEmpty) &&
                      (order.customerAddress == null || order.customerAddress!.isEmpty))
                    Text(
                      "بدون بيانات",
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
              Text(
                "${order.totalAmount.toStringAsFixed(2)} ج.م",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<OrderCubit>().loadHoldingOrder(order);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "فتح الأوردر",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                  ),
                  onPressed: () {
                    context.read<OrderCubit>().deleteHoldingOrder(order.id!);
                  },
                  child: Text(
                    "حذف الأوردر",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
            Iconss.orderEmpty,
            size: 80,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "لا توجد أوردرات محجوزة",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              context.read<OrderCubit>().fetchHoldingOrders();
            },
            icon: Icon(
              Iconss.refresh,
              color: colorScheme.primary,
            ),
            label: Text(
              "تحديث",
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _getOrderType(OrderType type) {
  switch (type) {
    case OrderType.dineIn:
      return "صالة";
    case OrderType.delivery:
      return "دليفري";
    case OrderType.takeAway:
      return "تيك أواي";
  }
}

Color _getOrderColor(OrderType type) {
  switch (type) {
    case OrderType.dineIn:
      return Colorsmanegments.success;
    case OrderType.delivery:
      return Colorsmanegments.primary;
    case OrderType.takeAway:
      return Colorsmanegments.warning;
  }
}

IconData _getOrderIcon(OrderType type) {
  switch (type) {
    case OrderType.dineIn:
      return Iconss.tableRestaurant;
    case OrderType.delivery:
      return Iconss.delivery;
    case OrderType.takeAway:
      return Iconss.takeaway;
  }
}