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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.watch<OrderCubit>();
    final now = DateTime.now();
    final orderDate = cubit.currentOrder?.createdAt ?? now;
    final displayOrderNumber = cubit.currentOrder?.orderNumber ?? cubit.nextOrderNumber ?? 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Tooltip(
            message: "Esc - الرجوع للخلف",
            waitDuration: const Duration(milliseconds: 300),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconss.arrowBack,
                  size: 20,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Text(
            "ModuPos",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "أوردر رقم",
                style: theme.textTheme.bodySmall,
              ),
              Text(
                "#$displayOrderNumber",
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Iconss.accessTime,
                    size: 16,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    TimeOfDay.fromDateTime(orderDate).format(context),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 18),
                  Icon(
                    Iconss.calendar,
                    size: 16,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${orderDate.day}/${orderDate.month}/${orderDate.year}",
                    style: theme.textTheme.bodySmall,
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