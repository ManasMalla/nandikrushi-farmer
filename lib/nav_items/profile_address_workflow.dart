// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the bottom sheet to add an address from Profile Screen

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_controller.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/textfield_widget.dart';
import 'package:nandikrushi_farmer/utils/size_config.dart';
import 'package:provider/provider.dart';

class ProfileAddressWorkflow extends StatefulWidget {
  final LoginController controller;
  final BoxConstraints constraints;
  const ProfileAddressWorkflow(
      {super.key, required this.controller, required this.constraints});

  @override
  State<ProfileAddressWorkflow> createState() => _ProfileAddressWorkflowState();
}

class _ProfileAddressWorkflowState extends State<ProfileAddressWorkflow> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoginController loginPageController = widget.controller;
    loginPageController
        .checkLocationPermissionAndGetLocation(context)
        .then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginController loginPageController = widget.controller;
    return Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              Icon(
                Icons.person_pin_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                width: 16,
              ),
              TextWidget(
                'Profile',
                size: Theme.of(context).textTheme.titleMedium?.fontSize,
                weight: Theme.of(context).textTheme.titleMedium?.fontWeight,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
        body: Stack(children: [
          Column(
            children: [
              Expanded(
                flex: 6,
                child: GoogleMap(
                  markers: {
                    Marker(
                      draggable: true,
                      onDragEnd: ((newPosition) {
                        setState(() {
                          loginPageController.location = newPosition;
                          loginPageController.geocodeLocation(context,
                              newPosition.latitude, newPosition.longitude);
                        });
                      }),
                      markerId: const MarkerId("Home"),
                      position: loginPageController.location ??
                          const LatLng(17.744062, 83.335216),
                    ),
                  },
                  onTap: (_) {},
                  initialCameraPosition: CameraPosition(
                    bearing: 0,
                    target: loginPageController.location ??
                        const LatLng(17.744062, 83.335216),
                    tilt: 0,
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    //_controller.complete(controller);
                  },
                ),
              ),
              const Spacer(
                flex: 9,
              ),
            ],
          ),
          Column(
            children: [
              const Spacer(
                flex: 6,
              ),
              Expanded(
                flex: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          "Address",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            "Deep press and drag the marker to update your location. Quisque elit dolor, egestas eget molestie in.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldWidget(
                                controller: loginPageController
                                        .registrationPageFormControllers[
                                    'house_number'],
                                label: 'H.No.',
                                validator: (value) {
                                  if (value?.isEmpty ?? false) {
                                    return snackbar(context,
                                        "Please enter a valid house number");
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: TextFieldWidget(
                                controller: loginPageController
                                    .registrationPageFormControllers['mandal'],
                                label: 'Locality',
                                validator: (value) {
                                  if (value?.isEmpty ?? false) {
                                    return snackbar(context,
                                        "Please enter a valid locality");
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
                                    .registrationPageFormControllers['city'],
                                label: 'City/Vilage',
                                keyboardType: TextInputType.streetAddress,
                                validator: (value) {
                                  if (value?.isEmpty ?? false) {
                                    return snackbar(context,
                                        "Please enter a valid city/village");
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
                                    'district'],
                                label: 'District',
                                validator: (value) {
                                  if (value?.isEmpty ?? false) {
                                    return snackbar(context,
                                        "Please enter a valid district");
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
                                textInputAction: TextInputAction.done,
                                controller: loginPageController
                                    .registrationPageFormControllers['pincode'],
                                label: 'Pincode',
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                validator: (value) {
                                  if (value?.isEmpty ?? false) {
                                    return snackbar(context,
                                        "Please enter a valid pincode");
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          child: ElevatedButtonWidget(
                              onClick: () async {
                                Navigator.of(context).pop();
                              },
                              height: getProportionateHeight(
                                  64, widget.constraints),
                              borderRadius: 12,
                              bgColor: Theme.of(context).colorScheme.primary,
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              buttonName: "Update".toUpperCase(),
                              innerPadding: 0.02,
                              trailingIcon: Icons.arrow_forward),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ]),
      );
    });
  }
}
