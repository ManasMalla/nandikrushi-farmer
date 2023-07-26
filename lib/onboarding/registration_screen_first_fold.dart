import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../reusable_widgets/elevated_button.dart';
import '../reusable_widgets/snackbar.dart';
import '../reusable_widgets/text_widget.dart';
import '../reusable_widgets/textfield_widget.dart';
import '../utils/size_config.dart';
import 'login/login_controller.dart';
import 'login/login_provider.dart';

class RegistrationDetailsFirstPage extends StatelessWidget {
  final LoginController loginPageController;
  final setState;
  final LoginProvider loginProvider;
  final BoxConstraints constraints;
  final void Function(
      {required BoxConstraints constraints,
      dynamic context,
      required Function(XFile p1) onImageSelected,
      dynamic setState}) showImagePickerSheet;
  const RegistrationDetailsFirstPage(
    this.loginPageController,
    this.setState,
    this.loginProvider,
    this.constraints,
    this.showImagePickerSheet, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              loginProvider.isFarmer
                  ? loginPageController.profileImage == null
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  iconSize: 75,
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () {
                                    log("add image key presses");
                                    showImagePickerSheet(
                                        context: context,
                                        setState: setState,
                                        constraints: constraints,
                                        onImageSelected: (XFile profileImage) {
                                          loginPageController.profileImage =
                                              profileImage;
                                        });
                                  },
                                  splashRadius: 42,
                                  icon: const Icon(Icons.add_a_photo_rounded),
                                ),
                                TextWidget(
                                  "Add ${loginProvider.isFarmer ? "Farmer" : "your"} Image",
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7),
                                  weight: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontWeight,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontSize,
                                )
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Stack(
                              children: [
                                Center(
                                  child: ClipOval(
                                      child: Image.file(
                                    File(loginPageController
                                            .profileImage?.path ??
                                        ""),
                                    height: 96,
                                    width: 96,
                                    fit: BoxFit.cover,
                                  )),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      onPressed: () {
                                        showImagePickerSheet(
                                            constraints: constraints,
                                            onImageSelected:
                                                (XFile profileImage) {
                                              loginPageController.profileImage =
                                                  profileImage;
                                            });
                                      },
                                      icon: Icon(Icons.edit_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                  : const SizedBox(),
              !loginProvider.isFarmer
                  ? loginPageController.storeLogo == null
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  iconSize: 75,
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () {
                                    showImagePickerSheet(
                                        constraints: constraints,
                                        context: context,
                                        onImageSelected: (XFile storeLogo) {
                                          loginPageController.storeLogo =
                                              storeLogo;
                                        },
                                        setState: setState);
                                  },
                                  splashRadius: 42,
                                  icon: const Icon(Icons.add_a_photo_rounded),
                                ),
                                TextWidget(
                                  "Add ${loginProvider.userAppTheme.key.contains("Store") ? "Store" : "Restaurant"} Logo",
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7),
                                  weight: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontWeight,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.fontSize,
                                )
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Stack(
                              children: [
                                Center(
                                  child: ClipOval(
                                      child: Image.file(
                                    File(loginPageController.storeLogo?.path ??
                                        ""),
                                    height: 96,
                                    width: 96,
                                    fit: BoxFit.cover,
                                  )),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      onPressed: () {
                                        showImagePickerSheet(
                                            context: context,
                                            constraints: constraints,
                                            setState: setState,
                                            onImageSelected: (XFile storeLogo) {
                                              loginPageController.storeLogo =
                                                  storeLogo;
                                            });
                                      },
                                      icon: Icon(
                                        Icons.edit_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                  : const SizedBox()
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 32,
            right: 32,
            bottom: 24,
            top: 8,
          ),
          child: Form(
            key: loginPageController.registrationFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  "${loginProvider.isFarmer ? "Farmer" : loginProvider.userAppTheme.key.contains("Store") ? "Store" : "Restaurant"} Information",
                  weight: Theme.of(context).textTheme.titleMedium?.fontWeight,
                  size: Theme.of(context).textTheme.titleMedium?.fontSize,
                ),
                const SizedBox(
                  height: 16,
                ),
                loginProvider.isFarmer
                    ? Row(
                        children: [
                          Expanded(
                            child: TextFieldWidget(
                              controller: loginPageController
                                      .registrationPageFormControllers[
                                  'first_name'],
                              label:
                                  "${loginProvider.isFarmer ? "Farmer's" : ""} First Name",
                              validator: (value) {
                                if (value?.isEmpty ?? false) {
                                  return snackbar(context,
                                      "Please enter a valid first name");
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: TextFieldWidget(
                              controller: loginPageController
                                  .registrationPageFormControllers['last_name'],
                              label:
                                  "${loginProvider.isFarmer ? "Farmer's" : ""} Last Name",
                              validator: (value) {
                                if (value?.isEmpty ?? false) {
                                  return snackbar(context,
                                      "Please enter a valid last name");
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(
                  height: loginProvider.isFarmer ? 8 : 0,
                ),
                !loginProvider.isFarmer
                    ? TextFieldWidget(
                        controller: loginPageController
                            .registrationPageFormControllers['storeName'],
                        label:
                            "${loginProvider.userAppTheme.key.contains("Store") ? "Store" : "Restaurant"}'s Name",
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return snackbar(context,
                                "Please enter a valid ${loginProvider.userAppTheme.key.contains("Store") ? "Store" : "Restaurant"} name");
                          }
                          return null;
                        },
                      )
                    : const SizedBox(),
                !loginProvider.isFarmer
                    ? const SizedBox(
                        height: 8,
                      )
                    : const SizedBox(),
                TextFieldWidget(
                    controller: loginPageController
                        .registrationPageFormControllers['email'],
                    label: 'Email Address',
                    validator: (value) {
                      if (value?.isNotEmpty ?? false) {
                        if (!(value?.contains("@") ?? false) &&
                            !(value?.contains(".") ?? false)) {
                          return snackbar(
                              context, "Please enter a valid email address");
                        }
                        return null;
                      }
                    }),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                          controller: loginPageController
                              .registrationPageFormControllers['password'],
                          label: 'Create Password',
                          obscureText: true,
                          validator: (value) {
                            if (loginPageController
                                    .registrationPageFormControllers['email']
                                    ?.text !=
                                "") {
                              if (value?.isEmpty ?? false) {
                                return snackbar(
                                    context, "Please enter password");
                              }
                              return null;
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextFieldWidget(
                          controller: loginPageController
                              .registrationPageFormControllers['c_password'],
                          label: 'Confirm Password',
                          obscureText: true,
                          validator: (value) {
                            if ((loginPageController
                                    .registrationPageFormControllers['email']
                                    ?.text !=
                                "")) {
                              log("empty field");
                              if (value?.isEmpty ?? false) {
                                return snackbar(
                                    context, "Enter confirm password");
                              }
                              if (value !=
                                  loginPageController
                                      .registrationPageFormControllers[
                                          'password']
                                      ?.text) {
                                return snackbar(
                                    context, "Oops! Passwords mismatched");
                              }
                            }
                            return null;
                          }),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                TextWidget(
                  "Location Details",
                  weight: Theme.of(context).textTheme.titleMedium?.fontWeight,
                  size: Theme.of(context).textTheme.titleMedium?.fontSize,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        controller: loginPageController
                            .registrationPageFormControllers['state'],
                        label: 'State',
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return snackbar(
                                context, "Please enter a valid state");
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextFieldWidget(
                        controller: loginPageController
                            .registrationPageFormControllers['district'],
                        label: 'District',
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return snackbar(
                                context, "Please enter a valid district");
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        controller: loginPageController
                            .registrationPageFormControllers['mandal'],
                        label: 'Locality',
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return snackbar(
                                context, "Please enter a valid locality");
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextFieldWidget(
                        controller: loginPageController
                            .registrationPageFormControllers['city'],
                        label: 'City/Vilage',
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return snackbar(
                                context, "Please enter a valid city/village");
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        controller: loginPageController
                            .registrationPageFormControllers['house_number'],
                        label: 'H.No.',
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return snackbar(
                                context, "Please enter a valid house number");
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextFieldWidget(
                        textInputAction: TextInputAction.done,
                        controller: loginPageController
                            .registrationPageFormControllers['pincode'],
                        label: 'Pincode',
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return snackbar(
                                context, "Please enter a valid pincode");
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        constraints.maxWidth < 500
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: ElevatedButtonWidget(
                    onClick: () async {
                      var formValidatedState = loginPageController
                              .registrationFormKey.currentState
                              ?.validate() ??
                          false;

                      if (formValidatedState) {
                        if (loginPageController.profileImage == null &&
                            loginProvider.isFarmer) {
                          formValidatedState = false;
                          snackbar(
                              context,
                              "Please upload ${loginProvider.isFarmer ? "the Farmer" : loginProvider.userAppTheme.key.contains("Store") ? "your" : "your"} image");
                        }
                        if (!loginProvider.isFarmer) {
                          if (loginPageController.storeLogo == null) {
                            formValidatedState = false;
                            snackbar(context,
                                "Please upload the ${loginProvider.userAppTheme.key.contains("Store") ? "Store" : "Restaurant"}'s logo");
                          }
                        }
                        if (formValidatedState) {
                          await loginPageController.pageController
                              .animateToPage(1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                        }
                      }
                    },
                    height: getProportionateHeight(64, constraints),
                    borderRadius: 12,
                    buttonName: "Next".toUpperCase(),
                    innerPadding: 0.02,
                    trailingIcon: Icons.arrow_forward),
              )
            : const SizedBox(),
      ],
    );
  }
}
