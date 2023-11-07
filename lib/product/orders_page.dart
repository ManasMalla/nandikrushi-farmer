// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Orders Screen

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/product/product_card.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/loader_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  final Function onBack;
  const OrdersPage({Key? key, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onBack();
        return Future.value(false);
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              automaticallyImplyLeading: false,
              toolbarHeight: kToolbarHeight,
              elevation: 0,
              // actions: [
              //   PopupMenuButton(
              //       offset: const Offset(-5, 0),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8)),
              //       icon: const Icon(
              //         Icons.sort_rounded,
              //       ),
              //       itemBuilder: (context) {
              //         Sort sort = Sort.name;
              //         Filter filter = Filter.accepted;
              //         return [
              //           PopupMenuItem(child: StatefulBuilder(
              //             builder: (context, setMenuState) {
              //               return Column(
              //                 children: [
              //                   const PopupMenuItem(child: Text("Sort by")),
              //                   PopupMenuItem(
              //                       child: Column(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: [
              //                       Row(
              //                         children: [
              //                           Radio<Sort>(
              //                               activeColor: Theme.of(context)
              //                                   .colorScheme
              //                                   .primary,
              //                               value: Sort.name,
              //                               groupValue: sort,
              //                               onChanged: (_) {
              //                                 setMenuState(() {
              //                                   sort = _ ?? sort;
              //                                 });
              //                               }),
              //                           const SizedBox(width: 16),
              //                           const Icon(Icons.abc_rounded),
              //                           const SizedBox(width: 8),
              //                           const Text("Name")
              //                         ],
              //                       ),
              //                       Row(
              //                         children: [
              //                           Radio<Sort>(
              //                               activeColor: Theme.of(context)
              //                                   .colorScheme
              //                                   .primary,
              //                               value: Sort.date,
              //                               groupValue: sort,
              //                               onChanged: (_) {
              //                                 setMenuState(() {
              //                                   sort = _ ?? sort;
              //                                 });
              //                               }),
              //                           const SizedBox(width: 16),
              //                           const Icon(Icons.calendar_month_rounded),
              //                           const SizedBox(width: 8),
              //                           const Text("Date")
              //                         ],
              //                       ),
              //                     ],
              //                   )),
              //                   const PopupMenuItem(child: Text("Filter by")),
              //                   PopupMenuItem(
              //                       child: Column(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: [
              //                       Row(
              //                         children: [
              //                           Radio<Filter>(
              //                               activeColor: Theme.of(context)
              //                                   .colorScheme
              //                                   .primary,
              //                               value: Filter.accepted,
              //                               groupValue: filter,
              //                               onChanged: (_) {
              //                                 setMenuState(() {
              //                                   filter = _ ?? filter;
              //                                 });
              //                               }),
              //                           const SizedBox(width: 16),
              //                           const Icon(
              //                               Icons.check_circle_outline_rounded),
              //                           const SizedBox(width: 8),
              //                           const Text("Accepted")
              //                         ],
              //                       ),
              //                       Row(
              //                         children: [
              //                           Radio<Filter>(
              //                               activeColor: Theme.of(context)
              //                                   .colorScheme
              //                                   .primary,
              //                               value: Filter.pending,
              //                               groupValue: filter,
              //                               onChanged: (_) {
              //                                 setMenuState(() {
              //                                   filter = _ ?? filter;
              //                                 });
              //                               }),
              //                           const SizedBox(width: 16),
              //                           const Icon(Icons.pending_rounded),
              //                           const SizedBox(width: 8),
              //                           const Text("Pending")
              //                         ],
              //                       ),
              //                       Row(
              //                         children: [
              //                           Radio<Filter>(
              //                               activeColor: Theme.of(context)
              //                                   .colorScheme
              //                                   .primary,
              //                               value: Filter.cancelled,
              //                               groupValue: filter,
              //                               onChanged: (_) {
              //                                 setMenuState(() {
              //                                   filter = _ ?? filter;
              //                                 });
              //                               }),
              //                           const SizedBox(width: 16),
              //                           const Icon(Icons.cancel_outlined),
              //                           const SizedBox(width: 8),
              //                           const Text("Cancelled")
              //                         ],
              //                       ),
              //                     ],
              //                   )),
              //                 ],
              //               );
              //             },
              //           ))
              //         ];
              //       },
              //       onSelected: (value) {
              //         //
              //       }),
              // ],
              title: TextWidget(
                'Orders',
                size: Theme.of(context).textTheme.titleMedium?.fontSize,
                weight: FontWeight.w700,
              ),
            ),
            body: Consumer<ProductProvider>(
                builder: (context, productProvider, _) {
              //TODO: Handle the sort and filter logic
              return productProvider.orders.isEmpty
                  ? Column(children: [
                      Expanded(
                        child: Center(
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
                                  'Oops!',
                                  weight: FontWeight.w800,
                                  size: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.fontSize,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Opacity(
                                  opacity: 0.7,
                                  child: TextWidget(
                                    'Looks like you have not recieved any orders yet',
                                    flow: TextOverflow.visible,
                                    align: TextAlign.center,
                                    size: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.fontSize,
                                  ),
                                ),
                                // const SizedBox(
                                //   height: 40,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 42),
                                //   child: ElevatedButtonWidget(
                                //     trailingIcon: Icons.add_rounded,
                                //     buttonName: 'Order Now'.toUpperCase(),
                                //     textStyle: FontWeight.w800,
                                //     borderRadius: 8,
                                //     innerPadding: 0.03,
                                //     onClick: () {
                                //       productProvider.changeScreen(1);
                                //       Navigator.of(context).pop();
                                //     },
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ])
                  : ListView.separated(
                      itemBuilder: (context, itemIndex) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12)),
                          child: ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              separatorBuilder: (_, __) {
                                return const Divider();
                              },
                              itemCount: productProvider
                                  .orders[itemIndex]["products"].length,
                              itemBuilder: (context, productOrderIndex) {
                                var product = productProvider.orders[itemIndex]
                                    ["products"][productOrderIndex];
                                log(productProvider.orders.toString());
                                return ProductCard(
                                  disabled: false,
                                  index: itemIndex,
                                  verify: product?["verify_seller"] ?? "0",
                                  type: CardType.orders,
                                  productId: product["product_id"] ?? "XYZ",
                                  productName:
                                      product["product_name"] ?? "Name",
                                  productDescription:
                                      product["description"] ?? "Description",
                                  imageURL: product["url"] ??
                                      "https://img.etimg.com/thumb/msid-64411656,width-640,resizemode-4,imgsize-226493/cow-milk.jpg",
                                  price: double.tryParse(
                                          product["price"] ?? "00.00") ??
                                      00.00,
                                  units:
                                      "${product["quantity"]} ${product["units"]?.toString().replaceFirst("1", "") ?? " unit"}${(int.tryParse(product["quantity"]) ?? 1) > 1 ? "s" : ""}",
                                  location: product["place"] ?? "Visakhapatnam",
                                  poster: productProvider.orders[itemIndex]
                                      ["customer_name"],
                                  additionalInformation: {
                                    "date": DateFormat("EEE, MMM dd").format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            (int.tryParse(productProvider
                                                            .orders[itemIndex]
                                                        ["date"]) ??
                                                    0000000000) *
                                                1000)),
                                    "status": 0
                                  },
                                );
                              }),
                        );
                      },
                      separatorBuilder: (context, _) {
                        return const Divider();
                      },
                      itemCount: productProvider.orders.length);
            }),
          ),
          // Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
          //   return profileProvider.shouldShowLoader
          //       ? LoaderScreen(profileProvider)
          //       : const SizedBox();
          // })
        ],
      ),
    );
  }
}
