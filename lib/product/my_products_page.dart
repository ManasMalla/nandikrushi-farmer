// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the My Products Page

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/product/add_product.dart';
import 'package:nandikrushi_farmer/product/product_card.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/textfield_widget.dart';
import 'package:nandikrushi_farmer/utils/server.dart';
import 'package:provider/provider.dart';

import '../reusable_widgets/loader_screen.dart';
import 'my_product_page_app_bar.dart';

String getDayOfMonthSuffix(int dayNum) {
  if (!(dayNum >= 1 && dayNum <= 31)) {
    throw Exception('Invalid day of month');
  }

  if (dayNum >= 11 && dayNum <= 13) {
    return 'th';
  }

  switch (dayNum % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

class MyProductsPage extends StatelessWidget {
  const MyProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: myProductsPageAppBar(context),
      body: Stack(
        //TODO: Handle the sort and filter logic
        children: [
          Consumer<ProductProvider>(builder: (context, productProvider, _) {
            return productProvider.myProducts.isEmpty
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
                                productProvider.myProductsMessage,
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
                                opacity: 0.5,
                                child: TextWidget(
                                  'Looks like you have not added any of your item to our huge database of products',
                                  flow: TextOverflow.visible,
                                  align: TextAlign.center,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.fontSize,
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 42),
                                child: ElevatedButtonWidget(
                                  trailingIcon: Icons.add_rounded,
                                  buttonName: 'Add Product'.toUpperCase(),
                                  textStyle: FontWeight.w800,
                                  borderRadius: 8,
                                  innerPadding: 0.03,
                                  onClick: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AddProductScreen()));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ])
                : ListView.separated(
                    itemBuilder: (context, itemIndex) {
                      var product = productProvider.myProducts[itemIndex];
                      TextEditingController price =
                          TextEditingController(text: product["price"]);
                      TextEditingController qunatity =
                          TextEditingController(text: product["quantity"]);
                      TextEditingController description =
                          TextEditingController(text: product["description"]);
                      return InkWell(
                        onLongPress: () {
                          log("129");
                          log(product.toString());
                          log("131");
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            color: Colors.red.shade200,
                                            child: const Icon(Icons.delete),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                          "Delete Product",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        const Text(
                                          "Confirm to delete the product. \nNote, this change can't be reverted.",
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        ElevatedButtonWidget(
                                          buttonName: "Cancel",
                                          trailingIcon: Icons.delete,
                                          bgColor: Colors.transparent,
                                          textColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          borderSideColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          borderRadius: 12,
                                          onClick: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Consumer<ProfileProvider>(builder:
                                            (context, profileProvider, _) {
                                          return ElevatedButtonWidget(
                                            borderRadius: 12,
                                            buttonName: "Delete",
                                            trailingIcon: Icons.delete,
                                            bgColor: Colors.red.shade400,
                                            onClick: () async {
                                              // Navigator.of(context).pop();
                                              // snackbar(context,
                                              //     "Feature coming soon!");
                                              profileProvider.showLoader();
                                              var response = await Server()
                                                  .postFormData(
                                                      url:
                                                          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/deletesellerproduct",
                                                      body: {
                                                    "user_id": profileProvider
                                                        .userIdForAddress,
                                                    "product_id":
                                                        product["product_id"]
                                                            .toString()
                                                  });
                                              if (response == null) {
                                                snackbar(context,
                                                    "Failed to get a response from the server!");
                                                profileProvider.hideLoader();
                                                //hideLoader();
                                                if (Platform.isAndroid) {
                                                  SystemNavigator.pop();
                                                } else if (Platform.isIOS) {
                                                  exit(0);
                                                }
                                                return;
                                              }
                                              if (response.statusCode == 200) {
                                                if (!response.body.contains(
                                                    '"status":false')) {
                                                  productProvider.getData(
                                                      showMessage: (_) {
                                                        snackbar(context, _);
                                                      },
                                                      profileProvider:
                                                          profileProvider);
                                                } else if (response
                                                        .statusCode ==
                                                    400) {
                                                  snackbar(context,
                                                      "Undefined parameter when calling API");
                                                  profileProvider.hideLoader();
                                                  if (Platform.isAndroid) {
                                                    SystemNavigator.pop();
                                                  } else if (Platform.isIOS) {
                                                    exit(0);
                                                  }
                                                } else if (response
                                                        .statusCode ==
                                                    404) {
                                                  snackbar(
                                                      context, "API not found");
                                                  profileProvider.hideLoader();
                                                  if (Platform.isAndroid) {
                                                    SystemNavigator.pop();
                                                  } else if (Platform.isIOS) {
                                                    exit(0);
                                                  }
                                                } else {
                                                  snackbar(context,
                                                      "Failed to get data!");
                                                  profileProvider.hideLoader();
                                                  if (Platform.isAndroid) {
                                                    SystemNavigator.pop();
                                                  } else if (Platform.isIOS) {
                                                    exit(0);
                                                  }
                                                }
                                              }
                                            },
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Stack(
                          children: [
                            ProductCard(
                              inStockFun: () async {
                                ProfileProvider profileProvider =
                                    Provider.of<ProfileProvider>(context,
                                        listen: false);

                                dynamic res = {
                                  "product_id":
                                      product["product_id"].toString(),
                                  "quantity":
                                      product["in_stock"] == "1" ? "0" : "100"
                                };
                                profileProvider.showLoader();
                                var response = await post(
                                  Uri.parse(
                                      "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/productinstock"),
                                  body: jsonEncode(res),
                                  headers: {
                                    "Content-Type": "application/json",
                                    "Accept": "application/json",
                                  },
                                );
                                dynamic resData = jsonDecode(response.body);
                                log(resData.toString());
                                productProvider.getAllProducts(
                                    showMessage: (_) {
                                      snackbar(context, _);
                                    },
                                    profileProvider: profileProvider);
                                profileProvider.hideLoader();
                                log("123");
                              },
                              verify: product["verify_seller"] == "1",
                              disabled: false,
                              type: CardType.myProducts,
                              productId: product["product_id"] ?? "XYZ",
                              productName: product["product_name"] ?? "Name",
                              productDescription:
                                  product["description"] ?? "Description",
                              imageURL: (Uri.tryParse(product["image"] ?? "")
                                          ?.host
                                          .isNotEmpty ??
                                      false)
                                  ? (product["image"] ??
                                      "http://images.jdmagicbox.com/comp/visakhapatnam/q2/0891px891.x891.180329082226.k1q2/catalogue/nandi-krushi-visakhapatnam-e-commerce-service-providers-aomg9cai5i-250.jpg")
                                  : "http://images.jdmagicbox.com/comp/visakhapatnam/q2/0891px891.x891.180329082226.k1q2/catalogue/nandi-krushi-visakhapatnam-e-commerce-service-providers-aomg9cai5i-250.jpg",
                              price: double.tryParse(
                                      product["price"] ?? "00.00") ??
                                  00.00,
                              units:
                                  "${product["quantity"] ?? "1"} ${product["units"] ?? "unit"}",
                              location: product["place"] ?? "Visakhapatnam",
                              additionalInformation: {
                                "date":
                                    "${DateFormat('MMM').format(DateTime.fromMillisecondsSinceEpoch((int.tryParse(product["date_added"] ?? "0") ?? 0) * 1000))} ${int.tryParse(DateFormat('dd').format(DateTime.fromMillisecondsSinceEpoch((int.tryParse(product["date_added"] ?? "0") ?? 0) * 1000)))}${getDayOfMonthSuffix(DateTime.fromMillisecondsSinceEpoch((int.tryParse(product["date_added"] ?? "0") ?? 0) * 1000).day)} ${DateFormat('yyyy').format(DateTime.fromMillisecondsSinceEpoch((int.tryParse(product["date_added"] ?? "0") ?? 0) * 1000))}", //productProvider.orders[itemIndex]["date"],
                                "in_stock": product["in_stock"],
                              },
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: TextButton(
                                  onPressed: () {
                                    log(product.toString());

                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              content: SizedBox(
                                            height: 300,
                                            child: Consumer<ProfileProvider>(
                                                builder: (context,
                                                    profileProvider, _) {
                                              return Column(
                                                children: [
                                                  TextWidget(
                                                    'Update Product',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    weight: FontWeight.w700,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.045,
                                                  ),
                                                  Expanded(
                                                    child: TextFieldWidget(
                                                      controller: price,
                                                      label: 'Price ',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextFieldWidget(
                                                      controller: qunatity,
                                                      label: 'Quantity ',
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextFieldWidget(
                                                      controller: description,
                                                      label: 'Description ',
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 150,
                                                    margin:
                                                        const EdgeInsets.all(2),
                                                    child: ElevatedButtonWidget(
                                                      onClick: () async {
                                                        Navigator.pop(context);
                                                        dynamic body = {
                                                          "product_id": product[
                                                                  "product_id"]
                                                              .toString(),
                                                          "quantity": qunatity
                                                              .text
                                                              .toString(),
                                                          "price": price.text
                                                              .toString(),
                                                          "description":
                                                              description.text
                                                                  .toString()
                                                        };
                                                        log(body.toString());
                                                        productProvider
                                                            .updateMyProduct(
                                                                context,
                                                                profileProvider:
                                                                    profileProvider,
                                                                body: body);
                                                      },
                                                      height: 40,
                                                      bgColor: Colors.white,
                                                      buttonName: "Update"
                                                          .toUpperCase(),
                                                      textColor:
                                                          Colors.grey[900],
                                                      textStyle:
                                                          FontWeight.w600,
                                                      borderRadius: 12,
                                                      borderSideColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      center: true,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ));
                                        });
                                  },
                                  child: TextWidget(
                                    'Edit',
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    weight: FontWeight.w700,
                                    size: MediaQuery.of(context).size.width *
                                        0.035,
                                  ),
                                ))
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, _) {
                      return const Divider();
                    },
                    itemCount: productProvider.myProducts.length);
          }),
          Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
            return profileProvider.shouldShowLoader
                ? LoaderScreen(profileProvider)
                : const SizedBox();
          })
        ],
      ),
    );
  }
}
