// lib/feature/customer/presentation/screen/add_customer_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Cashier ======
import '../../../cashier/logic/pos_cubit.dart';

// ====== Customer ======
import '../../data/model/customer_model.dart';
import '../../logic/customer_cubit.dart';
import '../../logic/customer_state.dart';
import 'address.dart';
import 'customer_form.dart';

class AddCustomerScreen extends StatefulWidget {
  final CustomerModel? customer;

  const AddCustomerScreen({
    super.key,
    this.customer,
  });

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final areaController = TextEditingController();
  final notesController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _areaFocusNode = FocusNode();
  final FocusNode _notesFocusNode = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    areaController.dispose();
    notesController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    _areaFocusNode.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.customer != null) {
      nameController.text = widget.customer!.name;
      phoneController.text = widget.customer!.phone;
    }
  }

  void saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    final customer = CustomerModel(
      id: widget.customer?.id ?? 0,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      createdAt: widget.customer?.createdAt ?? DateTime.now(),
    );

    if (widget.customer == null) {
      final customerId = await context.read<CustomerCubit>().addCustomer(customer);

      if (customerId != null) {
        final newAddress = CustomerAddressModel(
          customerId: customerId,
          title: "المنزل",
          address: addressController.text.trim(),
          area: areaController.text.trim(),
          notes: notesController.text.trim(),
          isDefault: true,
          createdAt: DateTime.now(),
        );

        await context.read<CustomerAddressCubit>().addAddress(newAddress);

        final addressCubit = context.read<CustomerAddressCubit>();
        await addressCubit.loadAddresses(customerId);

        if (addressCubit.addresses.isNotEmpty) {
          final savedAddress = addressCubit.addresses.last;
          final orderCubit = context.read<OrderCubit>();
          final createdCustomer = customer.copyWith(id: customerId);
          orderCubit.setCustomer(createdCustomer);
          orderCubit.setAddress(savedAddress);
        }
      }
    } else {
      context.read<CustomerCubit>().updateCustomer(customer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is CustomerOperationSuccess) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          title: Text(
            widget.customer == null ? "إضافة عميل" : "تعديل العميل",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          leading: Tooltip(
            message: "Esc - رجوع",
            waitDuration: const Duration(milliseconds: 300),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Card(
                elevation: 4,
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomerForm(
                        nameController: nameController,
                        phoneController: phoneController,
                        addressController: addressController,
                        areaController: areaController,
                        notesController: notesController,
                        nameFocusNode: _nameFocusNode,
                        phoneFocusNode: _phoneFocusNode,
                        addressFocusNode: _addressFocusNode,
                        areaFocusNode: _areaFocusNode,
                        notesFocusNode: _notesFocusNode,
                      ),

                      if (widget.customer != null) ...[
                        const SizedBox(height: 30),
                        Divider(
                          color: theme.dividerColor,
                          thickness: 1.5,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Iconss.location,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "عناوين العميل",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        CustomerAddressesSection(
                          customerId: widget.customer!.id!,
                        ),
                      ],

                      const SizedBox(height: 30),

                      Tooltip(
                        message: "Enter - ${widget.customer == null ? 'إضافة العميل' : 'حفظ التعديلات'}",
                        waitDuration: const Duration(milliseconds: 300),
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: saveCustomer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              elevation: 4,
                              shadowColor: colorScheme.primary.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.customer == null
                                      ? Iconss.personAdd
                                      : Iconss.save,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  widget.customer == null
                                      ? "إضافة العميل"
                                      : "حفظ التعديلات",
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}