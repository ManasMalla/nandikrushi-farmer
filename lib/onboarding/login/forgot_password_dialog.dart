import 'package:flutter/material.dart';

import '../../reusable_widgets/elevated_button.dart';
import '../../reusable_widgets/snackbar.dart';
import '../../reusable_widgets/text_widget.dart';
import '../../utils/size_config.dart';
import 'login_controller.dart';

void showForgotPasswordDialog(
  BuildContext context,
  BoxConstraints constraints,
  LoginController loginPageController,
  bool isLargeScreen,
) {
  /*
                            https://nkweb.sweken.com/nkweb/index.php?route=extension/account/purpletree_multivendor/api/forgotpassword
                            */
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        child: AlertDialog(
          actionsPadding:
              isLargeScreen ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButtonWidget(
              onClick: () {
                Navigator.pop(context);
              },
              height: getProportionateHeight(48, constraints),
              minWidth: getProportionateWidth(150, constraints),
              bgColor: Colors.transparent,
              borderSideColor: Theme.of(context).colorScheme.primary,
              buttonName: "Cancel".toUpperCase(),
              textColor: Theme.of(context).colorScheme.primary,
              textStyle: FontWeight.w600,
              borderRadius: 12,
              center: true,
            ),
            ElevatedButtonWidget(
              onClick: () {
                var isFormReadyForOTP = loginPageController
                        .forgotPasswordFormKey.currentState
                        ?.validate() ??
                    false;
                if (isFormReadyForOTP) {
                  //TODO: Forgot password
                } else {
                  snackbar(context,
                      "Couldn't proccess your request at this moment. Please try again later!");
                }
              },
              height: getProportionateHeight(48, constraints),
              minWidth: getProportionateWidth(150, constraints),
              bgColor: Theme.of(context).colorScheme.primary,
              buttonName: "Send".toUpperCase(),
              borderRadius: 12,
              textColor: Colors.white,
              textStyle: FontWeight.w600,
              center: true,
            ),
          ],
          content: Padding(
            padding: isLargeScreen
                ? const EdgeInsets.only(
                    top: 24.0,
                    left: 24,
                    right: 24,
                  )
                : EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Nandikrushi',
                    style: TextStyle(
                      fontFamily: 'Samarkan',
                      fontSize: getProportionateHeight(34, constraints),
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: getProportionateHeight(24, constraints),
                ),
                Center(
                  child: TextWidget(
                    'Account Recovery',
                    size: Theme.of(context).textTheme.titleLarge?.fontSize,
                    weight: Theme.of(context).textTheme.titleLarge?.fontWeight,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextWidget(
                  'To help keep your account safe, Nandikrushi wants to make sure that\'s really you trying to sign in',
                  size: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                  weight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
                  flow: TextOverflow.visible,
                  align: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                const TextWidget(
                  'To get a verification code, first confirm the recovery email that you registered with',
                  flow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: loginPageController.forgotPasswordFormKey,
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {},
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_rounded),
                      hintStyle: fonts(
                          Theme.of(context).textTheme.bodyMedium?.fontSize,
                          FontWeight.w400,
                          Colors.grey[400]),
                      hintText: 'Email Address',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          !value.characters.contains("@") ||
                          !value.contains(".")) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller:
                        loginPageController.forgotPasswordTextEditController,
                  ),
                ),
              ],
            ),
          ),
          elevation: 10,
        ),
      );
    },
  );
}
