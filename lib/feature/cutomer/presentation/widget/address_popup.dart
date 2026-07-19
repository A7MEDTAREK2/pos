import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/customer_model.dart';
import '../../logic/customer_cubit.dart';
import '../../logic/customer_state.dart';
import 'address.dart';

class AddressPopup extends StatelessWidget {
  final int customerId;
  final Function(CustomerAddressModel) onSelected;

  // ====== متغيرات التحكم في الـ UI ======
  final Color primaryTextColor = Colors.blue;
  final Color secondaryTextColor = Colors.grey;
  final Color backgroundColor = Colors.white;
  final double titleFontSize = 16.0;
  final double normalFontSize = 14.0;
  final double popupElevation = 8.0;
  final double popupBorderRadius = 12.0;
  final String addNewAddressText = "إضافة عنوان جديد";

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
          elevation: popupElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(popupBorderRadius),
          ),
          color: backgroundColor,
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
                            Icons.location_on,
                            size: 18,
                            color: primaryTextColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            address.title ?? "بدون عنوان",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize,
                              color: primaryTextColor,
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
                              style: TextStyle(
                                fontSize: normalFontSize,
                                color: secondaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              address.address,
                              style: TextStyle(
                                fontSize: normalFontSize,
                                color: secondaryTextColor,
                              ),
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
                      Icons.add_location_alt,
                      color: primaryTextColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      addNewAddressText,
                      style: TextStyle(
                        fontSize: normalFontSize,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                      ),
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
              color: Colors.grey.shade200,
            ),
            child: const Icon(
              Icons.keyboard_arrow_down,
              size: 26,
              color: Colors.blue,
            ),
          ),
        );
      },
    );
  }
}