// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Notification Screen

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/nav_items/search.dart';
import 'package:nandikrushi_farmer/product/orders_page.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, productProvider, _) {
      return Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0).copyWith(top: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size:
                              Theme.of(context).textTheme.titleLarge?.fontSize,
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          "Notifications",
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Catch all the updates you might\nhave missed out",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var notification =
                              profileProvider.notifications[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: notification["image"] != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        notification["image"]!,
                                                      ),
                                                      fit: BoxFit.cover)),
                                            )
                                          : Image.asset(
                                              "assets/images/green_fresh.png",
                                              fit: BoxFit.cover)),
                                  Flexible(
                                      flex: 3,
                                      child: Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.1),
                                        padding: const EdgeInsets.symmetric(
                                                horizontal: 16)
                                            .copyWith(top: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notification["title"] ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            Text(
                                              notification["description"] ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            (int.tryParse(notification[
                                                                    "type"] ??
                                                                "") ??
                                                            0) ==
                                                        1 ||
                                                    (int.tryParse(notification[
                                                                    "type"] ??
                                                                "") ??
                                                            0) ==
                                                        2
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 16,
                                                    ),
                                                    child: ElevatedButtonWidget(
                                                        onClick: () async {
                                                          if ((int.tryParse(
                                                                      notification[
                                                                              "type"] ??
                                                                          "") ??
                                                                  0) ==
                                                              1) {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        OrdersPage(onBack:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        })));
                                                          } else {
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const SearchScreen()));
                                                          }
                                                        },
                                                        height: 48,
                                                        borderRadius: 12,
                                                        bgColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                        textColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onPrimary,
                                                        minWidth: 200,
                                                        buttonName: (((int.tryParse(notification["type"] ??
                                                                            "") ??
                                                                        0) ==
                                                                    1)
                                                                ? "Track Delivery"
                                                                : "Order Now")
                                                            .toUpperCase(),
                                                        innerPadding: 0.02,
                                                        leadingIcon: (((int.tryParse(
                                                                        notification["type"] ??
                                                                            "") ??
                                                                    0) ==
                                                                1)
                                                            ? Icons.map_outlined
                                                            : Icons
                                                                .card_travel_rounded)),
                                                  )
                                                : const SizedBox()
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, _) {
                          return const SizedBox(
                            height: 16,
                          );
                        },
                        itemCount: profileProvider.notifications.length)
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
