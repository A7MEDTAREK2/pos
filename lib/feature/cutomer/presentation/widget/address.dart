// lib/feature/customer/presentation/widget/address.dart

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

// ============================================================
// CustomerAddressesSection
// ============================================================
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
  @override
  void initState() {
    super.initState();
    context.read<CustomerAddressCubit>().loadAddresses(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<CustomerAddressCubit, CustomerAddressState>(
        builder: (context, state) {
          final cubit = context.read<CustomerAddressCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== Header ======
              Row(
                children: [
                  Icon(
                    Iconss.location,
                    size: 18,
                    color: Colorsmanegments.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "العناوين",
                    style: TxtStyle.labelBold,
                  ),
                  const Spacer(),
                  if (!widget.selectable)
                    Tooltip(
                      message: "Ctrl + A - إضافة عنوان",
                      waitDuration: const Duration(milliseconds: 300),
                      child: TextButton.icon(
                        onPressed: () => _openAddressDialog(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(
                          Iconss.add,
                          size: 16,
                          color: Colorsmanegments.primary,
                        ),
                        label: Text(
                          "إضافة عنوان",
                          style: TxtStyle.buttonPrimary.copyWith(fontSize: 13),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              // ====== Empty State ======
              if (cubit.addresses.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colorsmanegments.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colorsmanegments.border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconss.locationOff,
                        color: Colorsmanegments.textSecondary,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "لا توجد عناوين مضافة لهذا العميل",
                        style: TxtStyle.bodySmall.copyWith(
                          color: Colorsmanegments.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

              // ====== Addresses List ======
              ...cubit.addresses.asMap().entries.map((entry) {
                final index = entry.key;
                final address = entry.value;
                final isSelected = widget.selectable &&
                    cubit.selectedAddress?.id == address.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Tooltip(
                    message: widget.selectable
                        ? "Ctrl + ${index + 1} - ${address.title ?? 'عنوان'}"
                        : "",
                    waitDuration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colorsmanegments.primaryLight
                            : Colorsmanegments.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colorsmanegments.primary
                              : Colorsmanegments.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: [
                          if (!isSelected)
                            BoxShadow(
                              color: Colorsmanegments.shadowLight,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: widget.selectable
                            ? () {
                          context
                              .read<CustomerAddressCubit>()
                              .selectAddress(address);
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
                                      ? Colorsmanegments.primary.withOpacity(0.12)
                                      : Colorsmanegments.background,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Iconss.location,
                                  size: 20,
                                  color: isSelected
                                      ? Colorsmanegments.primary
                                      : Colorsmanegments.textSecondary,
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
                                            style: TxtStyle.tableRowBold,
                                          ),
                                        ),
                                        if (address.isDefault) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colorsmanegments.success
                                                  .withOpacity(0.1),
                                              borderRadius:
                                              BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              "افتراضي",
                                              style: TxtStyle.badgeSmall.copyWith(
                                                color: Colorsmanegments.success,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      address.area,
                                      style: TxtStyle.bodySmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      address.address,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TxtStyle.bodySmall,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              // ====== Trailing Actions ======
                              if (widget.selectable)
                                if (isSelected)
                                  Icon(
                                    Iconss.check,
                                    color: Colorsmanegments.success,
                                    size: 22,
                                  )
                                else
                                  const SizedBox.shrink()
                              else
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!address.isDefault)
                                      Tooltip(
                                        message: "Ctrl + S - تعيين كافتراضي",
                                        waitDuration: const Duration(milliseconds: 300),
                                        child: IconButton(
                                          constraints: const BoxConstraints(),
                                          tooltip: "تعيين كافتراضي",
                                          icon: Icon(
                                            Iconss.star,
                                            size: 20,
                                            color: Colorsmanegments.warning,
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
                                      ),
                                    const SizedBox(width: 8),
                                    Tooltip(
                                      message: "Ctrl + E - تعديل",
                                      waitDuration: const Duration(milliseconds: 300),
                                      child: IconButton(
                                        constraints: const BoxConstraints(),
                                        tooltip: "تعديل",
                                        icon: Icon(
                                          Iconss.edit,
                                          size: 20,
                                          color: Colorsmanegments.primary,
                                        ),
                                        onPressed: () => _openAddressDialog(
                                          context,
                                          address: address,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Tooltip(
                                      message: "Delete - حذف",
                                      waitDuration: const Duration(milliseconds: 300),
                                      child: IconButton(
                                        constraints: const BoxConstraints(),
                                        tooltip: "حذف",
                                        icon: Icon(
                                          Iconss.delete,
                                          size: 20,
                                          color: Colorsmanegments.danger,
                                        ),
                                        onPressed: () {
                                          cubit.deleteAddress(
                                            address.id!,
                                            address.customerId,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // ====== Add Button (Selectable Mode) ======
              if (widget.selectable) ...[
                const SizedBox(height: 6),
                Tooltip(
                  message: "Ctrl + A - إضافة عنوان جديد",
                  waitDuration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openAddressDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colorsmanegments.primary,
                        side: BorderSide(color: Colorsmanegments.primary, width: 1.2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        Iconss.addLocation,
                        size: 20,
                        color: Colorsmanegments.primary,
                      ),
                      label: Text(
                        "إضافة عنوان جديد",
                        style: TxtStyle.buttonPrimary,
                      ),
                    ),
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

// ============================================================
// AddAddressDialog
// ============================================================
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
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final areaController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _areaFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _notesFocusNode = FocusNode();

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
    _titleFocusNode.dispose();
    _areaFocusNode.dispose();
    _addressFocusNode.dispose();
    _notesFocusNode.dispose();
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
      final newlyAdded = cubit.addresses.lastWhere(
            (element) => element.address == addressController.text.trim(),
        orElse: () => cubit.addresses.last,
      );

      cubit.selectAddress(newlyAdded);

      if (mounted) {
        try {
          context.read<OrderCubit>().setAddress(newlyAdded);
        } catch (_) {}
      }
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ====== Header ======
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colorsmanegments.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconss.addLocation,
                      color: Colorsmanegments.textWhite,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.address == null ? "إضافة عنوان جديد" : "تعديل العنوان",
                      style: TxtStyle.headerWhite.copyWith(fontSize: 16),
                    ),
                    const Spacer(),
                    Tooltip(
                      message: "Esc - إغلاق",
                      waitDuration: const Duration(milliseconds: 300),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Iconss.close,
                          color: Colorsmanegments.textWhite,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),

              // ====== Body ======
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
                          icon: Iconss.label,
                          focusNode: _titleFocusNode,
                          nextFocusNode: _areaFocusNode,
                          validator: (v) =>
                          v == null || v.isEmpty ? "برجاء إدخال اسم العنوان" : null,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: areaController,
                          label: "المنطقة",
                          icon: Iconss.map,
                          focusNode: _areaFocusNode,
                          nextFocusNode: _addressFocusNode,
                          validator: (v) =>
                          v == null || v.isEmpty ? "برجاء إدخال المنطقة" : null,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: addressController,
                          label: "العنوان بالتفصيل",
                          icon: Iconss.location,
                          focusNode: _addressFocusNode,
                          nextFocusNode: _notesFocusNode,
                          maxLines: 2,
                          validator: (v) =>
                          v == null || v.isEmpty ? "برجاء إدخال العنوان" : null,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: notesController,
                          label: "ملاحظات (اختياري)",
                          icon: Iconss.note,
                          focusNode: _notesFocusNode,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ====== Footer ======
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Tooltip(
                        message: "Esc - إلغاء",
                        waitDuration: const Duration(milliseconds: 300),
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(color: Colorsmanegments.border),
                            foregroundColor: Colorsmanegments.textSecondary,
                          ),
                          child: Text(
                            "إلغاء",
                            style: TxtStyle.buttonPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Tooltip(
                        message: "Enter - ${widget.address == null ? 'حفظ العنوان' : 'تحديث الآن'}",
                        waitDuration: const Duration(milliseconds: 300),
                        child: ElevatedButton(
                          onPressed: save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colorsmanegments.primary,
                            foregroundColor: Colorsmanegments.textWhite,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            widget.address == null ? "حفظ العنوان" : "تحديث الآن",
                            style: TxtStyle.buttonMedium,
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
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Tooltip(
      message: _getFieldTooltip(label),
      waitDuration: const Duration(milliseconds: 300),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        validator: validator,
        textDirection: TextDirection.rtl,
        style: TxtStyle.bodyMedium,
        onFieldSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            save();
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TxtStyle.labelMedium,
          prefixIcon: Icon(
            icon,
            size: 20,
            color: Colorsmanegments.primary,
          ),
          filled: true,
          fillColor: Colorsmanegments.background,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colorsmanegments.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colorsmanegments.primary,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colorsmanegments.danger,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colorsmanegments.danger,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  String _getFieldTooltip(String label) {
    switch (label) {
      case "اسم العنوان (مثال: المنزل، العمل)":
        return "Ctrl + 1 - اسم العنوان";
      case "المنطقة":
        return "Ctrl + 2 - المنطقة";
      case "العنوان بالتفصيل":
        return "Ctrl + 3 - العنوان بالتفصيل";
      case "ملاحظات (اختياري)":
        return "Ctrl + 4 - ملاحظات";
      default:
        return label;
    }
  }
}