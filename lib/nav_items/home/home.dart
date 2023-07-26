// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Home Screen of the NavHost for the Nandikrushi

import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/basket.dart';
import 'package:nandikrushi_farmer/nav_items/my_account.dart';
import 'package:nandikrushi_farmer/nav_items/notification_screen.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/nav_items/video_data.dart';
import 'package:nandikrushi_farmer/nav_items/videos_screen.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/product/add_product.dart';
import 'package:nandikrushi_farmer/product/my_products_page.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/material_you_clipper.dart';
import 'package:nandikrushi_farmer/reusable_widgets/textfield_widget.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:nandikrushi_farmer/utils/youtube_util.dart';
import 'package:provider/provider.dart';

import '../../product/orders_page.dart';
import 'home_appbar.dart';
import 'home_cards.dart';
import 'home_video_section.dart';

class HomeScreen extends StatefulWidget {
  final BoxConstraints constraints;

  const HomeScreen({Key? key, required this.constraints}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, loginProvider, _) {
      return SafeArea(
        bottom: false,
        top: false,
        child:
            Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
          return Consumer<ProductProvider>(
              builder: (context, productProvider, _) {
            return Container(
              color: Theme.of(context).colorScheme.background,
              padding: const EdgeInsets.only(top: 16.0),
              child: Scaffold(
                floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddProductScreen()));
                  },
                  label: const Text("Add Product"),
                  icon: const Icon(Icons.add_rounded),
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: homeAppBar(context, widget.constraints),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Container(
                        //   decoration: BoxDecoration(
                        //       color: Theme.of(context)
                        //           .colorScheme
                        //           .primary
                        //           .withOpacity(0.15),
                        //       borderRadius: BorderRadius.circular(16)),
                        //   margin: const EdgeInsets.only(top: 8, bottom: 16),
                        //   width: double.infinity,
                        //   child: Center(
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 24.0, vertical: 8),
                        //       child: Row(
                        //         children: [
                        //           Expanded(
                        //             child: TextFieldWidget(
                        //               onChanged: (_) {
                        //                 setState(() {});
                        //               },
                        //               onSubmitField: () {
                        //                 setState(() {});
                        //               },
                        //               textInputAction: TextInputAction.search,
                        //               hint: "Search",
                        //               controller: searchController,
                        //               hintStyle: Theme.of(context)
                        //                   .textTheme
                        //                   .titleMedium
                        //                   ?.copyWith(
                        //                       color: Theme.of(context)
                        //                           .colorScheme
                        //                           .primary
                        //                           .withOpacity(0.7)),
                        //               shouldShowBorder: false,
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .titleMedium
                        //                   ?.copyWith(
                        //                       color: Theme.of(context)
                        //                           .colorScheme
                        //                           .primary),
                        //             ),
                        //           ),
                        //           InkWell(
                        //             onTap: () async {
                        //               print(await FirebaseMessaging.instance
                        //                   .getToken());
                        //               if (searchController
                        //                   .value.text.isNotEmpty) {
                        //                 setState(() {
                        //                   searchController.value =
                        //                       const TextEditingValue();
                        //                 });
                        //               }
                        //             },
                        //             child: Icon(
                        //                 searchController.value.text.isNotEmpty
                        //                     ? Icons.highlight_remove_rounded
                        //                     : Icons.search_rounded,
                        //                 color: Theme.of(context)
                        //                     .colorScheme
                        //                     .primary),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        searchController.value.text.isEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Latest Around You",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const Spacer(),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const VideosScreen()));
                                          },
                                          child: const Text("View More")),
                                    ],
                                  ),
                                  const Opacity(
                                    opacity: 0.6,
                                    child: Text(
                                        "Catch up on the latest going around you"),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  homeVideoSection(profileProvider.videos),
                                  homeOrdersCard(context, productProvider),
                                  homeMyProductsCard(context, productProvider),
                                  homeMyPurchasesCard(context, productProvider),
                                ],
                              )
                            //TODO: Implement the search functionality
                            : Column(
                                children: [
                                  Image.asset("assets/images/ic_searching.png"),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    "Searching",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const Text(
                                    "Looking over our humongous database\nof products and orders...",
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        }),
      );
    });
  }
}
