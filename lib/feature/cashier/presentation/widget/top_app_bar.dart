import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../logic/pos_cubit.dart';

class PosTopAppBar extends StatelessWidget {
  const PosTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<OrderCubit>();
    final now = DateTime.now();
    final orderDate = cubit.currentOrder?.createdAt ?? now;
    final displayOrderNumber = cubit.currentOrder?.orderNumber ?? cubit.nextOrderNumber ?? 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffE5E7EB))),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colorsmanegments.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Iconss.arrowBack,
                size: 20,
                color: Colorsmanegments.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Text(
            "ModuPos",
            style: TxtStyle.titleLarge,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "أوردر رقم",
                style: TxtStyle.bodySmall,
              ),
              Text(
                "#$displayOrderNumber",
                style: TxtStyle.titleLarge.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Iconss.accessTime,
                    size: 16,
                    color: Colorsmanegments.grey,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    TimeOfDay.fromDateTime(orderDate).format(context),
                    style: TxtStyle.bodySmall,
                  ),
                  const SizedBox(width: 18),
                  Icon(
                    Iconss.calendar,
                    size: 16,
                    color: Colorsmanegments.grey,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${orderDate.day}/${orderDate.month}/${orderDate.year}",
                    style: TxtStyle.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}