import 'package:flutter/material.dart';

class OutlinedNandikrushiButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final IconData? trailingIcon;

  const OutlinedNandikrushiButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: double.infinity,
      height: 40,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(54),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          trailingIcon != null ? Spacer() : SizedBox(),
          trailingIcon != null
              ? Icon(
                  trailingIcon,
                  color: Theme.of(context).colorScheme.primary,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
