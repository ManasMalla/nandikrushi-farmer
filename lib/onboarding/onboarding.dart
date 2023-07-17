// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Onbarding PageView

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';

dynamic onboardData = [
  {
    "imageLink": "assets/images/globalagriculture.jpeg",
    "content": [
      "No natural farmers should suffer to sell their products in their locality",
      "Maximizing farmer's profit and reducing prices by buying directly from them"
    ],
    "title": "Transparency",
    "button_name": "Next",
  },
  {
    "imageLink": "assets/images/traceability.jpeg",
    "content": [
      "Building blockchain based network for traceability of organic product to stop fake organic / adulterated products creeping into supply chain with organic labels.",
      "Here provenance framework will be used so that farmers and end consumers will be the ultimate gainers disrupting multi level middle men in organic supply chain"
    ],
    "title": "Traceability",
    "button_name": "Get Started"
  }
];

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth < 600
          ? const Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                child: OnboardingPageScreen(
                  isLargeScreen: false,
                ),
              ),
            )
          : const Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 32),
                child: OnboardingPageScreen(
                  isLargeScreen: true,
                ),
              ),
            );
    });
  }
}

class OnboardingPageScreen extends StatelessWidget {
  final bool isLargeScreen;
  const OnboardingPageScreen({Key? key, required this.isLargeScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return LayoutBuilder(builder: (context, constraints) {
      return PageView.builder(
        controller: pageController,
        itemBuilder: (context, pageIndex) {
          var data = onboardData[pageIndex];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 20 : 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getProportionateHeight(48, constraints),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                    image: AssetImage(data['imageLink']),
                    fit: BoxFit.cover,
                    height: getProportionateHeight(
                        isLargeScreen ? 360 : 240, constraints),
                    width: double.infinity,
                  ),
                ),
                SizedBox(
                  height: getProportionateHeight(40, constraints),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: getProportionateWidth(8, constraints)),
                  child: TextWidget(
                    data["title"],
                    size: Theme.of(context).textTheme.displaySmall?.fontSize,
                    align: TextAlign.start,
                    color: Theme.of(context).colorScheme.primary,
                    weight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateHeight(10, constraints)),
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 1.5,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          indent: getProportionateWidth(8, constraints),
                          endIndent: getProportionateWidth(8, constraints),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: data['content'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: getProportionateWidth(8, constraints),
                              right: getProportionateWidth(8, constraints),
                              top: getProportionateHeight(10, constraints),
                              bottom: getProportionateHeight(10, constraints)),
                          child: TextWidget(
                            data['content'][index],
                            size: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.fontSize,
                            align: TextAlign.start,
                            weight: FontWeight.w400,
                            flow: TextOverflow.visible,
                          ),
                        );
                      }),
                ),
                const Spacer(),
                ElevatedButtonWidget(
                  onClick: () {
                    if (pageIndex == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const LoginScreen()),
                        ),
                      );
                    } else {
                      pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut);
                    }
                  },
                  minWidth: getProportionateWidth(390, constraints),
                  height: getProportionateHeight(
                      isLargeScreen ? 70 : 60, constraints),
                  borderRadius: 8,
                  buttonName: data["button_name"].toString().toUpperCase(),
                  trailingIcon: pageIndex == 0
                      ? Icons.arrow_forward
                      : Icons.check_rounded,
                )
              ],
            ),
          );
        },
        itemCount: 2,
      );
    });
  }
}
