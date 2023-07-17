import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';

snackbar(BuildContext context, description,
    {bool isError = true, bool isMssg = true}) {
  final snackBar = SnackBar(
    backgroundColor: isError
        ? Theme.of(context).colorScheme.errorContainer
        : isMssg
            ? Theme.of(context).colorScheme.primary
            : null,
    content: TextWidget(description,
        color: isError
            ? Theme.of(context).colorScheme.onErrorContainer
            : Theme.of(context).colorScheme.onPrimary),
    action: SnackBarAction(
      textColor:
          isError ? Colors.white : Theme.of(context).colorScheme.onPrimary,
      label: 'Close',
      onPressed: () {},
    ),
  );

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
