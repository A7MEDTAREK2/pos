// lib/feature/customer/presentation/widget/address_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Customer ======
import '../../data/model/customer_model.dart';
import '../../logic/customer_cubit.dart';
import '../../logic/customer_state.dart';
import 'address.dart';

class AddressPopup extends StatelessWidget {
  final int customerId;
  final Function(CustomerAddressModel) onSelected;

  const AddressPopup({
    super.key,
    required this.customerId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerAddressCubit, CustomerAddressState>(
      builder: (context, state) {
        final cubit = context.read<CustomerAddressCubit>();

        return PopupMenuButton<dynamic>(
          offset: const Offset(0, 50),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colorsmanegments.card,
          itemBuilder: (context) {
            return [
              ...cubit.addresses.map(
                    (address) => PopupMenuItem(
                  value: address,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Iconss.location,
                            size: 18,
                            color: Colorsmanegments.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            address.title ?? "بدون عنوان",
                            style: TxtStyle.labelBold.copyWith(
                              color: Colorsmanegments.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.area,
                              style: TxtStyle.bodySmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              address.address,
                              style: TxtStyle.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const PopupMenuDivider(),

              PopupMenuItem(
                value: "add",
                child: Row(
                  children: [
                    Icon(
                      Iconss.addLocation,
                      color: Colorsmanegments.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "إضافة عنوان جديد",
                      style: TxtStyle.buttonPrimary,
                    ),
                  ],
                ),
              ),
            ];
          },
          onSelected: (value) async {
            if (value == "add") {
              showDialog(
                context: context,
                builder: (_) => AddAddressDialog(
                  customerId: customerId,
                ),
              );
              return;
            }

            final address = value as CustomerAddressModel;

            cubit.selectAddress(address);

            onSelected(address);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colorsmanegments.border,
            ),
            child: Icon(
              Iconss.arrowForward,
              size: 22,
              color: Colorsmanegments.primary,
            ),
          ),
        );
      },
    );
  }
}