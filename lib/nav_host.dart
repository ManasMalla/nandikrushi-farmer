// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the NavHost of the Nandikrushi app

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nandikrushi_farmer/nav_items/home/home.dart';
import 'package:nandikrushi_farmer/nav_items/my_purchases.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/nav_items/search.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/product/orders_page.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/loader_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class NandikrushiNavHost extends StatefulWidget {
  final String userId;
  final bool shouldUpdateField;
  const NandikrushiNavHost(
      {Key? key, required this.userId, this.shouldUpdateField = true})
      : super(key: key);

  @override
  State<NandikrushiNavHost> createState() => _NandikrushiNavHostState();
}

class _NandikrushiNavHostState extends State<NandikrushiNavHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.shouldUpdateField) {
        ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        ProductProvider productProvider =
            Provider.of<ProductProvider>(context, listen: false);
        LoginProvider loginProvider =
            Provider.of<LoginProvider>(context, listen: false);
        profileProvider.showLoader();
        profileProvider.getVideos(
            context: context,
            onSuccessful: () {
              profileProvider
                  .getProfile(
                      loginProvider: loginProvider,
                      userID: widget.userId,
                      showMessage: (_) {
                        snackbar(context, _);
                      },
                      navigator: Navigator.of(context))
                  .then((value) {
                productProvider.getData(
                    profileProvider: profileProvider,
                    showMessage: (_) {
                      snackbar(context, _);
                    });
              });
            },
            showMessage: (_) {
              snackbar(context, _);
            });
      }
    });
  }

  var shouldCloseApp = false;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Theme.of(context).colorScheme.surface),
      child: WillPopScope(
        onWillPop: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                width: 428,
                child: SizedBox(
                  width: 428,
                  child: AlertDialog(
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    actions: [
                      Container(
                        alignment: Alignment.center,
                        width: 428,
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButtonWidget(
                          onClick: () {
                            Navigator.pop(context);
                          },
                          height: 56,
                          bgColor: Colors.transparent,
                          buttonName: "Cancel".toUpperCase(),
                          textColor: Theme.of(context).colorScheme.onSurface,
                          textStyle: FontWeight.w600,
                          borderRadius: 12,
                          borderSideColor:
                              Theme.of(context).colorScheme.primary,
                          center: true,
                        ),
                      ),
                      Container(
                        width: 428,
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButtonWidget(
                          onClick: () async {
                            Navigator.of(context).pop();
                            exit(0);
                          },
                          height: 56,
                          bgColor: Theme.of(context).colorScheme.error,
                          buttonName: "Exit".toUpperCase(),
                          borderRadius: 8,
                          textColor: Theme.of(context).colorScheme.onError,
                          textStyle: FontWeight.w600,
                          center: true,
                        ),
                      ),
                    ],
                    content: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          TextWidget(
                            'Are you sure you want to exit the application?',
                            flow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                    elevation: 10,
                  ),
                ),
              );
            },
          );
          return Future.value(false);
        },
        child: Theme(
          data: Theme.of(context).copyWith(
              navigationBarTheme: Theme.of(context).navigationBarTheme.copyWith(
                  labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return null;
            }
            return Theme.of(context)
                    .navigationBarTheme
                    .labelTextStyle
                    ?.resolve(MaterialState.values
                        .where((element) => element != MaterialState.selected)
                        .toSet())
                    ?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.6)) ??
                Theme.of(context).textTheme.labelMedium?.copyWith(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.6));
          }))),
          child:
              Consumer<ProductProvider>(builder: (context, productProvider, _) {
            return LayoutBuilder(builder: (context, constraints) {
              List<Widget> widgetOptions = <Widget>[
                Center(
                  child: HomeScreen(
                    constraints: constraints,
                  ),
                ),
                const Center(child: SearchScreen()),
                Center(
                  child: OrdersPage(
                    onBack: () {
                      productProvider.changeScreen(0);
                    },
                  ),
                ),
                const Center(
                  child: MyPurchasesScreen(),
                ),
              ];
              Map<String, List<IconData>> navItems = {
                'Home': [
                  Icons.home_outlined,
                  Icons.home_rounded,
                ],
                'Products': [
                  Icons.search_rounded,
                  Icons.search_rounded,
                ],
                'Orders': [
                  Icons.assignment_outlined,
                  Icons.assignment_rounded,
                ],
                'Purchases': [
                  Icons.inventory_2_outlined,
                  Icons.inventory_2_rounded,
                ]
              };
              return Stack(
                children: [
                  constraints.maxWidth < 600
                      ? Scaffold(
                          body: widgetOptions[productProvider.selectedIndex],
                          bottomNavigationBar: NavigationBar(
                            elevation: 0,
                            destinations: navItems.entries
                                .map((e) => NavigationDestination(
                                    icon: Icon(
                                      e.value[0],
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.6),
                                    ),
                                    selectedIcon: Icon(
                                      e.value[1],
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                                    label: e.key))
                                .toList(),
                            selectedIndex: productProvider.selectedIndex,
                            onDestinationSelected: (index) {
                              productProvider.changeScreen(index);
                            },
                          ),
                        )
                      : Row(
                          children: [
                            Container(
                              color: Theme.of(context).colorScheme.background,
                              padding: const EdgeInsets.all(8),
                              child: NavigationRail(
                                  groupAlignment: 0,
                                  extended: constraints.maxWidth > 1200,
                                  onDestinationSelected: (value) {
                                    productProvider.changeScreen(value);
                                  },
                                  destinations: navItems.entries
                                      .map((e) => NavigationRailDestination(
                                          icon: Icon(e.value[0]),
                                          selectedIcon: Icon(e.value[1]),
                                          label: Text(e.key)))
                                      .toList(),
                                  selectedIndex: productProvider.selectedIndex),
                            ),
                            Expanded(
                                child: widgetOptions[
                                    productProvider.selectedIndex])
                          ],
                        ),
                  Consumer<ProfileProvider>(
                      builder: (context, profileProvider, _) {
                    return profileProvider.shouldShowLoader
                        ? LoaderScreen(profileProvider)
                        : const SizedBox();
                  }),
                ],
              );
            });
          }),
        ),
      ),
    );
  }
}
