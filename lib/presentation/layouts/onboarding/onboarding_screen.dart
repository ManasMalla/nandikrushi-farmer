// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Onbarding PageView

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/presentation/widgets/nandikrushi_button.dart';

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
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: NandikrushiButton(
                label: data["button_name"].toString().toUpperCase(),
                onPressed: () {
                  if (pageIndex == 1) {
                    Navigator.of(context).pushNamed('user-type-selection');
                  } else {
                    pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  }
                },
                trailingIcon:
                    pageIndex == 0 ? Icons.arrow_forward : Icons.check_rounded,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isLargeScreen ? 20 : 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 48,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        image: AssetImage(data['imageLink']),
                        fit: BoxFit.cover,
                        height: isLargeScreen ? 360 : 240,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        data["title"],
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Divider(
                              thickness: 1.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3),
                              indent: 8,
                              endIndent: 8,
                            );
                          },
                          shrinkWrap: true,
                          itemCount: data['content'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: Text(
                                data['content'][index],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.visible,
                                    ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: 2,
      );
    });
  }
}
