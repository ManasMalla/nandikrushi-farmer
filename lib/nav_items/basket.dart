// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code needed to draw the basket screen

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/product/address_bottom_sheet.dart';
import 'package:nandikrushi_farmer/product/product_card.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/loader_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      return Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.background,
                toolbarHeight: kToolbarHeight,
                elevation: 0,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.shopping_basket_rounded,
                    )),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      'Basket',
                      size: Theme.of(context).textTheme.titleMedium?.fontSize,
                      weight: FontWeight.w700,
                    ),
                    productProvider.cart.isNotEmpty
                        ? TextWidget(
                            '${productProvider.cart.length} items',
                            size:
                                Theme.of(context).textTheme.bodySmall?.fontSize,
                            weight: FontWeight.w500,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              body: productProvider.cart.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// The seperator builder that draws each card in the basket
                          ListView.separated(
                            separatorBuilder: ((context, index) {
                              return const Divider();
                            }),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: productProvider.cart.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: ((context, index) {
                              return ProductCard(
                                  // verify: productProvider.cart[index]
                                  //         ["verify_seller"] ??
                                  //     "0",
                                  verify: true,
                                  type: CardType.product,
                                  productId: productProvider.cart[index]
                                          ["product_id"] ??
                                      "",
                                  productName:
                                      productProvider.cart[index]["name"] ?? "",
                                  productDescription: "",
                                  imageURL:
                                      productProvider.cart[index]["url"] ?? "",
                                  price: double.tryParse(productProvider
                                              .cart[index]["price"] ??
                                          "") ??
                                      0.0,
                                  units:
                                      "${(productProvider.cart[index]["quantity"] ?? "")} ${(productProvider.cart[index]["unit"] ?? "").replaceFirst("1", "")}${(productProvider.cart[index]["quantity"] ?? "") != "1" ? "s" : ""}",
                                  location: productProvider.cart[index]
                                          ["place"] ??
                                      "");
                            }),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16, left: 24, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  'Delivery Charge',
                                  weight: FontWeight.w500,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontSize,
                                ),
                                TextWidget(
                                  (4000 -
                                              (productProvider.cart
                                                  .map((e) =>
                                                      (double.tryParse(
                                                              e['price'] ??
                                                                  "0") ??
                                                          0) *
                                                      (double.tryParse(
                                                              e['quantity'] ??
                                                                  "0") ??
                                                          0))
                                                  .reduce(
                                                    (value, element) =>
                                                        value + element,
                                                  ))) <=
                                          0
                                      ? 'N/A'
                                      : 'Rs. 100.00',
                                  weight: FontWeight.w600,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontSize,
                                ),
                              ],
                            ),
                          ),
                          (4000 -
                                      (productProvider.cart
                                          .map((e) =>
                                              (double.tryParse(
                                                      e['price'] ?? "0") ??
                                                  0) *
                                              (double.tryParse(
                                                      e['quantity'] ?? "0") ??
                                                  0))
                                          .reduce(
                                            (value, element) => value + element,
                                          ))) <=
                                  0
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 16),
                                  child: SizedBox(
                                    child: TextWidget(
                                      '!  Add items for Rs.${(4000 - (productProvider.cart.map((e) => (double.tryParse(e['price'] ?? "0") ?? 0) * (double.tryParse(e['quantity'] ?? "0") ?? 0)).reduce(
                                            (value, element) => value + element,
                                          ) + 100.00)).toStringAsFixed(2)} or more to avoid delivery charges',
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      size: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.fontSize,
                                      weight: FontWeight.bold,
                                      flow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                          const Divider(),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16, left: 24, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  'Total'.toUpperCase(),
                                  weight: FontWeight.w600,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontSize,
                                ),
                                TextWidget(
                                  'Rs. ${(productProvider.cart.map((e) => (double.tryParse(e['price'] ?? "0") ?? 0) * (double.tryParse(e['quantity'] ?? "0") ?? 0)).reduce(
                                        (value, element) => value + element,
                                      ) + 100.00).toStringAsFixed(2)}',
                                  weight: FontWeight.w700,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontSize,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16, left: 24, right: 24),
                              child: Consumer<ProfileProvider>(
                                  builder: (context, profileProvider, _) {
                                return ElevatedButtonWidget(
                                  borderRadius: 8,
                                  onClick: () {
                                    showAddressesBottomSheet(context,
                                        profileProvider, Theme.of(context));
                                  },
                                  height: 54,
                                  // borderRadius: 16,
                                  textStyle: FontWeight.bold,
                                  buttonName: "Confirm Order".toUpperCase(),
                                  trailingIcon: Icons.arrow_forward,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Image(
                                image: AssetImage(
                                    'assets/images/empty_basket.png')),
                            const SizedBox(
                              height: 20,
                            ),
                            TextWidget(
                              'Basket Is Empty',
                              weight: FontWeight.w800,
                              size: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.fontSize,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextWidget(
                              'Looks like you have no items in your shopping basket',
                              weight: FontWeight.w600,
                              flow: TextOverflow.visible,
                              align: TextAlign.center,
                              size: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 42),
                              child: ElevatedButtonWidget(
                                trailingIcon: Icons.add_rounded,
                                buttonName: 'Shop Items'.toUpperCase(),
                                textStyle: FontWeight.w800,
                                borderRadius: 8,
                                innerPadding: 0.03,
                                onClick: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const BasketScreen()));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
            profileProvider.shouldShowLoader
                ? LoaderScreen(profileProvider)
                : const SizedBox(),
          ],
        );
      });
    });
  }
}
