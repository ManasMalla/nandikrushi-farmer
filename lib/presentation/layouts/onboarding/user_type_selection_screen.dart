// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the UserType Screen

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/domain/enum/user_type.dart';
import 'package:nandikrushi_farmer/presentation/widgets/nandikrushi_button.dart';

import '../../../utils/size_config.dart';
import '../../widgets/outlined_button.dart';
import '../login_bg.dart';
import 'language_selection_screen.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth > 600
          ? Scaffold(
              backgroundColor: const Color(0xffFFFED8),
              body: LoginBG(
                child: userTypesSelection(context, true),
              ))
          : Scaffold(
              backgroundColor: const Color(0xffFFFED8),
              body: LoginBG(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 18,
                    bottom: 12,
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
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: userTypesSelection(context, false),
                  ),
                ),
              ),
            );
    });
  }
}

Widget userTypesSelection(BuildContext context, bool isLargeScreen) {
  return LayoutBuilder(builder: (context, constraints) {
    return Column(
      children: [
        Align(
          alignment: isLargeScreen ? Alignment.topLeft : Alignment.center,
          child: Text(
            "REGISTER AS",
            style: (isLargeScreen
                    ? Theme.of(context).textTheme.titleMedium
                    : Theme.of(context).textTheme.titleSmall)
                ?.copyWith(
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 2.5,
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return OutlinedNandikrushiButton(
              onPressed: () {
                // loginProvider
                //     .updateUserAppType(userTypeData.entries.elementAt(index));
              },
              label: UserType.values
                  .map((e) => e.name)
                  .toList()[index]
                  .toString()
                  .toUpperCase(),
            );
          },
          itemCount: UserType.values.length,
          separatorBuilder: (context, index) {
            return SizedBox(
              height:
                  getProportionateHeight(isLargeScreen ? 70 : 48, constraints),
            );
          },
        ),
        const Spacer(),
        NandikrushiButton(
          onPressed: () {
            // if (loginProvider.userAppTheme.key.isNotEmpty) {
            Navigator.of(context).pushNamed('language-selection');
            // } else {
            //   snackbar(context, "Please select a user type!");
            // }
          },
          label: "NEXT",
          trailingIcon: Icons.arrow_forward,
        ),
        SizedBox(
          height: !isLargeScreen ? 16 : 0,
        )
      ],
    );
  });
}
