// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Edit Profile Screen

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nandikrushi_farmer/nav_items/profile_address_workflow.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_controller.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/loader_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/material_you_clipper.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/textfield_widget.dart';
import 'package:nandikrushi_farmer/utils/firebase_storage_utils.dart';
import 'package:nandikrushi_farmer/utils/server.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LoginController loginPageController = LoginController();
  @override
  void initState() {
    super.initState();
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    loginPageController.getDataFromProvider(profileProvider);
  }

  @override
  Widget build(BuildContext context) {
    void showImagePickerSheet(
        {required Function(XFile) onImageSelected,
        required BoxConstraints constraints}) {
      showModalBottomSheet(
          context: context,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Consumer<ProfileProvider>(
                  builder: (context, profileProvider, _) {
                return Container(
                  height: getProportionateHeight(300, constraints),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        "Choose Profile Picture",
                        size: Theme.of(context).textTheme.titleLarge?.fontSize,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextWidget(
                        "Choose an image as a profile picture from one of the following sources",
                        flow: TextOverflow.visible,
                        size: Theme.of(context).textTheme.bodyLarge?.fontSize,
                        weight:
                            Theme.of(context).textTheme.bodyLarge?.fontWeight,
                      ),
                      const Spacer(),
                      Row(
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Icon(Icons.photo_library_rounded, size: 48),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 3,
                            child: Icon(Icons.camera_alt_rounded, size: 48),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () async {
                                var pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {
                                  Navigator.of(context).pop();
                                  if (pickedImage != null) {
                                    onImageSelected(pickedImage);
                                  } else {
                                    Future.delayed(
                                        const Duration(milliseconds: 300), () {
                                      snackbar(context,
                                          "The image you selected is empty or you didn't select an image.");
                                    });
                                  }
                                });
                              },
                              child: const Text(
                                "Gallery",
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () async {
                                var pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                setState(() {
                                  Navigator.of(context).pop();
                                  if (pickedImage != null) {
                                    onImageSelected(pickedImage);
                                  } else {
                                    Future.delayed(
                                        const Duration(milliseconds: 300), () {
                                      snackbar(context,
                                          "The image you selected is empty or you didn't select an image.");
                                    });
                                  }
                                });
                              },
                              child: const Text("Camera"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
            });
          });
    }

    return Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      return Consumer<LoginProvider>(builder: (context, loginProvider, _) {
        var phoneNumberController = TextEditingController();
        return Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return Scaffold(
                  body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: SizedBox(
                        height: 300,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              height: 500,
                              child: GoogleMap(
                                zoomControlsEnabled: false,
                                mapToolbarEnabled: false,
                                markers: {
                                  Marker(
                                    markerId: const MarkerId("Home"),
                                    position: LatLng(
                                        double.tryParse(
                                                profileProvider.storeAddress[
                                                        "coordinates-x"] ??
                                                    "17.744062") ??
                                            17.744062,
                                        double.tryParse(
                                                profileProvider.storeAddress[
                                                        "coordinates-y"] ??
                                                    "83.335216") ??
                                            83.335216),
                                  ),
                                },
                                onTap: (_) {},
                                initialCameraPosition: CameraPosition(
                                  bearing: 0,
                                  target: LatLng(
                                      double.tryParse(
                                              profileProvider.storeAddress[
                                                      "coordinates-x"] ??
                                                  "17.744062") ??
                                          17.744062,
                                      (double.tryParse(
                                              profileProvider.storeAddress[
                                                      "coordinates-y"] ??
                                                  "83.335216") ??
                                          83.335216)),
                                  tilt: 0,
                                  zoom: 15,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  //_controller.complete(controller);
                                },
                              ),
                            ),

                            // Positioned(
                            //   width: 300,
                            //   height: 300,
                            //   top: -130,
                            //   child: ClipPath(
                            //     clipBehavior:
                            //         Clip.antiAliasWithSaveLayer,
                            //     clipper: MaterialClipper(),
                            //     child: GoogleMap(
                            //       markers: {
                            //         Marker(
                            //           markerId: const MarkerId("Home"),
                            //           position: LatLng(
                            //               double.tryParse(profileProvider
                            //                               .storeAddress[
                            //                           "coordinates-x"] ??
                            //                       "17.744062") ??
                            //                   17.744062,
                            //               double.tryParse(profileProvider
                            //                               .storeAddress[
                            //                           "coordinates-y"] ??
                            //                       "83.335216") ??
                            //                   83.335216),
                            //         ),
                            //       },
                            //       onTap: (_) {},
                            //       initialCameraPosition: CameraPosition(
                            //         bearing: 0,
                            //         target: LatLng(
                            //             double.tryParse(profileProvider
                            //                             .storeAddress[
                            //                         "coordinates-x"] ??
                            //                     "17.744062") ??
                            //                 17.744062,
                            //             (double.tryParse(profileProvider
                            //                             .storeAddress[
                            //                         "coordinates-y"] ??
                            //                     "83.335216") ??
                            //                 83.335216)),
                            //         tilt: 0,
                            //         zoom: 15,
                            //       ),
                            //       onMapCreated:
                            //           (GoogleMapController controller) {
                            //         //_controller.complete(controller);
                            //       },
                            //     ),
                            //   ),
                            // ),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileAddressWorkflow(
                                          controller: loginPageController,
                                          constraints: constraints,
                                        )));
                              },
                              child: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                              ),
                            ),

                            // Positioned(
                            //   width: 300,
                            //   height: 300,
                            //   top: -130,
                            //   child: ClipPath(
                            //     clipper: MaterialClipper(),
                            //     clipBehavior:
                            //         Clip.antiAliasWithSaveLayer,
                            //     child: InkWell(
                            //       splashColor: Colors.transparent,
                            //       onTap: () {
                            //         Navigator.of(context).push(
                            //             MaterialPageRoute(
                            //                 builder: (context) =>
                            //                     ProfileAddressWorkflow(
                            //                       controller:
                            //                           loginPageController,
                            //                       constraints:
                            //                           constraints,
                            //                     )));
                            //       },
                            //       child: Container(
                            //         color: Theme.of(context)
                            //             .colorScheme
                            //             .primary
                            //             .withOpacity(0.5),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // const Positioned(
                            //   top: 50,
                            //   right: 100,
                            //   child: Icon(
                            //     Icons.edit_rounded,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            Positioned(
                              bottom: -50,
                              right: 18,
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: !(!(loginPageController.profileImage !=
                                                  null ||
                                              profileProvider
                                                  .sellerImage.isNotEmpty) ||
                                          loginPageController.storeLogo !=
                                              null ||
                                          profileProvider.storeLogo.isNotEmpty)
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    loginProvider.isFarmer
                                        ? (loginPageController.profileImage !=
                                                    null ||
                                                profileProvider
                                                    .sellerImage.isNotEmpty)
                                            ? Expanded(
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 120,
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: ClipPath(
                                                            clipper:
                                                                MaterialClipper(),
                                                            child: loginPageController
                                                                        .profileImage !=
                                                                    null
                                                                ? Image.file(
                                                                    File(loginPageController
                                                                            .profileImage
                                                                            ?.path ??
                                                                        ""),
                                                                    height: 108,
                                                                    width: 108,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Image.network(
                                                                    profileProvider
                                                                        .sellerImage,
                                                                    height: 108,
                                                                    width: 108,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 8,
                                                          right: 8,
                                                          child: Container(
                                                            width: 32,
                                                            height: 32,
                                                            decoration: BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                showImagePickerSheet(
                                                                    constraints:
                                                                        constraints,
                                                                    onImageSelected:
                                                                        (XFile
                                                                            profileImage) {
                                                                      setState(
                                                                          () {
                                                                        loginPageController.profileImage =
                                                                            profileImage;
                                                                      });
                                                                    });
                                                              },
                                                              icon: Icon(
                                                                  Icons
                                                                      .edit_rounded,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary,
                                                                  size: 16),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        iconSize: 75,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        onPressed: () {
                                                          showImagePickerSheet(
                                                              constraints:
                                                                  constraints,
                                                              onImageSelected:
                                                                  (XFile
                                                                      profileImage) {
                                                                loginPageController
                                                                        .profileImage =
                                                                    profileImage;
                                                              });
                                                        },
                                                        splashRadius: 42,
                                                        icon: const Icon(Icons
                                                            .add_a_photo_rounded),
                                                      ),
                                                      TextWidget(
                                                        "Add ${loginProvider.isFarmer ? "Farmer" : "your"} Image",
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(0.7),
                                                        weight:
                                                            Theme.of(context)
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
                                        : const SizedBox(),
                                    !loginProvider.isFarmer
                                        ? !(loginPageController.storeLogo !=
                                                    null ||
                                                profileProvider
                                                    .storeLogo.isNotEmpty)
                                            ? Expanded(
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        iconSize: 75,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        onPressed: () {
                                                          showImagePickerSheet(
                                                              constraints:
                                                                  constraints,
                                                              onImageSelected:
                                                                  (XFile
                                                                      storeLogo) {
                                                                loginPageController
                                                                        .storeLogo =
                                                                    storeLogo;
                                                              });
                                                        },
                                                        splashRadius: 42,
                                                        icon: const Icon(Icons
                                                            .add_a_photo_rounded),
                                                      ),
                                                      TextWidget(
                                                        "Add ${loginProvider.userAppTheme.key.contains("Store") ? "Store" : "Restaurant"} Logo",
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(0.7),
                                                        weight:
                                                            Theme.of(context)
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
                                                  child: SizedBox(
                                                    width: 96,
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: ClipOval(
                                                            child: loginPageController
                                                                        .storeLogo !=
                                                                    null
                                                                ? Image.file(
                                                                    File(loginPageController
                                                                            .storeLogo
                                                                            ?.path ??
                                                                        ""),
                                                                    height: 96,
                                                                    width: 96,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Image.network(
                                                                    profileProvider
                                                                        .storeLogo,
                                                                    height: 96,
                                                                    width: 96,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 8,
                                                          right: 8,
                                                          child: Container(
                                                            width: 32,
                                                            height: 32,
                                                            decoration: BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                showImagePickerSheet(
                                                                    constraints:
                                                                        constraints,
                                                                    onImageSelected:
                                                                        (XFile
                                                                            storeLogo) {
                                                                      setState(
                                                                          () {
                                                                        loginPageController.storeLogo =
                                                                            storeLogo;
                                                                      });
                                                                    });
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .edit_rounded,
                                                                color: Theme.of(
                                                                        context)
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
                                                ),
                                              )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Form(
                        key: loginPageController.registrationFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_pin_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                TextWidget(
                                  'Profile',
                                  size: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.fontSize,
                                  weight: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.fontWeight,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),
                            TextWidget(
                              "${loginProvider.isFarmer ? "Farmer" : loginProvider.userAppTheme.key.contains("Store") ? "Store" : "Restaurant"} Information",
                              color: Colors.grey.shade800,
                              weight: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.fontWeight,
                              size: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.fontSize,
                            ),
                            SizedBox(
                              height: loginProvider.isFarmer ? 8 : 0,
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
                                                  .registrationPageFormControllers[
                                              'last_name'],
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
                              height: loginProvider.isFarmer ? 0 : 16,
                            ),
                            !loginProvider.isFarmer
                                ? TextFieldWidget(
                                    controller: loginPageController
                                            .registrationPageFormControllers[
                                        'storeName'],
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

                            const SizedBox(
                              height: 8,
                            ),
                            TextFieldWidget(
                              controller: loginPageController
                                  .registrationPageFormControllers['email'],
                              label: 'Email Address',
                              validator: (value) {
                                if (!(value?.contains("@") ?? false) &&
                                    !(value?.contains(".") ?? false)) {
                                  return snackbar(context,
                                      "Please enter a valid email address");
                                }
                                return null;
                              },
                            ),
                            // const SizedBox(
                            //   height: 4,
                            // ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: TextFieldWidget(
                            //         controller: loginPageController
                            //                 .registrationPageFormControllers[
                            //             'password'],
                            //         label: 'Create Password',
                            //         obscureText: true,
                            //         validator: (value) {
                            //           if (value?.isEmpty ?? false) {
                            //             return snackbar(context,
                            //                 "Please enter a valid password");
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //     const SizedBox(width: 24),
                            //     Expanded(
                            //       child: TextFieldWidget(
                            //         controller: loginPageController
                            //                 .registrationPageFormControllers[
                            //             'c_password'],
                            //         label: 'Confirm Password',
                            //         obscureText: true,
                            //         validator: (value) {
                            //           if ((value?.isEmpty ?? false) &&
                            //               value ==
                            //                   loginPageController
                            //                       .registrationPageFormControllers[
                            //                           'password']
                            //                       ?.text
                            //                       .toString()) {
                            //             return snackbar(context,
                            //                 "Oops! Passwords mismatch");
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        "Certification",
                                        color: Colors.grey.shade800,
                                        weight: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.fontWeight,
                                        size: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.fontSize,
                                      ),
                                      const SizedBox(height: 8),
                                      TextWidget(
                                        loginPageController
                                                .userCertification.isEmpty
                                            ? profileProvider.certificationType
                                            : loginPageController
                                                .userCertification,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        weight: FontWeight.w400,
                                        size: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.fontSize,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) {
                                          return Wrap(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                    borderRadius:
                                                        const BorderRadius
                                                                .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    24))),
                                                child: certificationBottomSheet(
                                                    loginProvider,
                                                    loginPageController,
                                                    setState,
                                                    constraints,
                                                    showImagePickerSheet,
                                                    context),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(
                                    Icons.edit_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                  ),
                                )
                              ],
                            ),

                            Row(
                              children: [
                                TextWidget(
                                  (loginPageController
                                                  .registrationPageFormControllers[
                                                      "reg_number"]
                                                  ?.text
                                                  .toString() ??
                                              "")
                                          .isEmpty
                                      ? profileProvider.certificateID.isEmpty
                                          ? "AP123239230MNS"
                                          : profileProvider.certificateID
                                      : loginPageController
                                          .registrationPageFormControllers[
                                              "reg_number"]
                                          ?.text
                                          .toString(),
                                  color: Theme.of(context).colorScheme.primary,
                                  weight: FontWeight.w700,
                                  size: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.fontSize,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  (loginPageController
                                                      .registrationPageFormControllers[
                                                          "reg_number"]
                                                      ?.text
                                                      .toString() ??
                                                  "")
                                              .isEmpty &&
                                          profileProvider
                                              .certificateID.isNotEmpty
                                      ? Icons.verified_rounded
                                      : Icons.pending_actions_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5),
                                  size: 16,
                                )
                              ],
                            ),

                            // const SizedBox(
                            //   height: 32,
                            // ),
                            // TextWidget(
                            //   "Location Details",
                            //   color: Colors.grey.shade800,
                            //   weight: Theme.of(context)
                            //       .textTheme
                            //       .titleMedium
                            //       ?.fontWeight,
                            //   size: Theme.of(context)
                            //       .textTheme
                            //       .titleMedium
                            //       ?.fontSize,
                            // ),
                            // const SizedBox(
                            //   height: 16,
                            // ),
                            loginProvider.isFarmer
                                ? Container(
                                    margin: const EdgeInsets.only(top: 24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          "Cultivated Land Area (in acres)",
                                          color: Colors.grey.shade800,
                                          weight: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.fontWeight,
                                          size: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.fontSize,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        SliderTheme(
                                          data: SliderThemeData(
                                            activeTickMarkColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                            inactiveTickMarkColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                          ),
                                          child: Slider(
                                              divisions: 30,
                                              thumbColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              activeColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              inactiveColor:
                                                  const Color(0x16006838),
                                              value: loginPageController
                                                  .landInAcres,
                                              max: 30,
                                              min: 1,
                                              label: loginPageController
                                                  .landInAcres
                                                  .round()
                                                  .toString(),
                                              // ignore: avoid_types_as_parameter_names
                                              onChanged: (num) {
                                                setState(() {
                                                  loginPageController
                                                      .landInAcres = num;
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: ElevatedButtonWidget(
                          onClick: () async {
                            var formValidatedState = loginPageController
                                    .registrationFormKey.currentState
                                    ?.validate() ??
                                false;

                            if (formValidatedState) {
                              if (!(loginPageController.profileImage != null ||
                                      profileProvider.sellerImage.isNotEmpty) &&
                                  loginProvider.isFarmer) {
                                formValidatedState = false;
                                snackbar(
                                    context,
                                    "Please upload ${loginProvider.isFarmer ? "the Farmer" : loginProvider.userAppTheme.key.contains("Store") ? "your" : "your"} image");
                              }
                              if (!loginProvider.isFarmer) {
                                if (!(loginPageController.storeLogo != null ||
                                    profileProvider.storeLogo.isNotEmpty)) {
                                  formValidatedState = false;
                                  snackbar(context,
                                      "Please upload the ${loginProvider.userAppTheme.key.contains("Store") ? "Store" : "Restaurant"}'s logo");
                                }
                              }

                              if (formValidatedState) {
                                var formValidatedState = loginPageController
                                        .registrationFormSecondPageKey
                                        .currentState
                                        ?.validate() ??
                                    true;

                                if (!loginProvider.isFarmer ||
                                    loginPageController.landInAcres > 1) {
                                  if (formValidatedState &&
                                      loginPageController
                                          .userCertification.isNotEmpty) {
                                    if ((loginPageController
                                                .userCertification.isNotEmpty &&
                                            loginPageController.userCertificates
                                                .where((element) =>
                                                    element.isNotEmpty)
                                                .isNotEmpty) ||
                                        loginPageController
                                                .registrationFormSecondPageKey
                                                .currentState ==
                                            null) {
                                      profileProvider.showLoader();

                                      Map<String, String> userAddress = {
                                        "coordinates-x": (loginPageController
                                                    .location?.latitude ??
                                                0)
                                            .toString(),
                                        "coordinates-y": (loginPageController
                                                    .location?.longitude ??
                                                0)
                                            .toString(),
                                        "houseNumber": loginPageController
                                                .registrationPageFormControllers[
                                                    "house_number"]
                                                ?.text
                                                .toString() ??
                                            "",
                                        "city": loginPageController
                                                .registrationPageFormControllers[
                                                    "city"]
                                                ?.text
                                                .toString() ??
                                            "",
                                        "mandal": loginPageController
                                                .registrationPageFormControllers[
                                                    "mandal"]
                                                ?.text
                                                .toString() ??
                                            "",
                                        "district": loginPageController
                                                .registrationPageFormControllers[
                                                    "district"]
                                                ?.text
                                                .toString() ??
                                            "",
                                        "state": loginPageController
                                                .registrationPageFormControllers[
                                                    "state"]
                                                ?.text
                                                .toString() ??
                                            "",
                                        "pincode": loginPageController
                                                .registrationPageFormControllers[
                                                    "pincode"]
                                                ?.text
                                                .toString() ??
                                            ""
                                      };

                                      var sellerImageURL = loginPageController
                                                  .profileImage !=
                                              null
                                          ? await uploadFilesToCloud(
                                              loginPageController.profileImage,
                                              cloudLocation: "profile_pics")
                                          : profileProvider.sellerImage;
                                      var storeLogoURL = "";
                                      if (!loginProvider.isFarmer) {
                                        storeLogoURL = loginPageController
                                                    .storeLogo !=
                                                null
                                            ? await uploadFilesToCloud(
                                                loginPageController.storeLogo,
                                                cloudLocation: "logo")
                                            : profileProvider.storeLogo;
                                      }
                                      List<String> certificatesURLs = [];
                                      if (loginPageController.userCertificates
                                          .where((element) => element.isEmpty)
                                          .isNotEmpty) {
                                        await Future.forEach<XFile>(
                                            loginPageController.userCertificates
                                                .firstWhere((element) =>
                                                    element.isNotEmpty),
                                            (element) async {
                                          String urlData =
                                              await uploadFilesToCloud(element,
                                                  cloudLocation: "legal_docs",
                                                  fileType: ".jpg");
                                          certificatesURLs.add(urlData);
                                        });
                                      }
                                      Map<String, String> body = {
                                        "user_id":
                                            profileProvider.userIdForAddress,

                                        "email": loginPageController
                                                .registrationPageFormControllers[
                                                    "email"]
                                                ?.text
                                                .toString() ??
                                            "",

                                        "additional_documents":
                                            loginPageController
                                                .userCertification,
                                        "upload_document":
                                            certificatesURLs.toString(),
                                        "store_address": userAddress.toString(),
                                        "language": (loginProvider
                                                .languages.entries
                                                .toList()
                                                .where((e) =>
                                                    e.key ==
                                                    loginProvider
                                                        .usersLanguage.key)
                                                .first
                                                .value)
                                            .toString(),

                                        "certificate_id": loginPageController
                                                .registrationPageFormControllers[
                                                    "reg_number"]
                                                ?.text
                                                .toString() ??
                                            "",
                                        // "agree": "1"
                                      };
                                      if (!loginProvider.isFarmer) {
                                        body.addEntries([
                                          MapEntry(
                                              "store_name",
                                              loginPageController
                                                      .registrationPageFormControllers[
                                                          "storeName"]
                                                      ?.text
                                                      .toString() ??
                                                  ""),
                                          MapEntry(
                                            "store_logo",
                                            storeLogoURL.toString(),
                                          )
                                        ]);
                                      } else {
                                        body.addEntries([
                                          MapEntry("seller_storename",
                                              "${loginPageController.registrationPageFormControllers["first_name"]?.text.toString() ?? "XYZ"} ${loginPageController.registrationPageFormControllers["last_name"]?.text.toString() ?? "XYZ"}"),
                                          MapEntry(
                                            "store_logo",
                                            sellerImageURL,
                                          ),
                                        ]);
                                        body.addAll({
                                          "firstname": loginPageController
                                                  .registrationPageFormControllers[
                                                      "first_name"]
                                                  ?.text
                                                  .toString() ??
                                              "",
                                          "lastname": loginPageController
                                                  .registrationPageFormControllers[
                                                      "last_name"]
                                                  ?.text
                                                  .toString() ??
                                              "",
                                          "seller_type": loginProvider
                                              .userAppTheme.key
                                              .toString(),
                                          "land": loginPageController
                                              .landInAcres
                                              .toString(),
                                          "seller_image":
                                              sellerImageURL.toString(),
                                          "additional_comments":
                                              "Farmer is the backbone of India",
                                        });
                                      }
                                      log(body.toString());
                                      var response = await Server()
                                          .postFormData(
                                              body: body,
                                              url: loginProvider.isFarmer
                                                  ? "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/updateparticularuser"
                                                  : loginProvider.isStore
                                                      ? "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/storeregistration/updateparticularorganicstore"
                                                      : "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/restaurantregistration/updateparticularorganicrestaurant")
                                          .catchError((e) {
                                        log("64$e");
                                      });
                                      log("response - $response");
                                      if (response?.statusCode == 200) {
                                        log(response?.body ?? "");
                                        var decodedResponse = jsonDecode(response
                                                ?.body
                                                .replaceFirst(
                                                    '<b>Notice</b>: Undefined index: customer_group_id in\n<b>/home4/swekenco/public_html/nkweb/catalog/controller/extension/account/purpletree_multivendor/api/updateparticularuser.php</b>',
                                                    '')
                                                .replaceFirst(
                                                    "<b>Notice</b>: Undefined index: customer_group_id in<b>/home4/swekenco/public_html/nkweb/catalog/controller/extension/account/purpletree_multivendor/api/updateparticularuser.php</b>",
                                                    "") ??
                                            '{"message": {},"success": false}');
                                        log(response?.body ?? "");
                                        var statusCodeBody = false;
                                        if (decodedResponse["success"] !=
                                            null) {
                                          statusCodeBody =
                                              decodedResponse["success"];
                                        } else {
                                          statusCodeBody =
                                              decodedResponse["status"];
                                        }
                                        if (statusCodeBody) {
                                          log("Successful update");
                                          snackbar(context,
                                              "Successfully updated your profile",
                                              isError: false);
                                          Navigator.of(context).pop();
                                          profileProvider.showLoader();
                                          profileProvider
                                              .getProfile(
                                                  loginProvider: loginProvider,
                                                  userID: profileProvider
                                                      .userIdForAddress,
                                                  showMessage: (_) {
                                                    snackbar(context, _);
                                                  },
                                                  navigator:
                                                      Navigator.of(context))
                                              .then((value) =>
                                                  profileProvider.hideLoader());
                                        } else {
                                          snackbar(context,
                                              "Failed to update, error: ${decodedResponse["message"]}");
                                          profileProvider.hideLoader();
                                        }
                                      } else {
                                        log(response?.body ?? "");
                                        snackbar(context,
                                            "Oops! Couldn't update your profile: ${response?.statusCode}");
                                        profileProvider.hideLoader();
                                        Navigator.of(context).pop();
                                      }
                                    } else {
                                      snackbar(context,
                                          "Please upload a valid certificate");
                                    }
                                  } else {
                                    snackbar(context,
                                        "Please select a certification type");
                                  }
                                } else {
                                  snackbar(context,
                                      "Please select your cultivated land in acres with the slider");
                                }
                              }
                            }
                          },
                          height: getProportionateHeight(64, constraints),
                          borderRadius: 12,
                          bgColor: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          buttonName: "Update".toUpperCase(),
                          innerPadding: 0.02,
                          trailingIcon: Icons.arrow_forward),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                "Delete account",
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/images/farmer_ploughing.png',
                        width: 300,
                      ),
                    )
                  ],
                ),
              ));
            }),
            profileProvider.shouldShowLoader
                ? LoaderScreen(profileProvider)
                : const SizedBox(),
          ],
        );
      });
    });
  }
}

