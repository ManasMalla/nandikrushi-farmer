// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the MVC Controller for the login workflow

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:nandikrushi_farmer/nav_host.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/onboarding/onboarding.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as LocationPackage;

class LoginController extends ControllerMVC {
  GlobalKey<FormState> mobileFormKey = GlobalKey();
  GlobalKey<FormState> emailFormKey = GlobalKey();
  GlobalKey<FormState> otpFormKey = GlobalKey();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey();
  GlobalKey<FormState> registrationFormKey = GlobalKey();
  GlobalKey<FormState> registrationFormSecondPageKey = GlobalKey();

  TextEditingController emailTextEditController = TextEditingController();
  TextEditingController passwordTextEditController = TextEditingController();
  TextEditingController phoneTextEditController = TextEditingController();
  TextEditingController otpTextEditController = TextEditingController();
  TextEditingController forgotPasswordTextEditController =
      TextEditingController();
  var registrationPageFormControllers = {
    'first_name': TextEditingController(),
    'last_name': TextEditingController(),
    'house_number': TextEditingController(),
    'city': TextEditingController(),
    'mandal': TextEditingController(),
    'district': TextEditingController(),
    'state': TextEditingController(),
    'pincode': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'c_password': TextEditingController(),
    'telePhone': TextEditingController(),
    'storeName': TextEditingController(),
    'reg_number': TextEditingController(),
  };
  double landInAcres = 1;
  String userCertification = "";

  XFile? profileImage;
  XFile? storeLogo;

  PageController pageController = PageController();

  LatLng? location;
  List<Placemark>? locationGeoCoded;

  List<List<XFile>> userCertificates = [];

  Future<void> checkLocationPermissionAndGetLocation(
      BuildContext context) async {
    var permissionGranted = await Geolocator.checkPermission();
    log("IsPermissionGranted: $permissionGranted");
    if (permissionGranted == LocationPermission.always ||
        permissionGranted == LocationPermission.whileInUse) {
      var lastKnownLocation = await Geolocator.getLastKnownPosition();
      if (lastKnownLocation != null) {
        location =
            LatLng(lastKnownLocation.latitude, lastKnownLocation.longitude);
      }
      log(location.toString());
      var isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      log(isLocationServiceEnabled.toString());
      if (isLocationServiceEnabled) {
        var currentPosition = await Geolocator.getCurrentPosition();

        location = LatLng(currentPosition.latitude, currentPosition.longitude);

        log(location.toString());
        await geocodeLocation(context, location!.latitude, location!.longitude);
      } else {
        log("open settings");
        if (await LocationPackage.Location().requestService()) {
          await checkLocationPermissionAndGetLocation(context);
        }
      }
    } else {
      log("Entered location requester");
      await Geolocator.requestPermission();
      await checkLocationPermissionAndGetLocation(context);
    }
  }

  Future<void> geocodeLocation(
      BuildContext context, latitude, longitude) async {
    locationGeoCoded = await placemarkFromCoordinates(latitude, longitude);
    if (location?.latitude == 0 || location?.longitude == 0) {
      snackbar(context, "HALT on CRITICAL ERROR, location is empty");
      exit(0);
    }
    log(locationGeoCoded.toString());
    registrationPageFormControllers["pincode"]?.text =
        locationGeoCoded?.first.postalCode ?? "";
    registrationPageFormControllers["state"]?.text =
        locationGeoCoded?.first.administrativeArea ?? "";
    registrationPageFormControllers["district"]?.text =
        locationGeoCoded?.first.subAdministrativeArea ?? "";
    registrationPageFormControllers["city"]?.text =
        locationGeoCoded?.first.locality ?? "";
    registrationPageFormControllers["house_number"]?.text =
        locationGeoCoded?.first.street ?? "";
    registrationPageFormControllers["mandal"]?.text =
        locationGeoCoded?.first.subLocality ?? "";
  }

