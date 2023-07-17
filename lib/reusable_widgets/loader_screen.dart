// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the loader screen which is shown to indicate the progress of an async task

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:provider/provider.dart';

class LoaderScreen extends StatelessWidget {
  final ChangeNotifier provider;
  const LoaderScreen(this.provider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: Consumer<LoginProvider>(builder: (context, loginProvider, _) {
            return CircleAvatar(
              radius: getProportionateHeight(170, constraints),
              backgroundColor:
                  createMaterialColor(Theme.of(context).colorScheme.primary)
                      .shade100
                      .withOpacity(constraints.maxWidth < 600 ? 0.9 : 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    "assets/loader.json",
                    height: getProportionateHeight(170, constraints),
                    width: getProportionateHeight(300, constraints),
                  ),
                  TextWidget(
                    "Please Wait Until We\n${provider is ProfileProvider ? (provider as ProfileProvider).fetchingDataType : "Load Your Data"}..."
                        .toUpperCase(),
                    size: Theme.of(context).textTheme.titleSmall?.fontSize,
                    weight: FontWeight.w500,
                    align: TextAlign.center,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            );
          }),
        );
      }),
    );
  }
}
