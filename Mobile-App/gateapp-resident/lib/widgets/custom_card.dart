import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final VoidCallback? onTap;
  final Color? color;

  const CustomCard({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: margin ?? const EdgeInsets.only(bottom: 12),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                color: const Color(0xff999999).withOpacity(0.1),
              ),
            ],
          ),
          child: child,
        ),
      );
}
