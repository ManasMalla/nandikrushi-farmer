// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the UserType Screen

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/onboarding/language_selection.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_bg.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:provider/provider.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, loginProvider, _) {
      return LayoutBuilder(builder: (context, constraints) {
        return constraints.maxWidth > 600
            ? Scaffold(
                backgroundColor: const Color(0xffFFFED8),
                body: LoginBG(
                  child: userTypesSelection(context, loginProvider, true),
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
                    height: getProportionateHeight(463, constraints),
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
                      child: userTypesSelection(context, loginProvider, false),
                    ),
                  ),
                ),
              );
      });
    });
  }
}

Widget userTypesSelection(
    BuildContext context, LoginProvider loginProvider, bool isLargeScreen) {
  var userTypeData = loginProvider.availableUserTypes;
  return LayoutBuilder(builder: (context, constraints) {
    return Column(
      children: [
        Align(
          alignment: isLargeScreen ? Alignment.topLeft : Alignment.center,
          child: TextWidget(
            "REGISTER AS",
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
          height: getProportionateHeight(72, constraints),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ElevatedButtonWidget(
              onClick: () {
                loginProvider
                    .updateUserAppType(userTypeData.entries.elementAt(index));
              },
              minWidth: getProportionateWidth(345, constraints),
              height: getProportionateHeight(100, constraints),
              bgColor: loginProvider.userAppTheme.key ==
                      userTypeData.keys.toList()[index]
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderSideColor:
                  createMaterialColor(Theme.of(context).colorScheme.primary)
                      .shade600,
              textColor: loginProvider.userAppTheme.key ==
                      userTypeData.keys.toList()[index]
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
              buttonName:
                  userTypeData.keys.toList()[index].toString().toUpperCase(),
              center: true,
              borderRadius: 100,
            );
          },
          itemCount: userTypeData.length,
          separatorBuilder: (context, index) {
            return SizedBox(
              height:
                  getProportionateHeight(isLargeScreen ? 70 : 56, constraints),
            );
          },
        ),
        const Spacer(),
        ElevatedButtonWidget(
          onClick: () {
            if (loginProvider.userAppTheme.key.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => const LanguageSelectionScreen()),
                ),
              );
            } else {
              snackbar(context, "Please select a user type!");
            }
          },
          borderRadius: getProportionateHeight(24, constraints),
          minWidth: double.infinity,
          height:
              getProportionateHeight(isLargeScreen ? 110 : 120, constraints),
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
