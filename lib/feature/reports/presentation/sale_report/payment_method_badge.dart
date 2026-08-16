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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color bg;
    Color color;
    IconData icon;

    switch (method.toLowerCase()) {
      case "cash":
        bg = Colors.green.withOpacity(0.1);
        color = Colors.green;
        icon = Icons.payments_outlined;
        break;

      case "visa":
        bg = colorScheme.primary.withOpacity(0.1);
        color = colorScheme.primary;
        icon = Icons.credit_card;
        break;

      case "wallet":
        bg = Colors.purple.withOpacity(0.1);
        color = Colors.purple;
        icon = Icons.account_balance_wallet_outlined;
        break;

      default:
        bg = colorScheme.outlineVariant;
        color = colorScheme.onSurface.withOpacity(0.5);
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
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}