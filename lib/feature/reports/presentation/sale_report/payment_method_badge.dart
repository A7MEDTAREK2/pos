import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodBadge extends StatelessWidget {
  final String method;

  const PaymentMethodBadge({
    super.key,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color color;
    IconData icon;

    switch (method.toLowerCase()) {
      case "cash":
        bg = const Color(0xFFDCFCE7);
        color = const Color(0xFF16A34A);
        icon = Icons.payments_outlined;
        break;

      case "visa":
        bg = const Color(0xFFDBEAFE);
        color = const Color(0xFF2563EB);
        icon = Icons.credit_card;
        break;

      case "wallet":
        bg = const Color(0xFFF3E8FF);
        color = const Color(0xFF7C3AED);
        icon = Icons.account_balance_wallet_outlined;
        break;

      default:
        bg = const Color(0xFFF3F4F6);
        color = Colors.grey;
        icon = Icons.payment;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            method,
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}