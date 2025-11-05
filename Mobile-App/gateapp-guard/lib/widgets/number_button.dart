import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final String string;
  final Widget? child;
  final Function(String)? onTap;

  const NumberButton({Key? key, required this.string, this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onTap?.call(string),
        child: CircleAvatar(
          radius: 28,
          backgroundColor: (string.isNotEmpty || child != null)
              ? Theme.of(context).colorScheme.background
              : Colors.transparent,
          child: child ??
              Text(
                string,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 22),
              ),
        ),
      );
}
