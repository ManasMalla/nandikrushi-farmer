// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Product Card, refer to CardType enum for more information

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/my_account.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/product/product_page/product_page.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/rating_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/textfield_widget.dart';
import 'package:nandikrushi_farmer/utils/login_utils.dart';
import 'package:provider/provider.dart';

enum CardType {
  myProducts,
  orders,
  myPurchases,
  product,
}

class ProductCard extends StatefulWidget {
  final bool canTap;
  final CardType type;
  final String productId;
  final String productName;
  final String? productDescription;
  final String imageURL;
  final double price;
  final String units;
  final bool verify;
  final String? poster;
  final String location;
  final bool includeHorizontalPadding;
  final Map<String, dynamic> additionalInformation;
  final String? sellerMobile;
  final String? sellerMail;
  final int? index;
  final Function()? inStockFun;
  //final bool? isStockAvailable;
  ///[poster] - If its is product posted by farmer, then his details, or else the details of the person who gave order
  const ProductCard(
      {Key? key,
      required this.verify,
      this.sellerMobile,
      this.sellerMail,
      required this.type,
      required this.productId,
      required this.productName,
      this.productDescription,
      required this.imageURL,
      required this.price,
      required this.units,
      this.inStockFun,
      this.poster,
      this.index,
      required this.location,
      this.includeHorizontalPadding = true,
      this.additionalInformation = const {},
      this.canTap = true})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.canTap
          ? () {
              ProductProvider productProvider =
                  Provider.of(context, listen: false);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductPage(
                        product: productProvider.products
                            .where((e) =>
                                e.productId.toString() == widget.productId)
                            .first,
                      )));
            }
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: widget.includeHorizontalPadding ? 16 : 0, vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalize(widget.productName),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  widget.productDescription != null
                      ? SizedBox(
                          width: double.infinity,
                          child: TextWidget(
                            widget.productDescription,
                            flow: TextOverflow.ellipsis,
                          ),
                        )
                      : const SizedBox(),
                  Row(
                    children: [
                      Image.network(
                        widget.imageURL,
                        height: 64,
                        width: 64,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget("Rs. ${widget.price}"),
                            TextWidget(widget.units),
                            widget.poster != null
                                ? TextWidget(capitalize(
                                    widget.poster?.toLowerCase() ?? "User"))
                                : const SizedBox(),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded),
                                Expanded(
                                  child: TextWidget(
                                    widget.location,
                                    size: 12,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
              return Flexible(
                child: Column(
                  children: widget.type == CardType.product
                      ? [
                          //A product card for search, and suggestions page and basket
                          Consumer<ProductProvider>(
                              builder: (context, productProvider, _) {
                            return IntrinsicWidth(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  widget.verify
                                      ? productProvider.cart
                                              .where((e) =>
                                                  e["product_id"] ==
                                                  widget.productId)
                                              .isNotEmpty
                                          ? OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  minimumSize:
                                                      Size.zero, // Set this
                                                  padding: const EdgeInsets.all(
                                                      4), // and this
                                                  side: BorderSide(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100))),
                                              onPressed: () {
                                                productProvider
                                                    .modifyProductToCart(
                                                        context: context,
                                                        productID:
                                                            widget.productId,
                                                        onSuccessful: () =>
                                                            null,
                                                        showMessage: (_) {
                                                          snackbar(context, _);
                                                        },
                                                        profileProvider:
                                                            profileProvider);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.edit,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(
                                                      width: 6,
                                                    ),
                                                    TextWidget(
                                                        "Modify".toUpperCase(),
                                                        weight: FontWeight.bold,
                                                        size: Theme.of(context)
                                                            .textTheme
                                                            .button
                                                            ?.fontSize),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  minimumSize:
                                                      Size.zero, // Set this
                                                  padding: const EdgeInsets.all(
                                                      4), // and this
                                                  side: BorderSide(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100))),
                                              onPressed: () {
                                                productProvider
                                                    .addProductToCart(
                                                        context: context,
                                                        productID:
                                                            widget.productId,
                                                        onSuccessful: () =>
                                                            null,
                                                        showMessage: (_) {
                                                          snackbar(context, _);
                                                        },
                                                        profileProvider:
                                                            profileProvider);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.add,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(
                                                      width: 6,
                                                    ),
                                                    TextWidget(
                                                        "Add".toUpperCase(),
                                                        weight: FontWeight.bold,
                                                        size: Theme.of(context)
                                                            .textTheme
                                                            .button
                                                            ?.fontSize),
                                                  ],
                                                ),
                                              ),
                                            )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: Size.zero, // Set this
                                        padding:
                                            const EdgeInsets.all(4), // and this
                                        side: BorderSide(
                                          width: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100))),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(12))),
                                          builder: (context) {
                                            return Container(
                                              height: 250,
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Contact Us",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  TextWidget(
                                                    "Choose one of the following sources to get support",
                                                    flow: TextOverflow.visible,
                                                    size: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.fontSize,
                                                    weight: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.fontWeight,
                                                  ),
                                                  const Spacer(),
                                                  Row(
                                                    children: const [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Icon(
                                                            Icons.email_rounded,
                                                            size: 48),
                                                      ),
                                                      Spacer(),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Icon(
                                                            Icons.phone_rounded,
                                                            size: 48),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                          ),
                                                          onPressed: () async {
                                                            launchEmail(
                                                                mailID: widget
                                                                    .sellerMail
                                                                    .toString());
                                                          },
                                                          child: const Text(
                                                            "Email",
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Expanded(
                                                        flex: 3,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              foregroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary,
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8))),
                                                          onPressed: () async {
                                                            dialCall(
                                                                mobileNumber: widget
                                                                    .sellerMobile
                                                                    .toString());
                                                          },
                                                          child: const Text(
                                                              "Phone"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2),
                                      child: TextWidget(
                                        "Contact".toUpperCase(),
                                        size: Theme.of(context)
                                            .textTheme
                                            .button
                                            ?.fontSize,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ]
                      : widget.type == CardType.myProducts
                          ? [
                              //A product card for my products page
                              Text(
                                  'Posted on:\n${widget.additionalInformation["date"]}'),
                              const SizedBox(height: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: Size.zero, // Set this
                                    padding:
                                        const EdgeInsets.all(4), // and this
                                    side: BorderSide(
                                      width: 1,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100))),
                                onPressed: widget.inStockFun,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2),
                                  child: TextWidget(
                                    (widget.additionalInformation["in_stock"]
                                                    .toString() ==
                                                "1"
                                            ? "In Stock"
                                            : "Out of Stock")
                                        .toUpperCase(),
                                    size: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.fontSize,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ]
                          : widget.type == CardType.myPurchases
                              ? [
                                  Text(
                                      'Order placed on: ${widget.additionalInformation["date"]}'),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: FixedRatingStar(
                                            value: widget.additionalInformation[
                                                        "rating"] <
                                                    0.5
                                                ? 0
                                                : widget.additionalInformation[
                                                            "rating"] ==
                                                        0.5
                                                    ? 0.5
                                                    : 1),
                                      ),
                                      Flexible(
                                        child: FixedRatingStar(
                                            value: widget.additionalInformation[
                                                        "rating"] <
                                                    1.5
                                                ? 0
                                                : widget.additionalInformation[
                                                            "rating"] ==
                                                        1.5
                                                    ? 0.5
                                                    : 1),
                                      ),
                                      Flexible(
                                        child: FixedRatingStar(
                                            value: widget.additionalInformation[
                                                        "rating"] <
                                                    2.5
                                                ? 0
                                                : widget.additionalInformation[
                                                            "rating"] ==
                                                        2.5
                                                    ? 0.5
                                                    : 1),
                                      ),
                                      Flexible(
                                        child: FixedRatingStar(
                                            value: widget.additionalInformation[
                                                        "rating"] <
                                                    3.5
                                                ? 0
                                                : widget.additionalInformation[
                                                            "rating"] ==
                                                        3.5
                                                    ? 0.5
                                                    : 1),
                                      ),
                                      Flexible(
                                        child: FixedRatingStar(
                                            value: widget.additionalInformation[
                                                        "rating"] <
                                                    4.5
                                                ? 0
                                                : widget.additionalInformation[
                                                            "rating"] ==
                                                        4.5
                                                    ? 0.5
                                                    : 1),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextWidget(
                                    "Buy Again".toString().toUpperCase(),
                                    size: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.fontSize,
                                    weight: FontWeight.bold,
                                  ),
                                  //A product card for my purchases page
                                ]
                              : [
                                  Text(
                                      'Delivery order by: ${widget.additionalInformation["date"]}'),
                                  const SizedBox(height: 8),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: Size.zero, // Set this
                                        padding:
                                            const EdgeInsets.all(4), // and this
                                        side: BorderSide(
                                          width: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100))),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          builder: (context) {
                                            return Container(
                                              height: 250,
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Contact Us",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  TextWidget(
                                                    "Choose one of the following sources to get support",
                                                    flow: TextOverflow.visible,
                                                    size: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.fontSize,
                                                    weight: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.fontWeight,
                                                  ),
                                                  const Spacer(),
                                                  Row(
                                                    children: const [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Icon(
                                                            Icons.email_rounded,
                                                            size: 48),
                                                      ),
                                                      Spacer(),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Icon(
                                                            Icons.phone_rounded,
                                                            size: 48),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                          ),
                                                          onPressed: () async {
                                                            launchEmail();
                                                          },
                                                          child: const Text(
                                                            "Email",
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Expanded(
                                                        flex: 3,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              foregroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary,
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8))),
                                                          onPressed: () async {
                                                            dialCall();
                                                          },
                                                          child: const Text(
                                                              "Phone"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2),
                                      child: TextWidget(
                                        "Contact".toUpperCase(),
                                        size: Theme.of(context)
                                            .textTheme
                                            .button
                                            ?.fontSize,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Consumer<ProductProvider>(
                                      builder: (context, productProvider, _) {
                                    return productProvider.orders[widget.index!]
                                                ["order_status"] ==
                                            "1"
                                        ? Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    dynamic body = {
                                                      "order_id":
                                                          productProvider
                                                                      .orders[
                                                                  widget.index!]
                                                              ["order_id"],
                                                      "order_status_id": "8"
                                                    };
                                                    productProvider.rejectOrder(
                                                        context,
                                                        profileProvider:
                                                            profileProvider,
                                                        body: body);
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    dynamic body = {
                                                      "order_id":
                                                          productProvider
                                                                      .orders[
                                                                  widget.index!]
                                                              ["order_id"],
                                                      "order_status_id": "2"
                                                    };
                                                    productProvider.acceptOrder(
                                                        context,
                                                        profileProvider:
                                                            profileProvider,
                                                        body: body);
                                                  },
                                                  icon: Icon(
                                                    Icons.done,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ))
                                            ],
                                          )
                                        : TextWidget(
                                            productProvider.orders[
                                                            widget.index!]
                                                        ["order_status"] ==
                                                    "2"
                                                ? "Order Accepted".toUpperCase()
                                                : productProvider.orders[
                                                                widget.index!]
                                                            ["order_status"] ==
                                                        "8"
                                                    ? "Order Cancelled"
                                                    : "".toUpperCase(),
                                            size: Theme.of(context)
                                                .textTheme
                                                .button
                                                ?.fontSize,
                                            weight: FontWeight.bold,
                                          );
                                  }),
                                  //A product card for orders page
                                ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// instockTestField(BuildContext context) {
//   return
//    showDialog(
//                                       context: context,
//                                       builder: (context) {
//                                         return Center(
//                                           child: Container(
//                                             margin: const EdgeInsets.symmetric(
//                                                 horizontal: 32),
//                                             padding: const EdgeInsets.all(24),
//                                             decoration: BoxDecoration(
//                                                 color: Theme.of(context)
//                                                     .colorScheme
//                                                     .surface,
//                                                 borderRadius:
//                                                     BorderRadius.circular(12)),
//                                             child: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 TextFieldWidget(
//                                                   controller: loginPageController
//                                                           .registrationPageFormControllers[
//                                                       'house_number'],
//                                                   label: 'H.No.',
//                                                   validator: (value) {
//                                                     if (value?.isEmpty ??
//                                                         false) {
//                                                       return snackbar(context,
//                                                           "Please enter a valid house number");
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       });
// }
