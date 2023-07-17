
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_controller.dart';
import 'package:nandikrushi_farmer/utils/login_utils.dart';

import '../nav_host.dart';
import '../reusable_widgets/elevated_button.dart';
import '../reusable_widgets/snackbar.dart';
import '../reusable_widgets/text_widget.dart';
import '../utils/size_config.dart';
import 'login/login_provider.dart';

List<Widget> registrationDetailsSecondPage(BuildContext context,LoginController loginPageController, setState,
    LoginProvider loginProvider, BoxConstraints constraints, showImagePickerSheet) {
  return [
    Container(
      margin: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          loginProvider.isFarmer
              ? TextWidget(
            "Cultivated Land Area (in acres)",
            weight: Theme.of(context).textTheme.titleMedium?.fontWeight,
            size: Theme.of(context).textTheme.titleMedium?.fontSize,
          )
              : const SizedBox(),
          const SizedBox(
            height: 20,
          ),
          loginProvider.isFarmer
              ? SliderTheme(
            data: SliderThemeData(
              activeTickMarkColor:
              Theme.of(context).colorScheme.onPrimary,
              inactiveTickMarkColor:
              Theme.of(context).colorScheme.onPrimary,
            ),
            child: Slider(
                divisions: 30,
                thumbColor: Theme.of(context).colorScheme.primary,
                activeColor: Theme.of(context).colorScheme.primary,
                inactiveColor: const Color(0x16006838),
                value: loginPageController.landInAcres,
                max: 30,
                min: 1,
                label:
                loginPageController.landInAcres.round().toString(),
                // ignore: avoid_types_as_parameter_names
                onChanged: (num) {
                  setState(() {
                    loginPageController.landInAcres = num;
                  });
                }),
          )
              : const SizedBox(),
          const SizedBox(
            height: 20,
          ),
          TextWidget(
            "Select Certification Details",
            weight: Theme.of(context).textTheme.titleMedium?.fontWeight,
            size: Theme.of(context).textTheme.titleMedium?.fontSize,
          ),
        ],
      ),
    ),
    SizedBox(
      width: double.infinity,
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: loginProvider.certificationList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  if (loginPageController.userCertificates.isNotEmpty) {
                    if (loginPageController
                        .userCertificates[index].isNotEmpty) {
                      loginPageController.userCertificates[index] = [];
                    }
                  }
                  loginPageController.userCertification =
                  loginProvider.certificationList[index];
                  loginPageController
                      .registrationPageFormControllers["reg_number"]
                      ?.text = "";
                });
              },
              child: Container(
                color: loginPageController.userCertification ==
                    loginProvider.certificationList[index]
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.5)),
                              activeColor: loginProvider.userAppTheme.key
                                  .contains("Restaraunts")
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              checkColor:
                              Theme.of(context).colorScheme.primary,
                              value: loginPageController.userCertification ==
                                  loginProvider.certificationList[index],
                              onChanged: (boolean) {
                                setState(() {
                                  if (loginPageController
                                      .userCertificates.isNotEmpty) {
                                    if (loginPageController
                                        .userCertificates[index].isNotEmpty) {
                                      loginPageController
                                          .userCertificates[index] = [];
                                    }
                                  }
                                  loginPageController.userCertification =
                                  loginProvider.certificationList[index];
                                  loginPageController
                                      .registrationPageFormControllers[
                                  "reg_number"]
                                      ?.text = "";
                                });
                              }),
                          Expanded(
                            child: SizedBox(
                              child: TextWidget(
                                loginProvider.certificationList[index],
                                weight: FontWeight.w500,
                                color: loginPageController
                                    .userCertification ==
                                    loginProvider.certificationList[index]
                                    ? loginProvider.userAppTheme.key
                                    .contains("Restaraunts")
                                    ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    : Colors.white
                                    : null,
                              ),
                            ),
                          )
                        ]),
                    (loginProvider.isFarmer ? index != 0 : true) &&
                        index != 5 &&
                        loginPageController.userCertification ==
                            loginProvider.certificationList[index]
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 42,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  "Reference Number",
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary,
                                ),
                                SizedBox(
                                  width: getProportionateWidth(
                                      136, constraints),
                                  child: Form(
                                    key: loginPageController
                                        .registrationFormSecondPageKey,
                                    child: TextFormField(
                                      textInputAction:
                                      TextInputAction.done,
                                      onChanged: (_) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                          filled: true,
                                          contentPadding:
                                          const EdgeInsets
                                              .symmetric(
                                              vertical: 8,
                                              horizontal: 16),
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          counterStyle: fonts(
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.fontSize,
                                              FontWeight.normal,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                          hintStyle: fonts(
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.fontSize,
                                              FontWeight.w500,
                                              Colors.grey[400]),
                                          hintText:
                                          'Registration Number',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10.0),
                                          ),
                                          isDense: true,
                                          errorBorder:
                                          InputBorder.none),
                                      validator: (value) {
                                        if (value?.isEmpty ?? false) {
                                          snackbar(context,
                                              "Please enter a valid certificate registration number");
                                          return " ";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: loginPageController
                                          .registrationPageFormControllers[
                                      "reg_number"],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                "Upload Certificate",
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary,
                              ),
                              Row(
                                children: [
                                  MaterialButton(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16),
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                      onPressed: () {
                                        if (loginPageController
                                            .registrationPageFormControllers[
                                        "reg_number"]
                                            ?.text
                                            .toString()
                                            .isNotEmpty ??
                                            false) {
                                          showImagePickerSheet(
                                            constraints: constraints,
                                            onImageSelected:
                                                (XFile certificate) {
                                              if (loginPageController
                                                  .userCertificates
                                                  .isEmpty) {
                                                for (var _ in loginProvider
                                                    .certificationList) {
                                                  loginPageController
                                                      .userCertificates
                                                      .add([]);
                                                }
                                              }
                                              loginPageController
                                                  .userCertificates[
                                              index]
                                                  .add(certificate);
                                            },
                                          );
                                        } else {
                                          snackbar(context,
                                              "Please enter a valid registration number before uploading the respective document!");
                                        }
                                      },
                                      child: const TextWidget(
                                        "Choose File",
                                      )),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                        ],
                      ),
                    )
                        : const SizedBox(),
                    (loginProvider.isFarmer ? index != 0 : true) &&
                        index != 5 &&
                        loginPageController.userCertificates.isNotEmpty &&
                        loginPageController.userCertification ==
                            loginProvider.certificationList[index] &&
                        loginPageController
                            .userCertificates[index].isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(left: 96),
                      child: SizedBox(
                        height: 120,
                        child: ListView.builder(
                          itemCount: loginPageController
                              .userCertificates[index].length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, imageIndex) {
                            // log(registrationController
                            //    .userCertificates);
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    child: Image.file(
                                      File(loginPageController
                                          .userCertificates[index]
                                      [imageIndex]
                                          .path),
                                      height: 96,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      onPressed: () {
                                        loginPageController
                                            .userCertificates[index]
                                            .removeAt(imageIndex);
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    )
                        : const SizedBox()
                  ],
                ),
              ),
            );
          }),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 16,
      ),
      child: ElevatedButtonWidget(
        onClick: () async {
          if (constraints.maxWidth < 500) {
            var formValidatedState = loginPageController
                .registrationFormSecondPageKey.currentState
                ?.validate() ??
                true;

            if (loginPageController.landInAcres > 1 ||
                !loginProvider.isFarmer) {
              if (formValidatedState &&
                  loginPageController.userCertification.isNotEmpty) {
                if ((loginPageController.userCertification.isNotEmpty &&
                    loginPageController.userCertificates
                        .where((element) => element.isNotEmpty)
                        .isNotEmpty) ||
                    loginPageController
                        .registrationFormSecondPageKey.currentState ==
                        null) {
                  loginProvider.registerUser(
                      loginPageController: loginPageController,
                      onError: (error) {
                        snackbar(context, error);
                      },
                      onSuccess: (name, _, uID, cID) {
                        snackbar(context,
                            "Welcome to the Nandikrushi family, $name!",
                            isError: false);
                        loginProvider.showLoader();
                        context.setAsReturningUser(uID);
                        Navigator.maybeOf(context)?.push(
                          MaterialPageRoute(
                            builder: (context) => NandikrushiNavHost(
                              userId: uID,
                            ),
                          ),
                        );
                      },
                      navigator: Navigator.of(context));
                } else {
                  snackbar(context, "Please upload a valid certificate");
                }
              } else {
                snackbar(context, "Please select a certification type");
              }
            } else {
              snackbar(context,
                  "Please select your cultivated land in acres with the slider");
            }
          } else {
            var formValidatedState = loginPageController
                .registrationFormKey.currentState
                ?.validate() ??
                false;

            if (formValidatedState) {
              log((loginPageController.profileImage == null &&
                  loginProvider.isFarmer)
                  .toString());
              if (loginPageController.profileImage == null &&
                  loginProvider.isFarmer) {
                formValidatedState = false;
                snackbar(context, "Please upload the Farmer image");
              }
              if (!loginProvider.isFarmer) {
                if (loginPageController.storeLogo == null) {
                  formValidatedState = false;
                  snackbar(context,
                      "Please upload the ${loginProvider.userAppTheme.key.contains("Store") ? "Store" : "Restaurant"}'s logo");
                }
              }

              if (formValidatedState) {
                var formValidatedState = loginPageController
                    .registrationFormSecondPageKey.currentState
                    ?.validate() ??
                    true;

                if (loginPageController.landInAcres > 1 ||
                    !loginProvider.isFarmer) {
                  if (formValidatedState &&
                      loginPageController.userCertification.isNotEmpty) {
                    if ((loginPageController.userCertification.isNotEmpty &&
                        loginPageController.userCertificates
                            .where((element) => element.isNotEmpty)
                            .isNotEmpty) ||
                        loginPageController
                            .registrationFormSecondPageKey.currentState ==
                            null) {
                      loginProvider.registerUser(
                          loginPageController: loginPageController,
                          onError: (error) {
                            snackbar(context, error);
                          },
                          onSuccess: (name, _, uID, cID) {
                            snackbar(context,
                                "Welcome to the Nandikrushi family, $name!",
                                isError: false);
                            loginProvider.showLoader();
                            context.setAsReturningUser(uID);
                            Navigator.maybeOf(context)?.push(
                              MaterialPageRoute(
                                builder: (context) => NandikrushiNavHost(
                                  userId: uID,
                                ),
                              ),
                            );
                          },
                          navigator: Navigator.of(context));
                    } else {
                      snackbar(context, "Please upload a valid certificate");
                    }
                  } else {
                    snackbar(context, "Please select a certification type");
                  }
                } else {
                  snackbar(context,
                      "Please select your cultivated land in acres with the slider");
                }
              }
            }
          }
        },
        height: getProportionateHeight(64, constraints),
        borderRadius: 12,
        buttonName: "Submit".toUpperCase(),
        trailingIcon: Icons.check_rounded,
      ),
    ),
  ];
}

