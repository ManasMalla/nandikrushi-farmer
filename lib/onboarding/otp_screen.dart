// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the OTP Screen

import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_bg.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_controller.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import 'otp_screen_large.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final Function(String) onValidateOTP;
  final Function() onResendOTP;

  const OTPScreen(
      {Key? key,
      required this.phoneNumber,
      required this.onValidateOTP,
      required this.onResendOTP})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool canResendSMS = false;
  LoginController loginPageController = LoginController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(minutes: 2), () {
      setState(() {
        canResendSMS = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, data, _) {
      return LayoutBuilder(builder: (context, constraints) {
        return constraints.maxWidth < 600
            ? Scaffold(
                appBar: AppBar(
                    elevation: 0,
                    leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        ))),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image:
                              const AssetImage("assets/images/otp_image.png"),
                          height: getProportionateHeight(325, constraints),
                        ),
                        SizedBox(
                          height: getProportionateHeight(125, constraints),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              "Please enter the OTP",
                              weight: FontWeight.w500,
                              size: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.fontSize,
                              align: TextAlign.center,
                              flow: TextOverflow.visible,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextWidget(
                                  "sent to your mobile number",
                                  weight: FontWeight.w500,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontSize,
                                  align: TextAlign.center,
                                  height: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.height,
                                  flow: TextOverflow.visible,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                TextWidget(
                                  widget.phoneNumber,
                                  weight: FontWeight.w800,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontSize,
                                  align: TextAlign.center,
                                  flow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getProportionateHeight(48, constraints),
                        ),
                        Form(
                          key: loginPageController.otpFormKey,
                          child: Pinput(
                            length: 6,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            defaultPinTheme: PinTheme(
                              width: 48,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.outline),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            controller:
                                loginPageController.otpTextEditController,
                            forceErrorState: true,
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            onChanged: (pin) {
                              setState(() {});
                            },
                            onSubmitted: (pin) {
                              var isFormReadyForSubmission = loginPageController
                                      .otpFormKey.currentState
                                      ?.validate() ??
                                  false;
                              if (isFormReadyForSubmission) {
                                widget.onValidateOTP(loginPageController
                                    .otpTextEditController.text
                                    .toString());
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: getProportionateHeight(48, constraints),
                        ),
                        ElevatedButtonWidget(
                          onClick: () {
                            var isFormReadyForSubmission = loginPageController
                                    .otpFormKey.currentState
                                    ?.validate() ??
                                false;
                            if (isFormReadyForSubmission) {
                              widget.onValidateOTP(loginPageController
                                  .otpTextEditController.text
                                  .toString());
                            }
                          },
                          height: getProportionateHeight(64, constraints),
                          bgColor: loginPageController
                                      .otpTextEditController.text.length ==
                                  6
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceVariant,
                          textColor: loginPageController
                                      .otpTextEditController.text.length ==
                                  6
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          iconColor: loginPageController
                                      .otpTextEditController.text.length ==
                                  6
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          buttonName: "VERIFY OTP",
                          borderRadius: 12,
                          trailingIcon: Icons.arrow_forward,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextWidget(
                              "Didn't Recieve OTP?",
                              size:
                                  Theme.of(context).textTheme.button?.fontSize,
                              weight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            TextButton(
                              onPressed: () {
                                if (canResendSMS) {
                                  canResendSMS = false;

                                  widget.onResendOTP();
                                }
                              },
                              child: TextWidget(
                                "Resend".toUpperCase(),
                                weight: FontWeight.w700,
                                color: canResendSMS ? null : Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            : OTPScreenLarge(constraints, loginPageController,
                phoneNumber: widget.phoneNumber,
                onValidateOTP: widget.onValidateOTP,
                onResendOTP: widget.onResendOTP);
      });
    });
  }
}
