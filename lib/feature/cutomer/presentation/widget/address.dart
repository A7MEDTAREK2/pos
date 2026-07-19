import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cashier/logic/pos_cubit.dart';
import '../../data/model/customer_model.dart';
import '../../logic/customer_cubit.dart';
import '../../logic/customer_state.dart';

class CustomerAddressesSection extends StatefulWidget {
  final ValueChanged<CustomerAddressModel>? onAddressSelected;
  final int customerId;
  final bool selectable;

  const CustomerAddressesSection({
    super.key,
    required this.customerId,
    this.selectable = false,
    this.onAddressSelected,
  });

  @override
  State<CustomerAddressesSection> createState() =>
      _CustomerAddressesSectionState();
}

class _CustomerAddressesSectionState extends State<CustomerAddressesSection> {
  static const Color _primary = Color(0xff2563EB);

  @override
  void initState() {
    super.initState();
    context.read<CustomerAddressCubit>().loadAddresses(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // ضمان اتجاه الواجهة بالكامل للعربية
      child: BlocBuilder<CustomerAddressCubit, CustomerAddressState>(
        builder: (context, state) {
          final cubit = context.read<CustomerAddressCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= Header =================
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18, color: _primary),
                  const SizedBox(width: 6),
                  const Text(
                    "العناوين",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (!widget.selectable)
                    TextButton.icon(
                      onPressed: () => _openAddressDialog(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text("إضافة عنوان", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              // ================= Empty State =================
              if (cubit.addresses.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xffE5E7EB)),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_off_outlined, color: Colors.grey, size: 28),
                      SizedBox(height: 8),
                      Text(
                        "لا توجد عناوين مضافة لهذا العميل",
                        style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

              // ================= Addresses List =================
              ...cubit.addresses.map((address) {
                final isSelected =
                    widget.selectable && cubit.selectedAddress?.id == address.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xffEFF6FF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? _primary : const Color(0xffE5E7EB),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        if (!isSelected)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: widget.selectable
                          ? () {
                        context.read<CustomerAddressCubit>().selectAddress(address);
                        widget.onAddressSelected?.call(address);
                      }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _primary.withOpacity(.12)
                                    : const Color(0xffF8FAFC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.location_on,
                                size: 20,
                                color: isSelected ? _primary : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          address.title ?? "عنوان غير مسمى",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      if (address.isDefault) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            "افتراضي",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    address.area,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    address.address,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // ============ Trailing Actions ============
                            if (widget.selectable)
                              if (isSelected)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 22,
                                  ),
                                )
                              else
                                const SizedBox.shrink()
                            else
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!address.isDefault)
                                    IconButton(

                                      constraints: const BoxConstraints(),
                                      tooltip: "تعيين كافتراضي",
                                      icon: const Icon(
                                        Icons.star_border_rounded,
                                        size: 20,
                                        color: Colors.amber,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<CustomerAddressCubit>()
                                            .setDefaultAddress(
                                          address.id!,
                                          widget.customerId,
                                        );
                                      },
                                    ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    //padding: EdgeInsets.transparent,
                                    constraints: const BoxConstraints(),
                                    tooltip: "تعديل",
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                      color: _primary,
                                    ),
                                    onPressed: () =>
                                        _openAddressDialog(context, address: address),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    //padding: EdgeInsets.transparent,
                                    constraints: const BoxConstraints(),
                                    tooltip: "حذف",
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      cubit.deleteAddress(
                                        address.id!,
                                        address.customerId,
                                      );
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // ================= Add Button (Selectable Mode) =================
              if (widget.selectable) ...[
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openAddressDialog(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primary,
                      side: const BorderSide(color: _primary, width: 1.2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_location_alt_outlined, size: 20),
                    label: const Text("إضافة عنوان جديد", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _openAddressDialog(BuildContext context, {CustomerAddressModel? address}) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<CustomerAddressCubit>(),
        child: AddAddressDialog(
          customerId: widget.customerId,
          address: address,
        ),
      ),
    );
  }
}

class AddAddressDialog extends StatefulWidget {
  final int customerId;
  final CustomerAddressModel? address;

  const AddAddressDialog({
    super.key,
    required this.customerId,
    this.address,
  });

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  static const Color _primary = Color(0xff2563EB);

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final areaController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.address != null) {
      titleController.text = widget.address!.title ?? "";
      areaController.text = widget.address!.area;
      addressController.text = widget.address!.address;
      notesController.text = widget.address!.notes ?? "";
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    areaController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<CustomerAddressCubit>();

    final model = CustomerAddressModel(
      id: widget.address?.id,
      customerId: widget.customerId,
      title: titleController.text.trim(),
      area: areaController.text.trim(),
      address: addressController.text.trim(),
      notes: notesController.text.trim(),
      isDefault: widget.address?.isDefault ?? false,
      createdAt: DateTime.now(),
    );

    if (widget.address == null) {
      await cubit.addAddress(model);
    } else {
      await cubit.updateAddress(model);
    }

    await cubit.loadAddresses(widget.customerId);

    if (widget.address == null && cubit.addresses.isNotEmpty) {
      final newAddress = cubit.addresses.last;
      cubit.selectAddress(newAddress);

      if (mounted) {
        // تأكد من وجود الـ OrderCubit في الشجرة لتفادي الـ Crash
        try {
          context.read<OrderCubit>().setAddress(newAddress);
        } catch (_) {}
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ================= Header =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add_location_alt_outlined, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      widget.address == null ? "إضافة عنوان جديد" : "تعديل العنوان",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // ================= Body =================
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildField(
                          controller: titleController,
                          label: "اسم العنوان (مثال: المنزل، العمل)",
                          icon: Icons.label_outline,
                          validator: (v) =>
                          v == null || v.isEmpty ? "برجاء إدخال اسم العنوان" : null,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: areaController,
                          label: "المنطقة / الحي",
                          icon: Icons.map_outlined,
                          validator: (v) =>
                          v == null || v.isEmpty ? "برجاء إدخال المنطقة" : null,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: addressController,
                          label: "تفاصيل العنوان (الشارع، رقم المبنى...)",
                          icon: Icons.home_outlined,
                          maxLines: 2,
                          validator: (v) =>
                          v == null || v.isEmpty ? "برجاء إدخال تفاصيل العنوان" : null,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: notesController,
                          label: "ملاحظات إضافية (اختياري)",
                          icon: Icons.sticky_note_2_outlined,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ================= Footer =================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          foregroundColor: Colors.grey.shade700,
                        ),
                        child: const Text("إلغاء", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          widget.address == null ? "حفظ العنوان" : "تحديث الآن",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      textDirection: TextDirection.rtl, // لضبط الكتابة العربية والإنجليزية المختلطة بشكل صحيح
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        prefixIcon: Icon(icon, size: 20, color: _primary),
        filled: true,
        fillColor: const Color(0xffF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}