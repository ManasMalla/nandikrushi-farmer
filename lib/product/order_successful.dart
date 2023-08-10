// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Order Successful screen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_host.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../nav_items/profile_provider.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String name;
  final String deliverySlot;
  final String orderNumber;
  const OrderSuccessfulScreen(
      {Key? key,
      required this.name,
      required this.deliverySlot,
      required this.orderNumber})
      : super(key: key);

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            flex: 3,
            child: Image(
              image: AssetImage('assets/images/order_success.png'),
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFFEFE8CC),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  'Hi ${widget.name},',
                  weight: FontWeight.w800,
                  size: Theme.of(context).textTheme.titleLarge?.fontSize,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextWidget(
                  'Thank you for placing the order',
                  weight: FontWeight.w500,
                  size: Theme.of(context).textTheme.headlineSmall?.fontSize,
                  flow: TextOverflow.visible,
                ),
                TextWidget(
                  'Your fresh produce will be harvested soon',
                  size: Theme.of(context).textTheme.titleMedium?.fontSize,
                  flow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextWidget(
                  'Order Details',
                  weight: FontWeight.w800,
                  size: Theme.of(context).textTheme.titleSmall?.fontSize,
                ),
                const Divider(),
                TextWidget(
                  'Order ID: ${widget.orderNumber}\nDelivery Slot : ${widget.deliverySlot}',
                  size: Theme.of(context).textTheme.bodySmall?.fontSize,
                  flow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer<ProfileProvider>(
                    builder: (context, profileProvider, _) {
                  return Consumer<ProductProvider>(
                      builder: (context, productProvider, _) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16, left: 24, right: 24),
                      child: ElevatedButtonWidget(
                        borderRadius: 8,
                        onClick: () async {
                          profileProvider.showLoader();
                          productProvider.getCart(
                              showMessage: (_) {
                                snackbar(context, _, isError: false);
                              },
                              profileProvider: profileProvider);
                          productProvider.getOrders(
                              showMessage: (_) {
                                snackbar(context, _, isError: false);
                              },
                              profileProvider: profileProvider);

                          productProvider.changeScreen(0);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => NandikrushiNavHost(
                                    userId: FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        "",
                                    shouldUpdateField: false,
                                  )),
                            ),
                          );
                        },
                        height: 64,
                        textColor: Colors.white,
                        buttonName: "Home",
                        trailingIcon: Icons.arrow_forward,
                      ),
                    );
                  });
                }),
                const SizedBox(
                  height: 27,
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          )
        ],
      ),
    );
  }
}
