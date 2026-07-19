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
    Color background;
    Color foreground;
    IconData icon;

    switch (type) {
      case "دليفري":
        background = const Color(0xFFDBEAFE);
        foreground = const Color(0xFF2563EB);
        icon = Icons.delivery_dining;
        break;

      case "داخل المطعم":
        background = const Color(0xFFDCFCE7);
        foreground = const Color(0xFF16A34A);
        icon = Icons.table_restaurant;
        break;

      default:
        background = const Color(0xFFFFF7ED);
        foreground = const Color(0xFFEA580C);
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
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}