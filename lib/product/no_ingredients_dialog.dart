import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/search.dart';

import '../reusable_widgets/elevated_button.dart';

class NoIngredientsDialog extends StatefulWidget {
  const NoIngredientsDialog({super.key});

  @override
  State<NoIngredientsDialog> createState() => _NoIngredientsDialogState();
}

class _NoIngredientsDialogState extends State<NoIngredientsDialog> {
  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFfffced),
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Image.asset(
              "assets/images/empty_basket.png",
              height: 80,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              "No Ingredients",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              "Looks like you haven't purchased anything from the farmers",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButtonWidget(
                bgColor: Theme.of(context).colorScheme.primary,
                trailingIcon: Icons.add_rounded,
                buttonName: 'Purchase Ingredients'.toUpperCase(),
                textColor: Theme.of(context).colorScheme.onPrimary,
                textStyle: FontWeight.w800,
                borderRadius: 8,
                onClick: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
