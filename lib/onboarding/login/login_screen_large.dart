import 'dart:io';

import 'package:flutter/material.dart';

import '../../reusable_widgets/elevated_button.dart';
import '../../reusable_widgets/snackbar.dart';
import '../../reusable_widgets/text_widget.dart';
import '../../utils/size_config.dart';
import 'forgot_password_dialog.dart';
import 'login_controller.dart';

class LoginWidgetLargeScreens extends StatefulWidget {
  final BoxConstraints constraints;
  final LoginController loginPageController;
  final bool isEmail;
  final Function onChangeLoginMethod;
  final Function(bool) onLogin;
  const LoginWidgetLargeScreens(
      {Key? key,
        required this.constraints,
        required this.loginPageController,
        this.isEmail = true,
        required this.onChangeLoginMethod,
        required this.onLogin})
      : super(key: key);

  @override
  State<LoginWidgetLargeScreens> createState() =>
      _LoginWidgetLargeScreensState();
}

class _LoginWidgetLargeScreensState extends State<LoginWidgetLargeScreens> {
  var shouldObscureText = true;
  @override
  Widget build(BuildContext context) {
    print(widget.isEmail);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          widget.isEmail
              ? "Enter the credentials to login"
              : "Enter your mobile number",
          color: Colors.black,
          weight: FontWeight.w500,
          align: TextAlign.start,
          size: Theme.of(context).textTheme.titleMedium?.fontSize,
        ),
        SizedBox(
          height: getProportionateHeight(12, widget.constraints),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 32, top: 12),
          child: Column(
            children: [
              widget.isEmail
                  ? TextFormField(
                textInputAction: TextInputAction.next,
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
                widget.loginPageController.emailTextEditController,
              )
                  : TextFormField(
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
                      width: widget.loginPageController
                          .phoneTextEditController.text.isNotEmpty
                          ? 40
                          : 0,
                      duration: const Duration(milliseconds: 250),
                      child: widget.loginPageController
                          .phoneTextEditController.text.isNotEmpty
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
                        Theme.of(context).colorScheme.primary),
                    hintStyle: fonts(
                        Theme.of(context).textTheme.bodyMedium?.fontSize,
                        FontWeight.w500,
                        Colors.grey[400]),
                    prefixIcon: const Icon(Icons.phone_rounded),
                    hintText: 'Phone number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    isDense: true,
                    errorBorder: InputBorder.none),
                validator: (value) {
                  if (value?.length != 10) {
                    snackbar(
                        context, "Please enter a valid mobile number");
                  }
                  return null;
                },
                maxLength: 10,
                keyboardType: TextInputType.phone,
                controller:
                widget.loginPageController.phoneTextEditController,
              ),
              widget.isEmail
                  ? SizedBox(
                height: getProportionateHeight(20, widget.constraints),
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
                  prefixIcon: const Icon(Icons.lock_rounded),
                  hintStyle: fonts(
                      Theme.of(context).textTheme.bodyMedium?.fontSize,
                      FontWeight.normal,
                      Colors.grey[400]),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(16)),
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
                        foregroundColor:
                        Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      showForgotPasswordDialog(
                        context,
                        widget.constraints,
                        widget.loginPageController,
                        true,
                      );
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
                height: getProportionateHeight(20, widget.constraints),
              ),
              ElevatedButtonWidget(
                onClick: () async {
                  widget.onLogin(widget.isEmail);
                  // log(loginPageController!.numberController.text);
                  // loginPageController?.dataToEmail(context);
                },
                minWidth: double.infinity,
                height: getProportionateHeight(75, widget.constraints),
                borderRadius: 10,
                bgColor: Theme.of(context).colorScheme.primary,
                borderSideColor: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                buttonName: widget.isEmail ? "Login" : "Get OTP".toUpperCase(),
                trailingIcon: Icons.arrow_forward,
              ),
              Platform.isAndroid || Platform.isIOS || Platform.isWindows
                  ? SizedBox(
                height: getProportionateHeight(10, widget.constraints),
              )
                  : const SizedBox(),
              Platform.isAndroid || Platform.isIOS || Platform.isWindows
                  ? TextButton(
                style: TextButton.styleFrom(
                    foregroundColor:
                    Theme.of(context).colorScheme.primary),
                onPressed: () {
                  widget.onChangeLoginMethod();
                },
                child: TextWidget(
                  widget.isEmail
                      ? "or, Login With Mobile"
                      : "or, Login With Email",
                  color: Theme.of(context).colorScheme.primary,
                  weight: FontWeight.bold,
                ),
              )
                  : const SizedBox(),
              SizedBox(
                height: getProportionateHeight(20, widget.constraints),
              ),
              TextWidget(
                "I agree to the terms and conditions of",
                align: TextAlign.center,
                flow: TextOverflow.visible,
                size: Theme.of(context).textTheme.bodyMedium?.fontSize,
              ),
              Text(
                "Nandikrushi",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'Samarkan',
                    fontSize: getProportionateHeight(32, widget.constraints)),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 6,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Image.asset("assets/images/farmer_ploughing.png"),
          ),
        ),
      ],
    );
  }
}
