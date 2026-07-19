// lib/core/widgets/cards.dart

import 'package:flutter/material.dart';

import '../theming/colors manegments.dart';
import '../theming/txt_style.dart';

class Cards extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isSelected;
  final EdgeInsetsGeometry? padding;

  const Cards({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.width,
    this.height,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.isSelected = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isSelected
        ? Colorsmanegments.primaryLight
        : backgroundColor ?? Colorsmanegments.card;

    final Color txtColor = isSelected
        ? Colorsmanegments.primary
        : textColor ?? Colorsmanegments.textPrimary;

    final Color borderColor = isSelected
        ? Colorsmanegments.primary
        : Colorsmanegments.border;

    return Material(
      color: Colorsmanegments.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colorsmanegments.primary.withOpacity(0.08),
        highlightColor: Colorsmanegments.primary.withOpacity(0.04),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colorsmanegments.primary.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
                : [
              BoxShadow(
                color: Colorsmanegments.blackOpacity10,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TxtStyle.titleSmall.copyWith(
                        color: txtColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TxtStyle.bodySmall.copyWith(
                          color: Colorsmanegments.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: Colorsmanegments.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}