import 'dart:io';

import 'package:flutter/material.dart';

import '../../reusable_widgets/elevated_button.dart';
import '../../reusable_widgets/snackbar.dart';
import '../../reusable_widgets/text_widget.dart';
import '../../utils/custom_color_util.dart';
import '../../utils/size_config.dart';
import 'forgot_password_dialog.dart';
import 'login_controller.dart';

class LoginWidgetCompactScreens extends StatefulWidget {
  final BoxConstraints constraints;
  final LoginController loginPageController;
  final bool isEmail;
  final Function onChangeLoginMethod;
  final Function(bool) onLogin;
  const LoginWidgetCompactScreens(
      {Key? key,
        required this.constraints,
        required this.loginPageController,
        this.isEmail = false,
        required this.onChangeLoginMethod,
        required this.onLogin})
      : super(key: key);

  @override
  State<LoginWidgetCompactScreens> createState() =>
      _LoginWidgetCompactScreensState();
}

class _LoginWidgetCompactScreensState extends State<LoginWidgetCompactScreens> {
  var shouldObscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: widget.isEmail
              ? const EdgeInsets.symmetric(vertical: 6, horizontal: 12)
              : null,
          decoration: widget.isEmail
              ? BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10))
              : null,
          child: TextWidget(
            !widget.isEmail
                ? "Enter your mobile number"
                : "Enter the credentials to login",
            color: calculateContrast(Theme.of(context).colorScheme.primary,
                Theme.of(context).scaffoldBackgroundColor) <
                3
                ? Colors.grey[900]
                : Colors.white,
            weight: FontWeight.w500,
            size: Theme.of(context).textTheme.bodyMedium?.fontSize,
          ),
        ),
        SizedBox(
          height: getProportionateHeight(12, widget.constraints),
        ),
        !widget.isEmail
            ? TextFormField(
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            setState(() {});
          },
          onFieldSubmitted: (_) {
            widget.onLogin(widget.isEmail);
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              prefix: AnimatedContainer(
                width: widget.loginPageController.phoneTextEditController
                    .text.isNotEmpty
                    ? 40
                    : 0,
                duration: const Duration(milliseconds: 250),
                child: widget.loginPageController.phoneTextEditController
                    .text.isNotEmpty
                    ? TextWidget(
                  '+91',
                  size: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.fontSize,
                  weight: FontWeight.bold,
                  color: Colors.grey,
                )
                    : const SizedBox(),
              ),
              counterStyle: fonts(
                  Theme.of(context).textTheme.bodySmall?.fontSize,
                  FontWeight.normal,
                  Colors.white),
              hintStyle: fonts(
                  Theme.of(context).textTheme.bodyMedium?.fontSize,
                  FontWeight.w500,
                  Colors.grey[400]),
              prefixIcon: const Icon(Icons.phone_rounded),
              hintText: 'Phone number',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
              isDense: true,
              errorBorder: InputBorder.none),
          validator: (value) {
            if (value?.length != 10) {
              snackbar(context, "Please enter a valid mobile number");
              return " ";
            } else {
              return null;
            }
          },
          maxLength: 10,
          keyboardType: TextInputType.phone,
          controller: widget.loginPageController.phoneTextEditController,
        )
            : TextFormField(
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {},
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            isDense: true,
            prefixIcon: const Icon(Icons.email_rounded),
            hintStyle: fonts(
                Theme.of(context).textTheme.bodyMedium?.fontSize,
                FontWeight.w400,
                Colors.grey[400]),
            hintText: 'Email Address',
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
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
          controller: widget.loginPageController.emailTextEditController,
        ),
        widget.isEmail
            ? SizedBox(
          height: getProportionateHeight(10, widget.constraints),
        )
            : const SizedBox(),
        widget.isEmail
            ? TextFormField(
          obscureText: shouldObscureText,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            widget.onLogin(widget.isEmail);
          },
          decoration: InputDecoration(
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  setState(() {
                    shouldObscureText = false;
                  });
                }, //call this method when incontact
                onTapUp: (TapUpDetails details) {
                  setState(() {
                    shouldObscureText = true;
                  });
                }, //call this method when contact with screen is removed
                child: const Icon(
                  Icons.remove_red_eye,
                ),
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            isDense: true,
            prefixIcon: const Icon(Icons.lock_rounded),
            hintStyle: fonts(
                Theme.of(context).textTheme.bodyMedium?.fontSize,
                FontWeight.normal,
                Colors.grey[400]),
            hintText: 'Password',
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid password';
            }
            return null;
          },
          keyboardAppearance: Brightness.dark,
          controller:
          widget.loginPageController.passwordTextEditController,
        )
            : const SizedBox(),
        SizedBox(
          height: getProportionateHeight(
              widget.isEmail ? 10 : 0, widget.constraints),
        ),
        widget.isEmail
            ? Row(
          children: [
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary),
              onPressed: () {
                showForgotPasswordDialog(context, widget.constraints,
                    widget.loginPageController, false);
              },
              child: TextWidget(
                "Forgot Password",
                color: Theme.of(context).colorScheme.primary,
                weight: FontWeight.bold,
              ),
            ),
          ],
        )
            : const SizedBox(),
        SizedBox(
          height: getProportionateHeight(
              widget.isEmail ? 20 : 10, widget.constraints),
        ),
        ElevatedButtonWidget(
          onClick: () async {
            widget.onLogin(widget.isEmail);
          },
          height: getProportionateHeight(64, widget.constraints),
          bgColor: Theme.of(context).colorScheme.primary,
          borderSideColor: Theme.of(context).colorScheme.primary,
          buttonName: widget.isEmail ? "Login" : "Get OTP".toUpperCase(),
          borderRadius: 12,
          trailingIcon: Icons.arrow_forward,
        ),
        SizedBox(
          height: getProportionateHeight(8, widget.constraints),
        ),
        Platform.isAndroid || Platform.isIOS || Platform.isWindows
            ? TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary),
          onPressed: () {
            widget.onChangeLoginMethod();
          },
          child: TextWidget(
            widget.isEmail
                ? "or, Login With Mobile"
                : "or, Login With Email",
            color: calculateContrast(
                const Color(0xFF769F77),
                createMaterialColor(
                    Theme.of(context).colorScheme.primary)
                    .shade700) >
                1.5
                ? createMaterialColor(
                Theme.of(context).colorScheme.primary)
                .shade700
                : createMaterialColor(
                Theme.of(context).colorScheme.primary)
                .shade100,
            weight: FontWeight.w500,
          ),
        )
            : const SizedBox(),
        SizedBox(
          height: getProportionateHeight(15, widget.constraints),
        ),
        Column(
          children: [
            TextWidget(
              "I agree to the terms and conditions of",
              color: Colors.white,
              align: TextAlign.center,
              flow: TextOverflow.visible,
              size: Theme.of(context).textTheme.bodyMedium?.fontSize,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Nandikrushi",
              style: TextStyle(
                  color: calculateContrast(
                      const Color(0xFF769F77),
                      createMaterialColor(
                          Theme.of(context).colorScheme.primary)
                          .shade700) >
                      1.5
                      ? createMaterialColor(
                      Theme.of(context).colorScheme.primary)
                      .shade700
                      : createMaterialColor(
                      Theme.of(context).colorScheme.primary)
                      .shade100,
                  fontFamily: 'Samarkan',
                  fontSize: getProportionateHeight(32, widget.constraints)),
            ),
          ],
        ),
      ],
    );
  }
}
