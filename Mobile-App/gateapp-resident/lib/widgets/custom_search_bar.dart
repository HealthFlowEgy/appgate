import 'package:flutter/material.dart';

import 'custom_card.dart';

class CustomSearchBar extends StatelessWidget {
  final String? hint;
  final Color? color;
  final Color? colorCard;
  final BoxShadow? boxShadow;
  final void Function(String?)? onSubmittedAuto;
  final void Function(String?)? onSubmittedForce;
  final void Function()? onTap;
  final bool readOnly, autofocus;
  final TextEditingController? editingController;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const CustomSearchBar({
    Key? key,
    this.hint,
    this.onTap,
    this.color,
    this.colorCard,
    this.boxShadow,
    this.onSubmittedAuto,
    this.onSubmittedForce,
    this.readOnly = false,
    this.autofocus = false,
    this.editingController,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return CustomCard(
      margin: margin,
      padding: padding,
      color: colorCard,
      child: TextField(
        controller: editingController,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: theme.primaryColor,
        readOnly: readOnly,
        decoration: InputDecoration(
          isDense: true,
          icon: Icon(
            Icons.search,
            color: theme.hintColor,
          ),
          hintText: hint,
          hintStyle: theme.textTheme.titleLarge!
              .copyWith(color: theme.hintColor, fontSize: 16),
          border: InputBorder.none,
        ),
        onChanged: onSubmittedAuto,
        onSubmitted: onSubmittedForce,
        onTap: onTap,
        autofocus: autofocus,
      ),
    );
  }
}
