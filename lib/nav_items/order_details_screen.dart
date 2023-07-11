// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Order Details Screen which is displayed an order is tapped in Orders Screen

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/product/product_page/product_page.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var currentStep = 1;

    return LayoutBuilder(builder: (context, constraints) {
      height(context) {
        return constraints.maxHeight;
      }

      return Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            toolbarHeight: kToolbarHeight + 30,
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Order #${widget.order["order_id"]}'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(letterSpacing: 5),
              ),
              Text(
                DateFormat("EEE, MMM dd").format(
                    DateTime.fromMillisecondsSinceEpoch(
                        (int.tryParse(widget.order["date"]) ?? 0000000000) *
                            1000)),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey, letterSpacing: 2.5),
              )
            ]),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.download_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async{
                productProvider.getMyPurchases(showMessage: (_){}, profileProvider: Provider.of<ProfileProvider>(context));
            },
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFFEFE8CC),
                  child: Stepper(
                    steps: [
                      Step(
                          title: const TextWidget(
                            'Order Placed',
                            weight: FontWeight.bold,
                            color: Color.fromARGB(255, 85, 78, 49),
                          ),
                          content: SizedBox(height: 0),
                          subtitle: Text(
                            DateFormat("EEE, MMM dd").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    (int.tryParse(widget.order["date"]) ??
                                            0000000000) *
                                        1000)),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    color: Color.fromARGB(255, 192, 183, 147),
                                    letterSpacing: 2.5),
                          ),
                          isActive: currentStep > 0,
                          state: currentStep > 0
                              ? StepState.complete
                              : StepState.indexed),
                      Step(
                          title: const TextWidget(
                            'Order Accepted',
                            weight: FontWeight.bold,
                          ),
                          content: const SizedBox(),
                          isActive: currentStep > 1,
                          state: currentStep > 1
                              ? StepState.complete
                              : StepState.indexed),
                      Step(
                          title: const TextWidget(
                            'Order Shipped',
                            weight: FontWeight.bold,
                          ),
                          content: const SizedBox(),
                          isActive: currentStep > 2,
                          state: currentStep > 2
                              ? StepState.complete
                              : StepState.indexed),
                      Step(
                          title: const TextWidget(
                            'Order Delivered',
                            weight: FontWeight.bold,
                          ),
                          content: const SizedBox(),
                          isActive: currentStep > 3,
                          state: currentStep > 3
                              ? StepState.complete
                              : StepState.indexed),
                    ],
                    controlsBuilder: (context, _) {
                      return const SizedBox(
                        height: 0,
                        width: 0,
                      );
                    },
                    currentStep: currentStep,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        'Order\nInformation'.toUpperCase(),
                        weight: FontWeight.bold,
                        size: 18,
                        lSpace: 5,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: widget.order["products"].length,
                            itemBuilder: (context, index) {
                              var item = widget.order["products"][index];
                              return InkWell(
                                onTap: () {
                                  if (productProvider.products
                                      .where((element) =>
                                          element["product_id"] ==
                                          item["product_id"])
                                      .isNotEmpty) {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ProductPage(
                                            productDetails: productProvider
                                                .products
                                                .firstWhere((element) =>
                                                    element["product_id"] ==
                                                    item["product_id"]))));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          '${item['product_name']} x ${item['quantity']}',
                                          weight: FontWeight.w500,
                                          size: height(context) * 0.02,
                                        ),
                                        TextWidget(
                                          "${item["quantity"]} ${item["units"]?.toString().replaceFirst("1", "") ?? " unit"}${(int.tryParse(item["quantity"]) ?? 1) > 1 ? "s" : ""}",
                                          size: height(context) * 0.017,
                                        ),
                                      ],
                                    ),
                                    TextWidget(
                                      "Rs. ${((double.tryParse(item['price'] ?? "0") ?? 0) * (double.tryParse(item['quantity'] ?? "0") ?? 0)).toStringAsFixed(2)}",
                                      size: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.fontSize,
                                      weight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                    letterSpacing: 2.5),
                          ),
                          TextWidget(
                            'Rs. ${(widget.order["products"].map((e) => (double.tryParse(e['price'] ?? "0") ?? 0) * (double.tryParse(e['quantity'] ?? "0") ?? 0)).reduce(
                                  (value, element) => value + element,
                                )).toStringAsFixed(2)}',
                            weight: FontWeight.w700,
                            size: height(context) * 0.022,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            'Delivery Charge',
                            size: height(context) * 0.022,
                          ),
                          TextWidget(
                            'Rs. 100.00',
                            weight: FontWeight.w700,
                            size: height(context) * 0.022,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      letterSpacing: 5),
                            ),
                            TextWidget(
                              'Rs. ${(widget.order["products"].map((e) => (double.tryParse(e['price'] ?? "0") ?? 0) * (double.tryParse(e['quantity'] ?? "0") ?? 0)).reduce(
                                    (value, element) => value + element,
                                  ) + 100).toStringAsFixed(2)}',
                              weight: FontWeight.w700,
                              size: height(context) * 0.022,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 24,
                      ),
                      TextWidget(
                        'Payment\nInformation'.toUpperCase(),
                        color: Colors.grey.shade800,
                        weight: FontWeight.w700,
                        size: height(context) * 0.022,
                        height: 2,
                        lSpace: 5,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextWidget(
                        'Payment Method',
                        weight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        size: height(context) * 0.02,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            widget.order["products"][0]["payment_method"],
                            size: height(context) * 0.02,
                          ),
                          TextWidget(
                            'To Be Paid',
                            color: Theme.of(context).colorScheme.primary,
                            weight: FontWeight.w700,
                            size: height(context) * 0.02,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 8,
                      ),
                      TextWidget(
                        'Deliver to',
                        color: Colors.grey.shade800,
                        weight: FontWeight.w700,
                        size: height(context) * 0.02,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "${widget.order["products"][0]["shipping_firstname"]} ${widget.order["products"][0]["shipping_lastname"]}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(widget.order["products"][0]["shipping_house_number"]),
                      Text(widget.order["products"][0]["shipping_address_1"]),
                      Text(widget.order["products"][0]["shipping_address_2"]),
                      Text(widget.order["products"][0]["shipping_city"]),
                      Text(widget.order["products"][0]["shipping_zone"]),
                      Text(widget.order["products"][0]["shipping_country"]),
                      Text(
                          "Pincode: ${widget.order["products"][0]["shipping_postcode"]}"),
                      Text(
                          "Contact Number: ${widget.order["products"][0]["telephone"]}"),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          TextWidget(
                            'Chosen Delivery Slot',
                            color: Colors.grey.shade800,
                            weight: FontWeight.w700,
                            size: height(context) * 0.02,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: TextWidget(
                              'Change',
                              color: Colors.red,
                              weight: FontWeight.w700,
                              size: height(context) * 0.02,
                            ),
                          )
                        ],
                      ),
                      TextWidget(
                        '${DateFormat("EEE, MMM dd yyyy").format(DateTime.fromMillisecondsSinceEpoch((int.tryParse(widget.order["date"]) ?? 0000000000) * 1000))} ${widget.order["time"]}',
                        color: Colors.grey,
                        size: height(context) * 0.02,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red, width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {},
                        child: TextWidget(
                          'Cancel Order'.toUpperCase(),
                          color: Colors.red,
                          weight: FontWeight.w700,
                          size: height(context) * 0.02,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
          ),
        );
      });
    });
  }
}