  checkUser(
      {required Future<bool> isReturningUserFuture,
      required NavigatorState navigator,
      required Function(Function) onNewUser,
      required LoginProvider loginProvider}) async {
    var isReturningUser = await isReturningUserFuture;
    log("123->$isReturningUser");
    if (FirebaseAuth.instance.currentUser != null && isReturningUser) {
      var appTheme = await getAppTheme();
      loginProvider.updateUserAppType(appTheme);
      Timer(const Duration(milliseconds: 2000), () async {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        var uID = sharedPreferences.getString('userID')!;

        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (_) => NandikrushiNavHost(
              userId: uID,
            ),
          ),
        );
      });
    } else {
      //Removed (Platform.isAndroid || Platform.isIOS) &&
      if (!isReturningUser) {
        onNewUser(() {
          Timer(const Duration(milliseconds: 1000), () async {
            navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                (route) => false);
          });
        });
      } else {
        var appTheme = await getAppTheme();
        loginProvider.updateUserAppType(appTheme);
        Timer(const Duration(milliseconds: 2000), () async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          var uID = sharedPreferences.getString('userID')!;

          navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => NandikrushiNavHost(
                        userId: uID,
                      )),
              (route) => false);
        });
      }
    }
  }

  Future<Map<String, Color>> getUserRegistrationData(context) async {
    var isTimedOut = false;
    var response = await Server()
        .getMethodParams(
      'https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/customergroups',
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      var userTypeData = {
        "Farmers ": const Color(0xFF006838),
        "Organic Stores": const Color(0xFF00bba8),
        "Organic Restaurants": const Color(0xFFffd500),
      };
      isTimedOut = true;
      return userTypeData;
    });

    if (!isTimedOut) {
      if (response.statusCode == 200) {
        log("sucess");
        log(response.body);
        List<dynamic> values = jsonDecode(response.body)["message"];
        values.retainWhere((element) =>
            !element["name"].toString().toLowerCase().contains("default"));
        var iterables = values.map(
          (e) => MapEntry(
            e["name"].toString(),
            e["name"].toString().contains("Farmer")
                ? const Color(0xFF006838)
                : e["name"].toString().contains("Store")
                    ? const Color(0xFF00bba8)
                    : const Color(0xFFffd500),
          ),
        );
        var userTypeData = {for (var e in iterables) e.key: e.value};

        return userTypeData;
      } else if (response.statusCode == 400) {
        snackbar(context, "Undefined Parameter when calling API");
        log("Undefined Parameter");
        var userTypeData = {
          "Farmers ": const Color(0xFF006838),
          "Organic Stores": const Color(0xFF00bba8),
          "Organic Restaurants": const Color(0xFFffd500),
        };
        return userTypeData;
      } else if (response.statusCode == 404) {
        snackbar(context, "API Not found");
        log("Not found");
        var userTypeData = {
          "Farmers ": const Color(0xFF006838),
          "Organic Stores": const Color(0xFF00bba8),
          "Organic Restaurants": const Color(0xFFffd500),
        };
        return userTypeData;
      } else {
        snackbar(context, "Failed to get data!");
        log("failure ${response.statusCode}");
        var userTypeData = {
          "Farmers ": const Color(0xFF006838),
          "Organic Stores": const Color(0xFF00bba8),
          "Organic Restaurants": const Color(0xFFffd500),
        };
        return userTypeData;
      }
    } else {
      snackbar(context, "Failed to get data!");
      log("failure");
      var userTypeData = {
        "Farmers ": const Color(0xFF006838),
        "Organic Stores": const Color(0xFF00bba8),
        "Organic Restaurants": const Color(0xFFffd500),
      };
      return userTypeData;
    }
  }

  Future<void> getDataFromProvider(ProfileProvider profileProvider) async {
    registrationPageFormControllers = {
      'first_name': TextEditingController(text: profileProvider.firstName),
      'last_name': TextEditingController(text: profileProvider.lastName),
      'house_number': TextEditingController(
          text: profileProvider.storeAddress["houseNumber"]),
      'city': TextEditingController(text: profileProvider.storeAddress["city"]),
      'mandal':
          TextEditingController(text: profileProvider.storeAddress["mandal"]),
      'district':
          TextEditingController(text: profileProvider.storeAddress["district"]),
      'state':
          TextEditingController(text: profileProvider.storeAddress["state"]),
      'pincode':
          TextEditingController(text: profileProvider.storeAddress["pincode"]),
      'email': TextEditingController(text: profileProvider.email),
      'password': TextEditingController(),
      'c_password': TextEditingController(),
      'telePhone': TextEditingController(
          text: profileProvider.telephone
              .replaceAll(" ", "")
              .replaceFirst("+91", "")),
      'storeName': TextEditingController(text: profileProvider.storeName),
      'reg_number': TextEditingController(),
    };
    //checkLocationPermissionAndGetLocation();
    log(profileProvider.landInAcres.toString());
    landInAcres = profileProvider.landInAcres.toDouble();
    userCertification = profileProvider.certificationType;

    notifyListeners();
    //TODO: Add Certificates
  }
}
