import 'package:flutter/material.dart';

class FixedRatingStar extends StatelessWidget {
  final double value;
  const FixedRatingStar({Key? key, this.value = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return value == 0
        ? Icon(
            Icons.star_outline_rounded,
            color: Colors.grey,
            size: Theme.of(context).textTheme.titleLarge?.fontSize,
          )
        : value == 1
            ? Icon(
                Icons.star_rounded,
                color: Colors.amber.shade800,
                size: Theme.of(context).textTheme.titleLarge?.fontSize,
              )
            : Icon(
                Icons.star_half_rounded,
                color: Colors.amber.shade800,
                size: Theme.of(context).textTheme.titleLarge?.fontSize,
              );
  }
}
