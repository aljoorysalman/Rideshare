import 'package:flutter/material.dart';
import 'package:rideshare/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;               
  final VoidCallback onPressed;    
  final Color? color;              
  final Color? textColor;          
  final bool isFullWidth;          // NEW
  final double borderRadius;       // NEW
  final EdgeInsetsGeometry? padding; // NEW

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.isFullWidth = true,          // default normal behavior
    this.borderRadius = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,   // <-- shrink if false
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
