// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Splash Screen

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_controller.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/login_utils.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(context.isDarkMode.toString());
    LoginController loginPageController = LoginController();
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);

    loginPageController.checkUser(
      isReturningUserFuture: context.isReturningUser,
      navigator: Navigator.of(context),
      onNewUser: (onCompleted) {
        loginPageController.getUserRegistrationData(context).then((_) {
          LoginProvider provider =
              Provider.of<LoginProvider>(context, listen: false);
          provider.fetchUserTypes(_);
          onCompleted();
        });
      },
      loginProvider: loginProvider,
    );

    return Scaffold(
      backgroundColor: ElevationOverlay.colorWithOverlay(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.primary,
          3.0),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/logo.png"),
            TextWidget(
              loginProvider.userAppTheme.key.toUpperCase(),
              size: 12,
              lSpace: loginProvider.userAppTheme.key.length > 10 ? 8 : 16,
              color: context.isDarkMode
                  ? Theme.of(context).colorScheme.onBackground
                  : Theme.of(context).colorScheme.primary,
            )
          ],
        ),
      ),
    );
  }
}
