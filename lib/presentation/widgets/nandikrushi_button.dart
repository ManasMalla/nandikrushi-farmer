import 'package:flutter/material.dart';

class NandikrushiButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final IconData trailingIcon;
  const NandikrushiButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Theme.of(context).colorScheme.primary,
      onPressed: onPressed,
      minWidth: double.infinity,
      height: 54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          Spacer(),
          Icon(
            trailingIcon,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
