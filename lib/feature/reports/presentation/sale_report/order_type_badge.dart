import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderTypeBadge extends StatelessWidget {
  final String type;

  const OrderTypeBadge({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color background;
    Color foreground;
    IconData icon;

    switch (type) {
      case "دليفري":
        background = colorScheme.primary.withOpacity(0.1);
        foreground = colorScheme.primary;
        icon = Icons.delivery_dining;
        break;

      case "داخل المطعم":
        background = Colors.green.withOpacity(0.1);
        foreground = Colors.green;
        icon = Icons.table_restaurant;
        break;

      default:
        background = Colors.amber.withOpacity(0.1);
        foreground = Colors.amber;
        icon = Icons.shopping_bag_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: foreground,
          ),
          const SizedBox(width: 4),
          Text(
            type,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}