import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_controller.dart';
import 'package:pinput/pinput.dart';

import '../reusable_widgets/elevated_button.dart';
import '../reusable_widgets/text_widget.dart';
import '../utils/size_config.dart';
import 'login/login_bg.dart';

class OTPScreenLarge extends StatefulWidget {
  final String phoneNumber;
  final Function(String) onValidateOTP;
  final Function() onResendOTP;
  final BoxConstraints constraints;
  final LoginController loginPageController;

  const OTPScreenLarge(this.constraints, this.loginPageController,
      {Key? key,
      required this.phoneNumber,
      required this.onValidateOTP,
      required this.onResendOTP})
      : super(key: key);

  @override
  State<OTPScreenLarge> createState() => _OTPScreenLargeState();
}

class _OTPScreenLargeState extends State<OTPScreenLarge> {
  bool canResendSMS = false;

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 32),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.grey[900],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Row(children: [
          const Image(
            image: AssetImage("assets/images/otp_image.png"),
          ),
          SizedBox(
            width: getProportionateWidth(32, widget.constraints),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeToNandikrushi(
                  constraints: widget.constraints,
                  bottomSpacing: 128,
                ),
                TextWidget(
                  "Please enter the OTP sent to your mobile number",
                  color: Colors.grey.shade900,
                  weight: FontWeight.w500,
                  size: Theme.of(context).textTheme.bodyMedium?.fontSize,
                  align: TextAlign.start,
                  height: Theme.of(context).textTheme.bodyLarge?.height,
                  flow: TextOverflow.visible,
                ),
                SizedBox(
                  height: getProportionateHeight(12, widget.constraints),
                ),
                TextWidget(
                  "+91 ${widget.phoneNumber.substring(0, 5)} ${widget.phoneNumber.substring(5, 10)}",
                  color: Colors.black,
                  weight: FontWeight.w800,
                  size: Theme.of(context).textTheme.titleLarge?.fontSize,
                  align: TextAlign.start,
                  flow: TextOverflow.visible,
                ),
                SizedBox(
                  height: getProportionateHeight(48, widget.constraints),
                ),
                Form(
                  key: widget.loginPageController.otpFormKey,
                  child: Pinput(
                    length: 6,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    followingPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 2, color: Colors.grey.shade600),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    controller:
                        widget.loginPageController.otpTextEditController,
                    forceErrorState: true,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    onChanged: (pin) {
                      setState(() {});
                      //data.setOtp(pin.toString());
                    },
                    onSubmitted: (pin) {
                      var isFormReadyForSubmission = widget
                              .loginPageController.otpFormKey.currentState
                              ?.validate() ??
                          false;
                      if (isFormReadyForSubmission) {
                        widget.onValidateOTP(widget
                            .loginPageController.otpTextEditController.text
                            .toString());
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: getProportionateHeight(48, widget.constraints),
                ),
                ElevatedButtonWidget(
                  onClick: () {
                    var isFormReadyForSubmission = widget
                            .loginPageController.otpFormKey.currentState
                            ?.validate() ??
                        false;
                    if (isFormReadyForSubmission) {
                      widget.onValidateOTP(widget
                          .loginPageController.otpTextEditController.text
                          .toString());
                    }
                  },
                  height: getProportionateHeight(64, widget.constraints),
                  bgColor: widget.loginPageController.otpTextEditController.text
                              .length ==
                          6
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade400,
                  borderSideColor: widget.loginPageController
                              .otpTextEditController.text.length ==
                          6
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade500,
                  textColor: Colors.white,
                  buttonName: "VERIFY OTP",
                  borderRadius: 12,
                  trailingIcon: Icons.arrow_forward,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextWidget(
                      "Didn't Recieve OTP?",
                      size: Theme.of(context).textTheme.button?.fontSize,
                      weight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    TextButton(
                      onPressed: () {
                        if (canResendSMS) {
                          canResendSMS = false;
                          //RESEND OTP
                          widget.onResendOTP();
                        }
                      },
                      child: TextWidget(
                        "Resend".toUpperCase(),
                        weight: FontWeight.w700,
                        color:
                            canResendSMS ? Colors.grey.shade900 : Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
