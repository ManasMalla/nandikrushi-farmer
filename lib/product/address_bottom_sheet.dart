// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the bottom sheet to add an address for the product order workflow

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/product/add_addresses.dart';
import 'package:nandikrushi_farmer/product/confirm_order_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/server.dart';
import 'package:provider/provider.dart';

showAddressesBottomSheet(
    BuildContext context, ProfileProvider pp, ThemeData themeData,
    {bool isOrderWorkflow = true}) {
  pp.checkBoxAdd();
  showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Consumer<ProfileProvider>(
              builder: (context, profileProvider, _) {
            // profileProvider.checkBoxAdd();
            return Stack(
              children: [
                Container(
                  height: 600,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
                  child: profileProvider.userAddresses.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Image(
                                    image: AssetImage(
                                        'assets/images/delivery_address.png')),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextWidget(
                                  'No Addresses Available',
                                  weight: FontWeight.w800,
                                  size:
                                      themeData.textTheme.titleLarge?.fontSize,
                                  color: Colors.grey.shade800,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                TextWidget(
                                  'Your selected city is ${profileProvider.storeAddress["city"]}.\nPlease add an address by tapping below.',
                                  weight: FontWeight.w600,
                                  color: Colors.grey,
                                  flow: TextOverflow.visible,
                                  align: TextAlign.center,
                                  size:
                                      themeData.textTheme.bodyMedium?.fontSize,
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 42),
                                  child: ElevatedButtonWidget(
                                    bgColor: themeData.colorScheme.primary,
                                    trailingIcon: Icons.add_rounded,
                                    buttonName: 'Add Address'.toUpperCase(),
                                    textColor: Colors.white,
                                    textStyle: FontWeight.w800,
                                    borderRadius: 8,
                                    innerPadding: 0.03,
                                    onClick: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddAddressesScreen()));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                isOrderWorkflow
                                    ? 'Delivery Address'
                                    : "Your Addresses",
                                weight: FontWeight.w800,
                                size: themeData.textTheme.titleLarge?.fontSize,
                              ),
                              isOrderWorkflow
                                  ? Opacity(
                                      opacity: 0.7,
                                      child: TextWidget(
                                        'Choose the delivery address for this order',
                                        flow: TextOverflow.visible,
                                        align: TextAlign.center,
                                        size: themeData
                                            .textTheme.bodyMedium?.fontSize,
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 16,
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                separatorBuilder: (context, _) {
                                  return const Divider();
                                },
                                itemCount: profileProvider.userAddresses.length,
                                itemBuilder: (context, item) {
                                  log(item.toString());
                                  return InkWell(
                                    onTap: () {
                                      isOrderWorkflow
                                          ? Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmOrderScreen(
                                                        addressID: profileProvider
                                                                        .userAddresses[
                                                                    item][
                                                                "address_id"] ??
                                                            "",
                                                      )))
                                          : () {};
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            primary: false,
                                            itemBuilder: ((context, index) {
                                              var data = [
                                                profileProvider
                                                        .userAddresses[item]
                                                    ["address_title"],
                                                profileProvider
                                                        .userAddresses[item]
                                                    ["address_1"],
                                                profileProvider
                                                        .userAddresses[item]
                                                    ["address_2"],
                                                profileProvider
                                                        .userAddresses[item]
                                                    ["postcode"],
                                                profileProvider
                                                    .userAddresses[item]["city"]
                                              ];
                                              return index == 0
                                                  ? Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 6),
                                                          child: TextWidget(
                                                            data[index],
                                                            weight:
                                                                FontWeight.w800,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : addressRow(
                                                      data[index] ?? "", 16);
                                            }),
                                            itemCount: 5,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon:
                                                const Icon(Icons.edit_rounded),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: IconButton(
                                            onPressed: () async {
                                              profileProvider.showLoader();
                                              profileProvider.fetchingDataType =
                                                  "delete your address";

                                              // Navigator.of(context).pop();
                                              var response = await Server()
                                                  .postFormData(body: {
                                                "customer_id":
                                                    profileProvider.sellerID,
                                                "address_id": profileProvider
                                                            .userAddresses[item]
                                                        ["address_id"] ??
                                                    "",
                                              }, url: "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/address/delete").catchError(
                                                      (e) {
                                                log("64$e");
                                              });

                                              log("response - $response");
                                              if (response?.statusCode == 200) {
                                                log(response?.body ?? "");
                                                var decodedResponse = jsonDecode(response
                                                        ?.body
                                                        .replaceFirst(
                                                            '<b>Notice</b>: Undefined index: customer_group_id in\n<b>/home4/swekenco/public_html/nkweb/catalog/controller/extension/account/purpletree_multivendor/api/updateparticularuser.php</b>',
                                                            '')
                                                        .replaceFirst(
                                                            "<b>Notice</b>: Undefined index: customer_group_id in<b>/home4/swekenco/public_html/nkweb/catalog/controller/extension/account/purpletree_multivendor/api/updateparticularuser.php</b>",
                                                            "") ??
                                                    '{"message": {},"success": false}');
                                                log(response?.body ?? "");
                                                var statusCodeBody = false;
                                                if (decodedResponse[
                                                        "success"] !=
                                                    null) {
                                                  statusCodeBody =
                                                      decodedResponse[
                                                          "success"];
                                                } else {
                                                  statusCodeBody =
                                                      decodedResponse["status"];
                                                }
                                                if (statusCodeBody) {
                                                  log("Successful update");
                                                  snackbar(context,
                                                      "Successfully deleted the address!",
                                                      isError: false);
                                                  LoginProvider loginProvider =
                                                      Provider.of(context,
                                                          listen: false);

                                                  Navigator.of(context).pop();
                                                  profileProvider
                                                      .getProfile(
                                                          loginProvider:
                                                              loginProvider,
                                                          userID: profileProvider
                                                              .userIdForAddress,
                                                          showMessage: (_) {
                                                            snackbar(
                                                                context, _);
                                                          },
                                                          navigator:
                                                              Navigator.of(
                                                                  context))
                                                      .then((value) =>
                                                          profileProvider
                                                              .hideLoader());
                                                } else {
                                                  snackbar(context,
                                                      "Failed to delete address, error: ${decodedResponse["message"]}");
                                                  profileProvider.hideLoader();
                                                  Navigator.of(context).pop();
                                                }
                                              } else {
                                                log(response?.body ?? "");
                                                snackbar(context,
                                                    "Oops! Couldn't delete your address: ${response?.statusCode}");
                                                profileProvider.hideLoader();
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            icon: const Icon(
                                                Icons.delete_rounded),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Center(
                                  child: TextWidget(
                                    '-------------- or --------------',
                                    color: Colors.grey,
                                    flow: TextOverflow.visible,
                                    align: TextAlign.center,
                                    size: themeData
                                        .textTheme.bodyMedium?.fontSize,
                                  ),
                                ),
                              ),
                              ElevatedButtonWidget(
                                bgColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                trailingIcon: Icons.add_rounded,
                                buttonName: 'Add Address'.toUpperCase(),
                                textColor: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                textStyle: FontWeight.w800,
                                borderRadius: 8,
                                onClick: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const AddAddressesScreen()));
                                },
                              )
                            ],
                          ),
                        ),
                ),
                Positioned(
                    right: 10,
                    top: 10,
                    child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              pp.checkLength.clear();
                            },
                            icon: const Icon(Icons.close))))
              ],
            );
          });
        });
      });
}

Widget addressRow(String addres, double size) {
  return Row(
    children: [
      Expanded(
        child: TextWidget(
          addres,
          size: size,
          flow: TextOverflow.visible,
        ),
      )
    ],
  );
}
