// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Language Selection screen

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/presentation/widgets/nandikrushi_button.dart';
import 'package:nandikrushi_farmer/presentation/widgets/outlined_button.dart';
import 'package:provider/provider.dart';

import '../../../utils/size_config.dart';
import '../login_bg.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth > 600
          ? Scaffold(
              backgroundColor: const Color(0xffFFFED8),
              body: LoginBG(
                child: languageSelection(context, true),
              ))
          : Scaffold(
              backgroundColor: const Color(0xffFFFED8),
              body: LoginBG(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 18,
                    bottom: 12,
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
                    child: languageSelection(context, false),
                  ),
                ),
              ),
            );
    });
  }
}

Widget languageSelection(BuildContext context, bool isLargeScreen) {
  return LayoutBuilder(builder: (context, constraints) {
    return Column(
      children: [
        Align(
          alignment: isLargeScreen ? Alignment.topLeft : Alignment.center,
          child: Text(
            "Select Language".toUpperCase(),
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
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return OutlinedNandikrushiButton(
              onPressed: () async {
                // loginProvider
                //     .updateLanguages(languages.entries.elementAt(index));
              },
              label: ["English", "Telugu", "Hindi", "Kannada"]
                  .toList()[index]
                  .toString()
                  .toUpperCase(),
            );
          },
          itemCount: ["English", "Telugu", "Hindi", "Kannada"].length,
          separatorBuilder: (context, index) {
            return SizedBox(
              height:
                  getProportionateHeight(isLargeScreen ? 70 : 24, constraints),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        NandikrushiButton(
          onPressed: () {
            // if (loginProvider.usersLanguage.key.isNotEmpty) {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: ((context) => const RegistrationScreen()),
            //     ),
            //   );
            // } else {
            //   snackbar(context, "Please select your preferred language!");
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
