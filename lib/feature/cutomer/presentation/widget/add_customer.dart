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

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    areaController.dispose();
    notesController.dispose();
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
    return BlocListener<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is CustomerOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TxtStyle.bodyMedium.copyWith(
                  color: Colorsmanegments.textWhite,
                ),
              ),
              backgroundColor: Colorsmanegments.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.pop(context);
        }

        if (state is CustomerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
                style: TxtStyle.bodyMedium.copyWith(
                  color: Colorsmanegments.textWhite,
                ),
              ),
              backgroundColor: Colorsmanegments.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colorsmanegments.background,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colorsmanegments.primary,
          foregroundColor: Colorsmanegments.textWhite,
          title: Text(
            widget.customer == null ? "إضافة عميل" : "تعديل العميل",
            style: TxtStyle.headerWhite.copyWith(fontSize: 22),
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
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
                color: Colorsmanegments.card,
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
                      ),

                      if (widget.customer != null) ...[
                        const SizedBox(height: 30),
                        Divider(
                          color: Colorsmanegments.border,
                          thickness: 1.5,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Iconss.location,
                              color: Colorsmanegments.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "عناوين العميل",
                              style: TxtStyle.titleCard,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        CustomerAddressesSection(
                          customerId: widget.customer!.id!,
                        ),
                      ],

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: saveCustomer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colorsmanegments.primary,
                            foregroundColor: Colorsmanegments.textWhite,
                            elevation: 4,
                            shadowColor: Colorsmanegments.primary.withOpacity(0.4),
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
                                style: TxtStyle.buttonMedium,
                              ),
                            ],
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