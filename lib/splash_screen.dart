// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Splash Screen

import 'dart:developer';

import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/color_schemes.dart';
import 'package:nandikrushi_farmer/data/repository/local_user_repository.dart';
import 'package:nandikrushi_farmer/data/repository/online_user_repository.dart';
import 'package:nandikrushi_farmer/domain/enum/user_type.dart';
import 'package:nandikrushi_farmer/domain/usecase/login_usecase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/enum/user_authentication_state.dart';

class SplashScreen extends StatelessWidget {
  final UserType userType;

  const SplashScreen({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((sharedPreferences) {
      final loginUseCase = LoginUseCase(
          localUserRepository:
              LocalUserRepository(sharedPreferences: sharedPreferences),
          onlineUserRepository: OnlineUserRepository());
      final isUserLoggedIn = loginUseCase.isUserLoggedIn();
      switch (isUserLoggedIn) {
        case UserAuthenticationState.phone:
          Navigator.of(context).pushNamed("home-screen");
          break;
        case UserAuthenticationState.email:
          Navigator.of(context).pushNamed("home-screen");
          break;
        case UserAuthenticationState.firebase:
          final onlineUserAuthStatus =
              OnlineUserRepository().checkIfUserIdExists();
          switch (onlineUserAuthStatus.entries.first.key) {
            case UserAuthStatus.verified:
              loginUseCase.saveUserToLocalStorage(
                  onlineUserAuthStatus.entries.first.value);
              Navigator.of(context).pushNamed("home-screen");
              break;
            case UserAuthStatus.notVerified:
              Navigator.of(context).pushNamed('not-verified');
              break;
            case UserAuthStatus.none:
              Navigator.of(context).pushNamed('onboarding');
              break;
          }
          break;
        case UserAuthenticationState.none:
          Navigator.of(context).pushNamed('onboarding');
          break;
      }
    });

    // loginPageController.checkUser(
    //   isReturningUserFuture: context.isReturningUser,
    //   navigator: Navigator.of(context),
    //   onNewUser: (onCompleted) {
    //     loginPageController.getUserRegistrationData(context).then((_) {
    //       LoginProvider provider =
    //           Provider.of<LoginProvider>(context, listen: false);
    //       provider.fetchUserTypes(_);
    //       onCompleted();
    //     });
    //   },
    //   loginProvider: loginProvider,
    // );

    return Scaffold(
      backgroundColor: ElevationOverlay.colorWithOverlay(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.primary,
          3.0),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            Image.asset(
              userType == UserType.restaraunt
                  ? "assets/images/logo-brown.png"
                  : "assets/images/logo.png",
            ),
            Text(
              userType.name.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: context.isDarkMode
                        ? Theme.of(context).colorScheme.onBackground
                        : Theme.of(context).colorScheme.primary,
                    letterSpacing: userType.name.length > 8 ? 8 : 16,
                  ),
            ),
            const Spacer(),
            const CircularCappedProgressIndicator(strokeCap: StrokeCap.round),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
