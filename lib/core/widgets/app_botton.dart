// lib/core/widgets/app_botton.dart

import 'package:flutter/material.dart';

import '../theming/colors manegments.dart';
import '../theming/txt_style.dart';

class AppBotton extends StatelessWidget {
  final double? width;
  final String txt;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const AppBotton({
    super.key,
    this.width,
    required this.txt,
    this.onTap,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isOutlined
        ? Colorsmanegments.transparent
        : backgroundColor ?? Colorsmanegments.primary;

    final Color txtColor = isOutlined
        ? textColor ?? Colorsmanegments.primary
        : textColor ?? Colorsmanegments.textWhite;

    final Color borderColor = isOutlined
        ? backgroundColor ?? Colorsmanegments.primary
        : Colorsmanegments.transparent;

    return SizedBox(
      width: width ?? double.infinity,
      height: 48,
      child: Material(
        color: Colorsmanegments.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor: Colorsmanegments.primary.withOpacity(0.1),
          highlightColor: Colorsmanegments.primary.withOpacity(0.05),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: borderColor,
                width: isOutlined ? 1.5 : 0,
              ),
              boxShadow: isOutlined
                  ? []
                  : [
                BoxShadow(
                  color: Colorsmanegments.primary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    txtColor,
                  ),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                      color: txtColor,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    txt,
                    style: TxtStyle.buttonMedium.copyWith(
                      color: txtColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}