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
  String customerAddressValue = "";
  final customerNameController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final customerAddressController = TextEditingController();
  final customerAreaController = TextEditingController();
  bool showAddresses = false;

  String? phoneErrorText;

  @override
  void initState() {
    super.initState();
    // 🔍 أول ما الواجهة تفتح، جرب تحمل بيانات العميل لو ده أوردر قديم (Holding)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOpenedOrderCustomer();
    });
  }

  // إظهار نافذة إضافة عميل جديد في حال لم يتم العثور على الرقم
  void _showNewCustomerDialog() {
    final phoneText = customerPhoneController.text.trim();

    showDialog(
      context: context,
      builder: (_) => NewCustomerDialog(
        initialPhone: phoneText,
        onSave: (phone, name, area, address) async {
          final customerCubit = context.read<CustomerCubit>();
          final addressCubit = context.read<CustomerAddressCubit>();
          final orderCubit = context.read<OrderCubit>();

          final customerId = await customerCubit.addCustomer(
            CustomerModel(
              id: 0,
              name: name,
              phone: phone,
              createdAt: DateTime.now(),
            ),
          );

          if (customerId != null) {
            final newAddress = CustomerAddressModel(
              customerId: customerId,
              title: "المنزل",
              area: area,
              address: address,
              isDefault: true,
              createdAt: DateTime.now(),
            );

            await addressCubit.addAddress(newAddress);
            await addressCubit.loadAddresses(customerId);

            final createdCustomer = CustomerModel(
              id: customerId,
              name: name,
              phone: phone,
              createdAt: DateTime.now(),
            );

            orderCubit.setCustomer(createdCustomer);

            if (addressCubit.addresses.isNotEmpty) {
              final savedAddress = addressCubit.addresses.last;
              addressCubit.selectAddress(savedAddress);
              orderCubit.setAddress(savedAddress);

              setState(() {
                customerFound = true;
                customerName = name;
                customerPhoneController.text = phone;
                customerAddressValue = savedAddress.address;
                customerAddressController.text = savedAddress.address;
                phoneErrorText = null;
              });
            }
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
      customerAddressValue = cubit.customerAddress ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();

    // نوع الطلب: تيك أواي (لا يتطلب حقول إضافية)
    if (widget.orderTypeIndex == 0) {
      return const SizedBox.shrink();
    }

    // نوع الطلب: صالة (إظهار حقول واختيار الطاولات)
    if (widget.orderTypeIndex == 1) {
      return _buildDineInFields(cubit);
    }

    // نوع الطلب: دليفري (إظهار حقول البحث عن العميل ورقم الهاتف)
    return _buildDeliveryFields();
  }

  // بناء حقول الطلب الداخلي (صالة)
  Widget _buildDineInFields(OrderCubit cubit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, left: 4, right: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
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
                color: colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "بيانات الطاولة",
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Tooltip(
            message: "Ctrl + T - اختيار الطاولة",
            waitDuration: const Duration(milliseconds: 300),
            child: DropdownButtonFormField<String>(
              value: cubit.tableNumber ?? "طاولة 1",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.background,
                prefixIcon: Icon(
                  Iconss.tableBar,
                  color: colorScheme.primary,
                  size: 20,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
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
          ),
        ],
      ),
    );
  }

  // بناء حقول التوصيل (دليفري)
  Widget _buildDeliveryFields() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.only(top: 12, left: 4, right: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
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
              hint: "أدخل رقم الهاتف (11 رقم) واضغط Enter",
              icon: Iconss.phone,
              onChanged: (val) {
                if (val.trim().length == 11 && phoneErrorText != null) {
                  setState(() {
                    phoneErrorText = null;
                  });
                }
              },
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

  // حقل إدخال رقم الهاتف المدمج مع زر البحث وعرض العناوين
  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
    VoidCallback? onSubmitted,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customer = context.read<OrderCubit>().selectedCustomer;

    return Tooltip(
      message: "Ctrl + P - البحث عن عميل",
      waitDuration: const Duration(milliseconds: 300),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: (_) {
          if (onSubmitted != null) {
            onSubmitted();
          }
        },
        keyboardType: TextInputType.phone,
        textDirection: TextDirection.ltr,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          errorText: phoneErrorText,
          suffixIcon: customerFound && customer != null
              ? AddressPopup(
            customerId: customer.id!,
            onSelected: (address) {
              context.read<OrderCubit>().setAddress(address);
              setState(() {
                customerAddressValue = address.address;
                customerAddressController.text = address.address;
              });
            },
          )
              : null,
          hintText: hint,
          hintStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: colorScheme.primary,
          ),
          filled: true,
          fillColor: colorScheme.background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      ),
    );
  }

  // بطاقة عرض بيانات العميل المختصرة بعد العثور عليه
  Widget _buildCustomerCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
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
            height: 28,
            color: colorScheme.primary.withOpacity(0.2),
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
            height: 28,
            color: colorScheme.primary.withOpacity(0.2),
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
          Expanded(
            child: _buildLabeledValue(
              icon: Iconss.location,
              label: "العنوان",
              value: customerAddressValue.isNotEmpty ? customerAddressValue : "اختر العنوان",
              isHighlight: true,
            ),
          ),
        ],
      ),
    );
  }

  // عنصر مساعدة لعرض التسمية والقيمة داخل بطاقة العميل
  Widget _buildLabeledValue({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: isHighlight
                  ? colorScheme.primary
                  : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
            const SizedBox(width: 3),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 11,
            color: isHighlight
                ? colorScheme.primary
                : theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  // دالة البحث عن العميل برقم الهاتف في قاعدة البيانات
  Future<void> _searchCustomer() async {
    final phone = customerPhoneController.text.trim();

    if (phone.isEmpty) {
      setState(() {
        phoneErrorText = "برجاء إدخال رقم الهاتف";
      });
      return;
    }

    if (phone.length != 11) {
      setState(() {
        phoneErrorText = "رقم الهاتف يجب أن يكون 11 رقماً بالضبط";
      });
      return;
    }

    setState(() {
      phoneErrorText = null;
    });

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

        customerAddressValue = addressCubit.addresses.first.address;
        customerAddressController.text = addressCubit.addresses.first.address;
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

  // تحميل بيانات العميل المرتبطة بأوردر مفتوح تم إعادة فتحه
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
        customerAddressValue = address.address;
        customerAddressController.text = address.address;
      });
    }
  }
}