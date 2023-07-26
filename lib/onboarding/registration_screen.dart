// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the registration screen

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nandikrushi_farmer/nav_host.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_controller.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/onboarding/registration_screen_first_fold.dart';
import 'package:nandikrushi_farmer/onboarding/registration_screen_second_fold.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/loader_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/textfield_widget.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/login_utils.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../reusable_widgets/show_image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  LoginController loginPageController = LoginController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loginPageController.checkLocationPermissionAndGetLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Consumer<LoginProvider>(builder: (_, loginProvider, __) {
        return LayoutBuilder(builder: (context, constraints) {
          return constraints.maxWidth < 500
              ? Stack(
                  children: [
                    PageView.builder(
                      controller: loginPageController.pageController,
                      itemCount: 2,
                      itemBuilder: (context, pageIndex) {
                        return SingleChildScrollView(
                          child: Stack(
                            children: [
                              Positioned(
                                top: -(getProportionateHeight(28, constraints)),
                                left: getProportionateWidth(210, constraints),
                                child: Image(
                                  image: AssetImage(
                                      "assets/images/${loginProvider.isFarmer ? "ic_farmer" : loginProvider.userAppTheme.key.contains("Store") ? "ic_store" : "ic_restaurant"}.png"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: getProportionateHeight(
                                        75, constraints)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 36),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nandikrushi",
                                      style: TextStyle(
                                          color: calculateContrast(
                                                      const Color(0xFF769F77),
                                                      createMaterialColor(
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary)
                                                          .shade700) >
                                                  3
                                              ? createMaterialColor(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary)
                                                  .shade700
                                              : createMaterialColor(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary)
                                                  .shade100,
                                          fontFamily: 'Samarkan',
                                          fontSize: getProportionateHeight(
                                              32, constraints)),
                                    ),
                                    TextWidget(
                                      "Create Account".toUpperCase(),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      weight: FontWeight.bold,
                                      size: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.fontSize,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getProportionateHeight(
                                        150, constraints)),
                                child: pageIndex == 0
                                    ? RegistrationDetailsFirstPage(
                                        loginPageController,
                                        setState,
                                        loginProvider,
                                        constraints,
                                        showImagePickerSheet)
                                    : Column(
                                        children: registrationDetailsSecondPage(
                                            context,
                                            loginPageController,
                                            setState,
                                            loginProvider,
                                            constraints,
                                            showImagePickerSheet),
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Consumer<LoginProvider>(
                        builder: (context, loginProvider, _) {
                      return loginProvider.shouldShowLoader
                          ? LoaderScreen(loginProvider)
                          : const SizedBox();
                    }),
                  ],
                )
              : Stack(
                  children: [
                    Positioned(
                      top: -(getProportionateHeight(28, constraints)),
                      left: getProportionateWidth(210, constraints),
                      child: Image(
                        image: AssetImage(
                            "assets/images/${loginProvider.isFarmer ? "ic_farmer" : loginProvider.userAppTheme.key.contains("Store") ? "ic_store" : "ic_restaurant"}.png"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: getProportionateHeight(75, constraints)),
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nandikrushi",
                            style: TextStyle(
                                color: calculateContrast(
                                            const Color(0xFF769F77),
                                            createMaterialColor(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary)
                                                .shade700) >
                                        3
                                    ? createMaterialColor(Theme.of(context)
                                            .colorScheme
                                            .primary)
                                        .shade700
                                    : createMaterialColor(Theme.of(context)
                                            .colorScheme
                                            .primary)
                                        .shade100,
                                fontFamily: 'Samarkan',
                                fontSize:
                                    getProportionateHeight(32, constraints)),
                          ),
                          TextWidget(
                            "Create Account".toUpperCase(),
                            color: Theme.of(context).colorScheme.primary,
                            weight: FontWeight.bold,
                            size: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.fontSize,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: getProportionateHeight(150, constraints)),
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Expanded(
                              child: RegistrationDetailsFirstPage(
                                  loginPageController,
                                  setState,
                                  loginProvider,
                                  constraints,
                                  showImagePickerSheet),
                            ),
                            Expanded(
                                child: Column(
                              children: registrationDetailsSecondPage(
                                  context,
                                  loginPageController,
                                  setState,
                                  loginProvider,
                                  constraints,
                                  showImagePickerSheet),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        });
      }),
    );
  }
}