certificationBottomSheet(
    LoginProvider loginProvider,
    LoginController loginPageController,
    setState,
    BoxConstraints constraints,
    showImagePickerSheet,
    context) {
  var isErrorInTextField = false;
  var hasCertificateError = false;
  return StatefulBuilder(builder: (context, setBSState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Certification",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
          child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque elit dolor, egestas eget molestie in.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(
          height: 16,
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
                      setBSState(() {
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
                    });
                  },
                  child: Container(
                    color: loginPageController.userCertification ==
                            loginProvider.certificationList[index]
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.5)),
                                  activeColor:
                                      Theme.of(context).colorScheme.primary,
                                  checkColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  value: loginPageController
                                          .userCertification ==
                                      loginProvider.certificationList[index],
                                  onChanged: (boolean) {
                                    setState(() {
                                      setBSState(() {
                                        if (loginPageController
                                            .userCertificates.isNotEmpty) {
                                          if (loginPageController
                                              .userCertificates[index]
                                              .isNotEmpty) {
                                            loginPageController
                                                .userCertificates[index] = [];
                                          }
                                        }
                                        loginPageController.userCertification =
                                            loginProvider
                                                .certificationList[index];
                                        loginPageController
                                            .registrationPageFormControllers[
                                                "reg_number"]
                                            ?.text = "";
                                      });
                                    });
                                  }),
                              Expanded(
                                child: SizedBox(
                                  child: TextWidget(
                                    loginProvider.certificationList[index],
                                    color: loginPageController
                                                .userCertification ==
                                            loginProvider
                                                .certificationList[index]
                                        ? Theme.of(context).colorScheme.primary
                                        : const Color(0xFF1F1F1F)
                                            .withOpacity(0.7),
                                  ),
                                ),
                              )
                            ]),
                        hasCertificateError &&
                                loginPageController.userCertification ==
                                    loginProvider.certificationList[index]
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    "Please upload a valid certificate",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        (loginProvider.isFarmer ? index != 0 : true) &&
                                index != 5 &&
                                loginPageController.userCertification ==
                                    loginProvider.certificationList[index]
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 42,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Form(
                                        key: loginPageController
                                            .registrationFormSecondPageKey,
                                        child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          onChanged: (_) {
                                            setState(() {});
                                            setBSState(() {});
                                          },
                                          decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Icons.contact_page_rounded),
                                              filled: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              fillColor: isErrorInTextField
                                                  ? ElevationOverlay.colorWithOverlay(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withOpacity(0.2),
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                      16)
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.2),
                                              counterStyle: fonts(
                                                  Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.fontSize,
                                                  FontWeight.normal,
                                                  Colors.white),
                                              hintStyle: fonts(
                                                  Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.fontSize,
                                                  FontWeight.w400,
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.7)),
                                              hintText: 'Registration Number',
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    width: 5),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              isDense: true,
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                    width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              )),
                                          validator: (value) {
                                            if (value?.isEmpty ?? false) {
                                              isErrorInTextField = true;
                                              setBSState(() {});
                                              return "Enter a valid certificate registration number";
                                            } else {
                                              isErrorInTextField = false;
                                              setBSState(() {});
                                              return null;
                                            }
                                          },
                                          controller: loginPageController
                                                  .registrationPageFormControllers[
                                              "reg_number"],
                                        ),
                                      ),
                                    ),
                                    (loginProvider.isFarmer
                                                ? index != 0
                                                : true) &&
                                            index != 5 &&
                                            loginPageController
                                                    .userCertification ==
                                                loginProvider
                                                    .certificationList[index]
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 24),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            height: 48,
                                            child: IconButton(
                                              onPressed: () {
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
                                                    setState(() {
                                                      setBSState(() {
                                                        loginPageController
                                                            .userCertificates[
                                                                index]
                                                            .add(certificate);
                                                      });
                                                    });
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.upload_file_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Spacer(),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 20,
                        ),

                        // SizedBox(
                        //   height: (loginProvider.isFarmer ? index != 0 : true) &&
                        //           index != 5 &&
                        //           loginPageController.userCertification ==
                        //               loginProvider.certificationList[index]
                        //       ? 12
                        //       : 0,
                        // ),
                        (loginProvider.isFarmer ? index != 0 : true) &&
                                index != 5 &&
                                loginPageController
                                    .userCertificates.isNotEmpty &&
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
                                                  setBSState(() {});
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
                            : const SizedBox(),
                      ],
                    ),
                  ),
                );
              }),
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          child: ElevatedButtonWidget(
              onClick: () async {
                if (loginPageController
                        .registrationFormSecondPageKey.currentState
                        ?.validate() ??
                    true) {
                  if ((loginPageController.userCertification.isNotEmpty &&
                          loginPageController.userCertificates
                              .where((element) => element.isNotEmpty)
                              .isNotEmpty) ||
                      loginPageController
                              .registrationFormSecondPageKey.currentState ==
                          null) {
                    setBSState(() {
                      hasCertificateError = false;
                    });
                    Navigator.of(context).pop();
                    setState(() {});
                  } else {
                    setBSState(() {
                      hasCertificateError = true;
                    });
                  }
                }
              },
              height: getProportionateHeight(64, constraints),
              borderRadius: 12,
              bgColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
              buttonName: "Update".toUpperCase(),
              innerPadding: 0.02,
              trailingIcon: Icons.arrow_forward),
        ),
      ],
    );
  });
}
