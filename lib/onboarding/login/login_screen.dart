// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Login Screen

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_host.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_bg.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_controller.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/onboarding/otp_screen.dart';
import 'package:nandikrushi_farmer/onboarding/user_type.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/login_utils.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:provider/provider.dart';

import 'login_screen_compat.dart';
import 'login_screen_large.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginPageController = LoginController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, data, child) {
      Future<void> loginUser(bool isEmail) {
        return data.onLoginUser(isEmail, loginPageController,
            onSuccessfulLogin: (name, isReturningUser, uID, cID) {
          snackbar(context,
              "Welcome ${isReturningUser ? "back" : "to the Nandikrushi family"}, $name!",
              isError: false);
          context.setAsReturningUser(uID);
          data.showLoader();

          Navigator.maybeOf(context)?.pushReplacement(MaterialPageRoute(
              builder: (context) => NandikrushiNavHost(
                    userId: uID,
                  )));
        }, onError: (error) {
          snackbar(context, error);
        }, showMessage: (message) {
          snackbar(context, message, isError: false);
        }, navigateToOTPScreen: (onValidateOTP) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                  phoneNumber: loginPageController.phoneTextEditController.text
                      .toString(),
                  onValidateOTP: onValidateOTP,
                  onResendOTP: () {
                    loginUser(isEmail);
                  }),
            ),
          );
        }, onRegisterUser: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UserTypeScreen(),
            ),
          );
        }, navigator: Navigator.of(context));
      }

      return Scaffold(
          backgroundColor: const Color(0xFFFFFDD8),
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(builder: (context, constraints) {
            return constraints.maxWidth < 600 //Portrait
                ? Form(
                    key: data.isEmailLogin
                        ? loginPageController.emailFormKey
                        : loginPageController.mobileFormKey,
                    child: LoginBG(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: getProportionateHeight(20, constraints),
                            bottom: getProportionateHeight(20, constraints)),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: LoginWidgetCompactScreens(
                              constraints: constraints,
                              loginPageController: loginPageController,
                              isEmail: data.isEmailLogin,
                              onChangeLoginMethod: () {
                                data.changeLoginMethod();
                              },
                              onLogin: (isEmail) {
                                data.showLoader();
                                loginUser(isEmail);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Form(
                    key: data.isEmailLogin
                        ? loginPageController.emailFormKey
                        : loginPageController.mobileFormKey,
                    child: LoginBG(
                        shouldHaveBottomPadding: false,
                        child: LoginWidgetLargeScreens(
                          constraints: constraints,
                          loginPageController: loginPageController,
                          isEmail: data.isEmailLogin,
                          onChangeLoginMethod: () {
                            data.changeLoginMethod();
                          },
                          onLogin: (isEmail) {
                            data.showLoader();
                            loginUser(isEmail);
                          },
                        )),
                  );
          }));
    });
  }
}
