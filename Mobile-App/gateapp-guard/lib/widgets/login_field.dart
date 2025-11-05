import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool? readOnly;
  final Function()? onTap;

  const LoginField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.readOnly,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 15,
                  color: Theme.of(context).hintColor,
                ),
          ),
        if (label.isNotEmpty) const SizedBox(height: 4),
        TextFormField(
          onTap: onTap,
          readOnly: readOnly ?? false,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15),
          initialValue: initialValue,
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).hintColor.withOpacity(0.3),
              ),
            ),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).hintColor.withOpacity(0.5),
                ),
          ),
        ),
      ],
    );
  }
}
