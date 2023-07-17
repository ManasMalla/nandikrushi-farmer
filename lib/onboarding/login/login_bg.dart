// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the background widget for the screens in the login workflow

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/loader_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:provider/provider.dart';

class LoginBG extends StatelessWidget {
  final Widget child;
  bool isPrimary = true;
  bool shouldHaveBottomPadding = true;
  LoginBG(
      {Key? key,
      required this.child,
      this.isPrimary = true,
      this.shouldHaveBottomPadding = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? SingleChildScrollView(
                  child: Container(
                    width: getProportionateWidth(428, constraints),
                    height: getProportionateHeight(926, constraints),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          Theme.of(context).brightness == Brightness.dark
                              ? 'assets/images/login_BG_night.png'
                              : 'assets/images/login_BG.png'),
                    )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                            getProportionateWidth(21, constraints),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: getProportionateHeight(
                                          54, constraints) +
                                      getProportionateWidth(16, constraints),
                                ),
                                SizedBox(
                                  child: Text(
                                    'Nandikrushi',
                                    style: TextStyle(
                                      fontFamily: 'Samarkan',
                                      fontSize: getProportionateHeight(
                                          34, constraints),
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  child: TextWidget(
                                    'WELCOME',
                                    size:
                                        getProportionateHeight(25, constraints),
                                    weight: FontWeight.w600,
                                    align: TextAlign.start,
                                    lSpace: 1.2,
                                  ),
                                ),
                                SizedBox(
                                  child: TextWidget(
                                    "Let's get started",
                                    size:
                                        getProportionateHeight(10, constraints),
                                    weight: FontWeight.w600,
                                    align: TextAlign.start,
                                    lSpace: 2.5,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        child,
                      ],
                    ),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        width: double.infinity,
                        height: double.infinity,
                        "assets/images/login_BG.png",
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                  color: const Color(0xFFFFFED8),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                color: const Color(0xFF769F77),
                              )),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(
                                      -getProportionateHeight(12, constraints),
                                      0),
                                  blurRadius: 6,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ],
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(32)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 36,
                                  right: shouldHaveBottomPadding ? 36 : 0,
                                  top: 24,
                                  bottom: shouldHaveBottomPadding ? 24 : 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WelcomeToNandikrushi(
                                    constraints: constraints,
                                    bottomSpacing:
                                        shouldHaveBottomPadding ? 128 : 64,
                                  ),
                                  Expanded(child: child),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        }),
        Consumer<LoginProvider>(builder: (context, loginProvider, _) {
          return loginProvider.shouldShowLoader
              ? LoaderScreen(loginProvider)
              : const SizedBox();
        })
      ],
    );
  }
}

class WelcomeToNandikrushi extends StatelessWidget {
  final BoxConstraints constraints;
  final double bottomSpacing;
  const WelcomeToNandikrushi(
      {Key? key, required this.constraints, this.bottomSpacing = 128})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: getProportionateHeight(32, constraints),
        ),
        SizedBox(
          child: Text(
            'Nandikrushi',
            style: TextStyle(
              fontFamily: 'Samarkan',
              fontSize: getProportionateHeight(48, constraints),
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          child: TextWidget(
            'WELCOME',
            size: getProportionateHeight(32, constraints),
            weight: FontWeight.w600,
            align: TextAlign.start,
            lSpace: 1.2,
          ),
        ),
        SizedBox(
          child: TextWidget(
            "Let's get started",
            size: getProportionateHeight(14, constraints),
            weight: FontWeight.w500,
            align: TextAlign.start,
            lSpace: 2.5,
          ),
        ),
        SizedBox(
          height: getProportionateHeight(bottomSpacing, constraints),
        ),
      ],
    );
  }
}
