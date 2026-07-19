// lib/feature/cashier/presentation/widget/dynamic_order_fields.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Customer ======
import '../../../cutomer/data/model/customer_model.dart';
import '../../../cutomer/logic/customer_cubit.dart';
import '../../../cutomer/presentation/widget/address.dart';
import '../../../cutomer/presentation/widget/address_popup.dart';

// ====== Cashier ======
import '../../logic/pos_cubit.dart';
import 'new_customer_dialog.dart';

class DynamicOrderFields extends StatefulWidget {
  final int orderTypeIndex;

  const DynamicOrderFields({super.key, required this.orderTypeIndex});

  @override
  State<DynamicOrderFields> createState() => _DynamicOrderFieldsState();
}

class _DynamicOrderFieldsState extends State<DynamicOrderFields> {
  bool customerFound = false;
  String customerName = "";
  String customerArea = "";
  final customerNameController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final customerAddressController = TextEditingController();
  final customerAreaController = TextEditingController();
  bool showAddresses = false;

  void _showNewCustomerDialog() {
    showDialog(
      context: context,
      builder: (_) => NewCustomerDialog(
        phone: customerPhoneController.text,
        onSave: (name, area, address) async {
          final customerCubit = context.read<CustomerCubit>();

          await customerCubit.addCustomer(
            CustomerModel(
              id: 0,
              name: name,
              phone: customerPhoneController.text,
              createdAt: DateTime.now(),
            ),
          );

          final customer = await customerCubit.getCustomerByPhone(
            customerPhoneController.text,
          );

          if (customer != null) {
            context.read<OrderCubit>().setCustomer(customer);
            await context
                .read<CustomerAddressCubit>()
                .loadAddresses(customer.id!);

            setState(() {
              customerFound = true;
              customerName = customer.name;
              customerNameController.text = customer.name;
              customerAreaController.clear();
              customerAddressController.clear();
            });
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerPhoneController.dispose();
    customerAddressController.dispose();
    customerAreaController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.watch<OrderCubit>();

    if (customerNameController.text != (cubit.customerName ?? '')) {
      customerNameController.text = cubit.customerName ?? '';
    }
    if (customerPhoneController.text != (cubit.customerPhone ?? '')) {
      customerPhoneController.text = cubit.customerPhone ?? '';
    }
    if (customerAddressController.text != (cubit.customerAddress ?? '')) {
      customerAddressController.text = cubit.customerAddress ?? '';
    }
    if (customerAreaController.text != (cubit.customerArea ?? '')) {
      customerAreaController.text = cubit.customerArea ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();

    if (widget.orderTypeIndex == 0) {
      return const SizedBox.shrink();
    }

    if (widget.orderTypeIndex == 1) {
      return _buildDineInFields(cubit);
    }

    return _buildDeliveryFields();
  }

  // ============================================================
  // Dine In Fields
  // ============================================================
  Widget _buildDineInFields(OrderCubit cubit) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, left: 4, right: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colorsmanegments.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colorsmanegments.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colorsmanegments.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconss.tableRestaurant,
                color: Colorsmanegments.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "بيانات الطاولة",
                style: TxtStyle.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: cubit.tableNumber ?? "طاولة 1",
            style: TxtStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colorsmanegments.background,
              prefixIcon: Icon(
                Iconss.tableBar,
                color: Colorsmanegments.primary,
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colorsmanegments.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colorsmanegments.primary,
                  width: 1.5,
                ),
              ),
            ),
            items: ['طاولة 1', 'طاولة 2', 'طاولة 3', 'طاولة 4'].map((table) {
              return DropdownMenuItem(value: table, child: Text(table));
            }).toList(),
            onChanged: (value) {
              cubit.tableNumber = value;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Delivery Fields
  // ============================================================
  Widget _buildDeliveryFields() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(top: 12, left: 4, right: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colorsmanegments.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colorsmanegments.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colorsmanegments.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCompactTextField(
              controller: customerPhoneController,
              hint: "أدخل رقم الهاتف واضغط Enter للبحث",
              icon: Iconss.phone,
              showArrow: customerFound,
              onChanged: (_) {},
              onSubmitted: () async {
                await _searchCustomer();
              },
            ),
            if (customerFound) ...[
              const SizedBox(height: 12),
              _buildCustomerCard(),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Compact Text Field
  // ============================================================
  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
    VoidCallback? onSubmitted,
    bool showArrow = false,
  }) {
    final customer = context.read<OrderCubit>().selectedCustomer;
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: (_) {
          if (onSubmitted != null) {
            onSubmitted();
          }
        },
        keyboardType: TextInputType.phone,
        textDirection: TextDirection.ltr,
        style: TxtStyle.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          suffixIcon: customerFound && customer != null
              ? AddressPopup(
            customerId: customer.id!,
            onSelected: (address) {
              context.read<OrderCubit>().setAddress(address);
              setState(() {
                customerArea = address.area;
                customerAddressController.text = address.address;
              });
            },
          )
              : null,
          hintText: hint,
          hintStyle: TxtStyle.hintSmall,
          prefixIcon: Icon(
            icon,
            size: 18,
            color: Colorsmanegments.primary,
          ),
          filled: true,
          fillColor: Colorsmanegments.background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colorsmanegments.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colorsmanegments.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Customer Card
  // ============================================================
  Widget _buildCustomerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colorsmanegments.primaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colorsmanegments.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildLabeledValue(
              icon: Iconss.person,
              label: "الاسم",
              value: customerName.isNotEmpty ? customerName : "غير مسجل",
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: Colorsmanegments.primary.withOpacity(0.2),
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
          Expanded(
            child: _buildLabeledValue(
              icon: Iconss.phone,
              label: "الهاتف",
              value: customerPhoneController.text,
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: Colorsmanegments.primary.withOpacity(0.2),
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
          Expanded(
            child: _buildLabeledValue(
              icon: Iconss.location,
              label: "المنطقة",
              value: customerArea.isNotEmpty ? customerArea : "اختر العنوان",
              isHighlight: true,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Labeled Value
  // ============================================================
  Widget _buildLabeledValue({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 13,
              color: isHighlight
                  ? Colorsmanegments.primary
                  : Colorsmanegments.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TxtStyle.labelSmall.copyWith(
                color: Colorsmanegments.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TxtStyle.labelBold.copyWith(
            fontSize: 12,
            color: isHighlight
                ? Colorsmanegments.primary
                : Colorsmanegments.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  // ============================================================
  // Search Customer
  // ============================================================
  Future<void> _searchCustomer() async {
    final phone = customerPhoneController.text.trim();

    if (phone.isEmpty) return;

    final customerCubit = context.read<CustomerCubit>();
    final customer = await customerCubit.findCustomerByPhone(phone);

    if (customer != null) {
      final addressCubit = context.read<CustomerAddressCubit>();
      final orderCubit = context.read<OrderCubit>();

      await addressCubit.loadAddresses(customer.id!);
      orderCubit.setCustomer(customer);

      if (addressCubit.addresses.isNotEmpty) {
        addressCubit.selectAddress(addressCubit.addresses.first);
        orderCubit.setAddress(addressCubit.addresses.first);

        customerArea = addressCubit.addresses.first.area;
        customerAddressController.text = addressCubit.addresses.first.address;
      }

      orderCubit.setCustomer(customer);

      if (addressCubit.selectedAddress != null) {
        orderCubit.setAddress(addressCubit.selectedAddress!);
      }

      setState(() {
        customerFound = true;
        showAddresses = false;
        customerName = customer.name;
      });
    } else {
      _showNewCustomerDialog();
    }
  }

  Future<void> _loadOpenedOrderCustomer() async {
    final orderCubit = context.read<OrderCubit>();

    if (orderCubit.customerId == null) return;

    final addressCubit = context.read<CustomerAddressCubit>();

    await addressCubit.loadAddresses(orderCubit.customerId!);

    if (orderCubit.customerAddressId != null) {
      final address = addressCubit.addresses.firstWhere(
            (e) => e.id == orderCubit.customerAddressId,
        orElse: () => addressCubit.addresses.first,
      );

      addressCubit.selectAddress(address);
      orderCubit.setAddress(address);

      setState(() {
        customerFound = true;
        customerName = orderCubit.customerName ?? "";
        customerArea = address.area;
        customerAddressController.text = address.address;
      });
    }
  }
}