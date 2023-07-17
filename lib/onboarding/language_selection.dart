// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Language Selection screen

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_bg.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/onboarding/registration_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:provider/provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, loginProvider, _) {
      return LayoutBuilder(builder: (context, constraints) {
        return constraints.maxWidth > 600
            ? Scaffold(
                backgroundColor: const Color(0xffFFFED8),
                body: LoginBG(
                  child: languageSelection(context, loginProvider, true),
                ))
            : Scaffold(
                backgroundColor: const Color(0xffFFFED8),
                body: LoginBG(
                  isPrimary: false,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: getProportionateWidth(18, constraints),
                      bottom: getProportionateWidth(12, constraints),
                    ),
                    height: getProportionateHeight(500, constraints),
                    decoration: BoxDecoration(
                        //color: Color(0xffF2F5F4),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(
                                0, -getProportionateHeight(10, constraints)),
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: languageSelection(context, loginProvider, false),
                    ),
                  ),
                ),
              );
      });
    });
  }
}

Widget languageSelection(
    BuildContext context, LoginProvider loginProvider, bool isLargeScreen) {
  var languages = loginProvider.languages;
  return LayoutBuilder(builder: (context, constraints) {
    return Column(
      children: [
        Align(
          alignment: isLargeScreen ? Alignment.topLeft : Alignment.center,
          child: TextWidget(
            "Select Language".toUpperCase(),
            size: isLargeScreen
                ? Theme.of(context).textTheme.titleMedium?.fontSize
                : Theme.of(context).textTheme.titleSmall?.fontSize,
            weight: FontWeight.w800,
            color: createMaterialColor(Theme.of(context).colorScheme.primary)
                .shade600,
            align: TextAlign.start,
            lSpace: 2.5,
          ),
        ),
        SizedBox(
          height: getProportionateHeight(64, constraints),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ElevatedButtonWidget(
              onClick: () async {
                loginProvider
                    .updateLanguages(languages.entries.elementAt(index));
              },
              minWidth: getProportionateWidth(345, constraints),
              height: getProportionateHeight(100, constraints),
              bgColor: loginProvider.usersLanguage.key ==
                      languages.keys.toList()[index]
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderSideColor:
                  createMaterialColor(Theme.of(context).colorScheme.primary)
                      .shade600,
              textColor: loginProvider.usersLanguage.key ==
                      languages.keys.toList()[index]
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
              buttonName:
                  languages.keys.toList()[index].toString().toUpperCase(),
              center: true,
              borderRadius:
                  getProportionateHeight(isLargeScreen ? 32 : 32, constraints),
            );
          },
          itemCount: languages.length,
          separatorBuilder: (context, index) {
            return SizedBox(
              height:
                  getProportionateHeight(isLargeScreen ? 56 : 40, constraints),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButtonWidget(
          onClick: () {
            if (loginProvider.usersLanguage.key.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => const RegistrationScreen()),
                ),
              );
            } else {
              snackbar(context, "Please select your preferred language!");
            }
          },
          borderRadius: getProportionateHeight(24, constraints),
          minWidth: double.infinity,
          height:
              getProportionateHeight(isLargeScreen ? 125 : 125, constraints),
          buttonName: "NEXT",
          trailingIcon: Icons.arrow_forward,
        ),
        SizedBox(
          height: !isLargeScreen ? 16 : 0,
        )
      ],
    );
  });
}
