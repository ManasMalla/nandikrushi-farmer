// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the My Purchases Screen

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nandikrushi_farmer/nav_items/order_details_screen.dart';
import 'package:nandikrushi_farmer/product/product_card.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/sort_filter.dart';
import 'package:provider/provider.dart';

class MyPurchasesScreen extends StatefulWidget {
  const MyPurchasesScreen({super.key});

  @override
  State<MyPurchasesScreen> createState() => _MyPurchasesScreenState();
}

class _MyPurchasesScreenState extends State<MyPurchasesScreen> {
  Sort sort = Sort.name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight,
        elevation: 0,
        actions: [
          PopupMenuButton(
              offset: const Offset(-5, 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              icon: const Icon(
                Icons.sort_rounded,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(child: StatefulBuilder(
                    builder: (context, setMenuState) {
                      return Column(
                        children: [
                          const PopupMenuItem(child: Text("Sort by")),
                          PopupMenuItem(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Radio<Sort>(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      value: Sort.name,
                                      groupValue: sort,
                                      onChanged: (_) {
                                        setMenuState(() {
                                          sort = _ ?? sort;
                                        });
                                      }),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.abc_rounded),
                                  const SizedBox(width: 8),
                                  const Text("Name")
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<Sort>(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      value: Sort.date,
                                      groupValue: sort,
                                      onChanged: (_) {
                                        setMenuState(() {
                                          sort = _ ?? sort;
                                        });
                                      }),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.calendar_month_rounded),
                                  const SizedBox(width: 8),
                                  const Text("Date")
                                ],
                              ),
                            ],
                          )),
                        ],
                      );
                    },
                  ))
                ];
              },
              onSelected: (value) {
                //
              }),
        ],
        title: TextWidget(
          'My Purchases',
          size: Theme.of(context).textTheme.titleMedium?.fontSize,
          weight: FontWeight.w700,
        ),
      ),
      body: Consumer<ProductProvider>(builder: (context, productProvider, _) {
        //TODO: Implement the sort logic
        return productProvider.myPurchases.isEmpty
            ? Column(children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Image(
                              image:
                                  AssetImage('assets/images/empty_basket.png')),
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
                              'Looks like you have not ordered anything yet',
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
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(
                                index: itemIndex,
                              )));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12)),
                      child: ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          separatorBuilder: (_, __) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child:
                                  Opacity(opacity: 0.2, child: const Divider()),
                            );
                          },
                          itemCount: productProvider
                              .myPurchases[itemIndex].productDetails.length,
                          itemBuilder: (context, productOrderIndex) {
                            var product = productProvider.myPurchases[itemIndex]
                                .productDetails[productOrderIndex];
                            return ProductCard(
                              disabled: product.disabled,
                              verify: true,
                              canTap: false,
                              type: CardType.myPurchases,
                              productId: product.productId.toString(),
                              productName: product.name,
                              productDescription: product.description,
                              imageURL: product.image,
                              price: product.price,
                              units:
                                  "${product.quantity} ${product.units.toString().replaceFirst("1", "")}${product.quantity > 1 ? "s" : ""}",
                              location: product.produceLocation,
                              poster: productProvider.myPurchases[itemIndex]
                                  .storeDetails[0].storeName,
                              additionalInformation: {
                                "date": DateFormat("EEE, MMM dd").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        (productProvider
                                                .myPurchases[itemIndex]
                                                .deliveryDetails[0]
                                                .deliveryDate) *
                                            1000)),
                                "status": 0,
                                "rating": product.aggregateRating,
                              },
                            );
                          }),
                    ),
                  );
                },
                separatorBuilder: (context, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Opacity(opacity: 0.2, child: const Divider()),
                  );
                },
                itemCount: productProvider.myPurchases.length);
      }),
    );
  }
}
