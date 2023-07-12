// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Product Details Page

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/product/product_page/product_page_actions.dart';
import 'package:nandikrushi_farmer/product/product_page/product_page_app_bar.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/rating_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import '../../utils/login_utils.dart';
import 'more_farmer_produce.dart';

class ProductPage extends StatefulWidget {
  final Map<String, String> productDetails;

  const ProductPage({Key? key, required this.productDetails}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    // log("50");
    // log(widget.productDetails.toString());
    // log("52");
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Theme.of(context).colorScheme.background),
      child: Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
          double rating =
              (double.tryParse(widget.productDetails["rating"] ?? "0.0") ?? 0);

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar:
                productPageAppBar(context, productProvider, profileProvider),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Container(
                            height: 185,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Image.network(
                              widget.productDetails["url"] ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            widget.productDetails["name"] ?? "Product Name",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.fontSize),
                          ),
                          Text(
                            widget.productDetails["category_id"] ?? "Category",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextWidget(
                            widget.productDetails["units"] ?? "1 unit",
                            weight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextWidget(
                                "Rs.",
                                size: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.fontSize,
                                weight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              TextWidget(
                                double.tryParse(
                                            widget.productDetails["price"] ??
                                                "")
                                        ?.toStringAsFixed(2) ??
                                    "",
                                size: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.fontSize,
                                weight: FontWeight.w800,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              FixedRatingStar(
                                  value: rating < 0.5
                                      ? 0
                                      : rating == 0.5
                                          ? 0.5
                                          : 1),
                              FixedRatingStar(
                                  value: rating < 1.5
                                      ? 0
                                      : rating == 1.5
                                          ? 0.5
                                          : 1),
                              FixedRatingStar(
                                  value: rating < 2.5
                                      ? 0
                                      : rating == 2.5
                                          ? 0.5
                                          : 1),
                              FixedRatingStar(
                                  value: rating < 3.5
                                      ? 0
                                      : rating == 3.5
                                          ? 0.5
                                          : 1),
                              FixedRatingStar(
                                  value: rating < 4.5
                                      ? 0
                                      : rating == 4.5
                                          ? 0.5
                                          : 1),
                              const SizedBox(
                                width: 8,
                              ),
                              ((jsonDecode(widget.productDetails[
                                                          "customer_ratings"] ??
                                                      "{}")
                                                  as Map<String, dynamic>?)
                                              ?.length ??
                                          0) ==
                                      0
                                  ? SizedBox()
                                  : Text(
                                      ((jsonDecode(widget.productDetails[
                                                              "customer_ratings"] ??
                                                          "{}")
                                                      as Map<String, dynamic>?)
                                                  ?.length ??
                                              0)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          productPageActions(context, productProvider,
                              widget.productDetails, profileProvider),
                          const SizedBox(
                            height: 12,
                          ),
                          const TextWidget(
                            'Product Description',
                            weight: FontWeight.w800,
                          ),
                          TextWidget(widget.productDetails["description"] ?? "",
                              flow: TextOverflow.visible),
                          const SizedBox(
                            height: 12,
                          ),
                          const TextWidget(
                            'Farmer Details',
                            weight: FontWeight.w800,
                            size: 18,
                          ),
                          TextWidget(
                            'Farmer Name: ${capitalize(widget.productDetails["seller_name"] ?? "")}',
                            weight: FontWeight.w500,
                          ),
                          TextWidget(
                            'Location : ${widget.productDetails["place"] ?? "Visakhapatnam"}',
                            weight: FontWeight.w500,
                          ),
                          Row(
                            children: [
                              const TextWidget(
                                'Certification : ',
                                weight: FontWeight.w500,
                              ),
                              TextWidget(
                                widget.productDetails["seller_certificate"] ??
                                    "",
                                weight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          moreFarmerProducts(
                              productProvider, widget.productDetails),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
