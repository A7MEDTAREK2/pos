import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  // ====== متغيرات التحكم في الـ UI ======
  final Color primaryColor = Colors.blue.shade700;
  final Color secondaryColor = Colors.grey.shade800;
  final Color backgroundColor = Colors.grey.shade50;
  final Color cardColor = Colors.white;
  final double cardElevation = 4.0;
  final double cardBorderRadius = 16.0;
  final double appBarElevation = 2.0;
  final double mainPadding = 24.0;
  final double fontSizeTitle = 22.0;
  final double fontSizeButton = 18.0;
  final String addCustomerTitle = "إضافة عميل";
  final String editCustomerTitle = "تعديل العميل";
  final String addButtonText = "إضافة العميل";
  final String editButtonText = "حفظ التعديلات";
  final String customerAddressesLabel = "عناوين العميل";

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
        await context.read<CustomerAddressCubit>().addAddress(
          CustomerAddressModel(
            customerId: customerId,
            title: "المنزل",
            address: addressController.text.trim(),
            area: areaController.text.trim(),
            notes: notesController.text.trim(),
            isDefault: true,
            createdAt: DateTime.now(),
          ),
        );
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
              content: Text(state.message),
              backgroundColor: Colors.green.shade700,
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
              content: Text(state.error),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: appBarElevation,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          title: Text(
            widget.customer == null ? addCustomerTitle : editCustomerTitle,
            style: TextStyle(
              fontSize: fontSizeTitle,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(mainPadding),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Card(
                elevation: cardElevation,
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                ),
                child: Padding(
                  padding: EdgeInsets.all(mainPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ====== نموذج العميل ======
                      CustomerForm(
                        nameController: nameController,
                        phoneController: phoneController,
                        addressController: addressController,
                        areaController: areaController,
                        notesController: notesController,
                      ),

                      // ====== قسم العناوين ======
                      if (widget.customer != null) ...[
                        const SizedBox(height: 30),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1.5,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              customerAddressesLabel,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
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

                      // ====== زر الحفظ ======
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: saveCustomer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: primaryColor.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                widget.customer == null
                                    ? Icons.person_add
                                    : Icons.save,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                widget.customer == null
                                    ? addButtonText
                                    : editButtonText,
                                style: TextStyle(
                                  fontSize: fontSizeButton,
                                  fontWeight: FontWeight.w600,
                                ),
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