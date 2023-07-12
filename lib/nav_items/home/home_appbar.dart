import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:provider/provider.dart';

import '../../reusable_widgets/material_you_clipper.dart';
import '../../utils/size_config.dart';
import '../basket.dart';
import '../my_account.dart';
import '../notification_screen.dart';

PreferredSizeWidget homeAppBar(context, constraints) {
  return AppBar(
    surfaceTintColor: Theme.of(context).colorScheme.background,
    automaticallyImplyLeading: false,
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.background,
    title: Column(
      children: [
        Text(
          "Nandikrushi",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: "Samarkan",
                color: Theme.of(context).colorScheme.primary.withOpacity(
                    Theme.of(context).brightness == Brightness.dark ? 0.5 : 1),
              ),
        ),
        Text(
          "truly food is medicine",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.1 : 0.55),
              fontSize: getProportionateHeight(11, constraints),
              letterSpacing: 2.4),
        ),
      ],
    ),
    actions: [
      Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
        return IconButton(
          iconSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const NotificationScreen()));
          },
          icon: const Icon(Icons.notifications_on_outlined),
          color: Theme.of(context).colorScheme.primary.withOpacity(
              Theme.of(context).brightness == Brightness.dark
                  ? 0.5
                  : 1 * (profileProvider.notifications.isNotEmpty ? 1 : 0.5)),
        );
      }),
      Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return Stack(
          children: [
            IconButton(
              iconSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BasketScreen()));
              },
              icon: const Icon(Icons.shopping_basket_outlined),
              color: Theme.of(context).colorScheme.primary.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.5 : 1),
            ),
            Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  backgroundColor: productProvider.cart.length != 0
                      ? Colors.red
                      : Colors.transparent,
                  radius: 3,
                ))
          ],
        );
      }),
      const SizedBox(
        width: 8,
      ),
      Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
        return profileProvider.sellerImage.isNotEmpty ||
                profileProvider.storeLogo.isNotEmpty
            ? InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyAccountScreen()));
                },
                child: Center(
                  child: ClipPath(
                    clipper: MaterialClipper(),
                    child: Image.network(
                      profileProvider.sellerImage.isEmpty
                          ? profileProvider.storeLogo
                          : profileProvider.sellerImage,
                      height: (Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize ??
                              20) +
                          16,
                      width: (Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize ??
                              20) +
                          16,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : IconButton(
                iconSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyAccountScreen()));
                },
                icon: const Icon(Icons.account_circle_outlined),
                color: Theme.of(context).colorScheme.primary.withOpacity(
                    Theme.of(context).brightness == Brightness.dark ? 0.5 : 1),
              );
      }),
      const SizedBox(
        width: 16,
      ),
    ],
  );
}
