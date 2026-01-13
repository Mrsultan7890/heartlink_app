import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 56,
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor ?? AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? AppTheme.primaryColor).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        textColor ?? Colors.white,
                      ),
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: textColor ?? Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}