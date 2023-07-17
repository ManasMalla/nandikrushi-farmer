// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The provider that handles all of the methods, functions and paramters needed for the login and onboarding workflow.

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_controller.dart';
import 'package:nandikrushi_farmer/reusable_widgets/application_pending.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/firebase_storage_utils.dart';
import 'package:nandikrushi_farmer/utils/login_utils.dart';
import 'package:nandikrushi_farmer/utils/server.dart';

class LoginProvider extends ChangeNotifier {
  bool shouldShowLoader = false;
  bool isEmail = false;
  bool get isEmailLogin =>
      Platform.isAndroid || Platform.isIOS || Platform.isWindows
          ? isEmail
          : true;
  Map<String, Color> availableUserTypes = {};
  MapEntry<String, Color> userAppTheme = const MapEntry("", Color(0xFF006838));
  bool get isFarmer => userAppTheme.key.contains("Farmer");
  bool get isStore => userAppTheme.key.contains("Stores");
  bool get isRestaurant => userAppTheme.key.contains("Restaurant");

  Map<String, int> languages = {
    "english".toUpperCase(): 1,
    "తెలుగు": 3,
    "हिन्दी": 2,
    "ಕನ್ನಡ": 4,
  };
  MapEntry<String, int> usersLanguage = MapEntry("english".toUpperCase(), 1);

  List<String> get certificationList => isFarmer
      ? [
          'Self Declared Natural Farmer',
          'PGS India Green',
          'PGS India Organic',
          'Organic FPO',
          'Organic FPC',
          'Other Certification +'
        ]
      : userAppTheme.key.contains("Store")
          ? [
              'FSSAI',
              'Fire Safety License',
              'Certificate of Environmental Clearance',
              'Other Certification +'
            ]
          : [
              'FSSAI',
              'Eating House License',
              'Fire Safety License',
              'Certificate of Environmental Clearance',
              'Other Certification +'
            ];

  String firebaseVerificationID = "";
  int? _resendToken;
  String phoneNumber = "";

  updateUserAppType(MapEntry<String, Color> _) {
    userAppTheme = _;
    setAppTheme(_);
    notifyListeners();
  }

  updateLanguages(MapEntry<String, int> _) {
    usersLanguage = _;
    setUserLanguage(_);
    notifyListeners();
  }

  fetchUserTypes(Map<String, Color> _) {
    availableUserTypes = _;
    notifyListeners();
  }

  showLoader() {
    shouldShowLoader = true;
    notifyListeners();
  }

  hideLoader() {
    shouldShowLoader = false;
    notifyListeners();
  }

  void changeLoginMethod() {
    isEmail = !isEmail;

    notifyListeners();
  }

  Future<void> onLoginUser(
      bool isEmailProvider, LoginController loginController,
      {required Function(String, bool, String, String) onSuccessfulLogin,
      required Function(String) onError,
      required Function(String) showMessage,
      required Function(Function(String)) navigateToOTPScreen,
      required Function onRegisterUser,
      required NavigatorState navigator}) async {
    if (isEmailProvider) {
      var isFormReady =
          loginController.emailFormKey.currentState?.validate() ?? false;
      if (isFormReady) {
        var response = await Server().postFormData(
          body: {
            'email': loginController.emailTextEditController.text.toString(),
            'password':
                loginController.passwordTextEditController.text.toString()
          },
          url:
              "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/emaillogin",
        );

        onLoginWithServer(response, null, onSuccessfulLogin, onError, () {
          onError(
              "Oops! Can't register on this device. Please try on a mobile.");
        }, navigator: navigator);
      } else {
        hideLoader();
      }
    } else {
      var isFormReady =
          loginController.mobileFormKey.currentState?.validate() ?? false;
      if (isFormReady) {
        phoneNumber = loginController.phoneTextEditController.text;
        log("Trying to login user");
        try {
          if (Platform.isAndroid || Platform.isIOS) {
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: "+91${loginController.phoneTextEditController.text}",
              verificationCompleted:
                  (PhoneAuthCredential phoneAuthCredential) async {
                var firebaseUser = await FirebaseAuth.instance
                    .signInWithCredential(phoneAuthCredential);
                onLoginWithCredential(firebaseUser, loginController,
                    onSuccessfulLogin, onError, onRegisterUser, navigator);
              },
              verificationFailed: (FirebaseAuthException exception) {
                onError(
                    "Couldn't verify your phone number, Error: ${exception.message}");
                hideLoader();
              },
              codeSent: (String verificationId, int? resendToken) {
                firebaseVerificationID = verificationId;
                _resendToken = resendToken;
                showMessage("OTP sent successfully");
                //Navigate to OTP page
                navigateToOTPScreen((String otp) async {
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: otp);
                  var firebaseUser = await FirebaseAuth.instance
                      .signInWithCredential(phoneAuthCredential);
                  onLoginWithCredential(firebaseUser, loginController,
                      onSuccessfulLogin, onError, onRegisterUser, navigator);
                });
              },
              codeAutoRetrievalTimeout: (String verificationId) {
                firebaseVerificationID = verificationId;
                showMessage("OTP sent successfully");
              },
              forceResendingToken: _resendToken,
              timeout: const Duration(
                seconds: 60,
              ),
            );
          } else {
            ConfirmationResult confirmationResult = await FirebaseAuth.instance
                .signInWithPhoneNumber(
                    "+91${loginController.phoneTextEditController.text}");
            showMessage("OTP sent successfully");
            //Navigate to OTP page
            navigateToOTPScreen((String otp) async {
              UserCredential userCredential =
                  await confirmationResult.confirm(otp);
              onLoginWithCredential(userCredential, loginController,
                  onSuccessfulLogin, onError, onRegisterUser, navigator);
            });
          }
        } catch (exception) {
          log("Verification Completed");
          onError("Couldn't verify your phone number, Error: $exception");
          hideLoader();
        }
      } else {
        hideLoader();
      }
    }
  }

  onLoginWithCredential(
      UserCredential firebaseUser,
      LoginController loginController,
      Function(String, bool, String, String) onSuccessfulLogin,
      Function(String) onError,
      Function onRegisterUser,
      NavigatorState navigator) async {
    log("Verification Completed");

    if (firebaseUser.user != null) {
      //User is signed in with Firebase, checking with API
      var response = await Server().postFormData(
        body: {
          'telephone': loginController.phoneTextEditController.text.toString(),
          'device_token': Platform.isAndroid || Platform.isIOS
              ? await FirebaseMessaging.instance.getToken() ?? ""
              : "",
        },
        url:
            "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/sellerlogin/verify_mobile",
      );
      onLoginWithServer(response, FirebaseAuth.instance.currentUser?.uid,
          onSuccessfulLogin, onError, onRegisterUser,
          shouldValidateUserStatus: true, navigator: navigator);
    }
  }

  onLoginWithServer(
      Response? response,
      String? uid,
      Function(String, bool, String, String) onSuccessfulLogin,
      Function(String) onError,
      Function onRegisterUser,
      {bool shouldValidateUserStatus = false,
      required NavigatorState navigator}) {
    if (response?.statusCode == 200) {
      var decodedResponse =
          jsonDecode(response?.body ?? '{"message": {},"success": false}');
      log(response?.body ?? "");

      if (decodedResponse["status"]) {
        print("Status is true");
        if (decodedResponse["user_status"] == 2) {
          onRegisterUser();
          hideLoader();
        } else if (((decodedResponse["user_status"] ?? false) == 1 ||
                !shouldValidateUserStatus) &&
            !decodedResponse["message"]
                .toString()
                .contains("Seller is Under Verification")) {
          log("Successful login");
          var customerGroupID = (decodedResponse["message"]
                  .toString()
                  .contains("customer_group_id")
              ? decodedResponse["message"]["customer_group_id"]
              : decodedResponse["customer_details"]["customer_group_id"]);

          var customerGroupTitle = availableUserTypes.entries
              .where((element) =>
                  element.key.toLowerCase().contains(customerGroupID == "2"
                      ? "farmer"
                      : customerGroupID == "3"
                          ? "store"
                          : "rest"))
              .first;
          updateUserAppType(customerGroupTitle);
          onSuccessfulLogin(
              capitalize(
                  decodedResponse["message"].toString().contains("firstname")
                      ? decodedResponse["message"]["firstname"]
                      : decodedResponse["customer_details"]["firstname"]),
              true,
              decodedResponse["message"].toString().contains("user_id")
                  ? decodedResponse["message"]["user_id"]
                  : decodedResponse["customer_details"]["user_id"],
              decodedResponse["message"].toString().contains("customer_id")
                  ? (decodedResponse["message"]?["customer_id"] ??
                      decodedResponse["customer_id"])
                  : decodedResponse["customer_details"]["customer_id"]);
        } else {
          navigator.pushReplacement(MaterialPageRoute(
              builder: (context) => ApplicationStatusScreen(
                    uID: uid ?? "",
                  )));
          hideLoader();
          print(decodedResponse["message"]);
        }
      } else {
        if (decodedResponse["user_status"] == 2) {
          onRegisterUser();
          hideLoader();
        } else {
          navigator.pushReplacement(MaterialPageRoute(
              builder: (context) => ApplicationStatusScreen(
                    uID: uid ?? "",
                  )));

          print(decodedResponse["message"]);
          onError("Failed to login, error: ${decodedResponse["message"]}");
          hideLoader();
        }
      }
    } else {
      onError("Oops! Couldn't log you in: ${response?.statusCode}");
      hideLoader();
    }
  }

  Future<void> registerUser(
      {required LoginController loginPageController,
      required Function(String, bool, String, String) onSuccess,
      required Function(String) onError,
      required NavigatorState navigator}) async {
    showLoader();

    Map<String, String> userAddress = {
      "coordinates-x": (loginPageController.location?.latitude ?? 0).toString(),
      "coordinates-y":
          (loginPageController.location?.longitude ?? 0).toString(),
      "houseNumber": loginPageController
              .registrationPageFormControllers["house_number"]?.text
              .toString() ??
          "",
      "city": loginPageController.registrationPageFormControllers["city"]?.text
              .toString() ??
          "",
      "mandal": loginPageController
              .registrationPageFormControllers["mandal"]?.text
              .toString() ??
          "",
      "district": loginPageController
              .registrationPageFormControllers["district"]?.text
              .toString() ??
          "",
      "state": loginPageController
              .registrationPageFormControllers["state"]?.text
              .toString() ??
          "",
      "pincode": loginPageController
              .registrationPageFormControllers["pincode"]?.text
              .toString() ??
          ""
    };

    var sellerImageURL = "";
    if (isFarmer) {
      sellerImageURL = await uploadFilesToCloud(
          loginPageController.profileImage,
          cloudLocation: "profile_pics");
    }

    var storeLogoURL = "";
    if (!isFarmer) {
      storeLogoURL = await uploadFilesToCloud(loginPageController.storeLogo,
          cloudLocation: "logo");
    }
    List<String> certificatesURLs = [];
    if (loginPageController.userCertificates
        .where((element) => element.isEmpty)
        .isNotEmpty) {
      await Future.forEach<XFile>(
          loginPageController.userCertificates
              .firstWhere((element) => element.isNotEmpty), (element) async {
        String urlData = await uploadFilesToCloud(element,
            cloudLocation: "legal_docs", fileType: ".jpg");
        certificatesURLs.add(urlData);
      });
    }

    if (!isFarmer && isStore && !isRestaurant) {
      //Store/Restaurant
      Map<String, String> body = {
        "user_id": FirebaseAuth.instance.currentUser?.uid ?? "",

        "email": loginPageController
                .registrationPageFormControllers["email"]?.text
                .toString() ??
            "",
        "telephone": phoneNumber,
        "password": loginPageController
                .registrationPageFormControllers["password"]?.text
                .toString() ??
            "",
        "confirm": loginPageController
                .registrationPageFormControllers["c_password"]?.text
                .toString() ??
            "",
        // "agree": 1.toString(),
        // "become_seller": 1.toString(),
        "seller_type": userAppTheme.key.toString(),
        //  "land": loginPageController.landInAcres.toString(),
        //    "seller_image": sellerImageURL.toString(),
        //  "additional_comments": "Farmer is the backbone of India",
        "additional_documents": loginPageController.userCertification,
        "upload_document": certificatesURLs.toString(),
        "store_address": userAddress.toString(),
        // "store_status": 1.toString(),
        "language": (languages.entries
                .toList()
                .where((e) => e.key == usersLanguage.key)
                .first
                .value)
            .toString(),
        "store_name": loginPageController
                .registrationPageFormControllers["storeName"]?.text
                .toString() ??
            "",
        "store_logo": storeLogoURL.toString(),
        "certificate_id": loginPageController
                .registrationPageFormControllers["reg_number"]?.text
                .toString() ??
            "",

        'device_token': await FirebaseMessaging.instance.getToken() ?? ""
        // "agree": "1"
      };

      var registrationURL =
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/storeregistration";
      var response = await Server()
          .postFormData(body: body, url: registrationURL)
          .catchError((e) {
        log("64$e");
      });
      onLoginWithServer(response, FirebaseAuth.instance.currentUser?.uid,
          onSuccess, onError, () {},
          navigator: navigator);
    } else if (!isFarmer && isRestaurant && !isStore) {
      //Store/Restaurant
      Map<String, String> body = {
        "user_id": FirebaseAuth.instance.currentUser?.uid ?? "",

        "email": loginPageController
                .registrationPageFormControllers["email"]?.text
                .toString() ??
            "",
        "telephone": phoneNumber,
        "password": loginPageController
                .registrationPageFormControllers["password"]?.text
                .toString() ??
            "",
        "confirm": loginPageController
                .registrationPageFormControllers["c_password"]?.text
                .toString() ??
            "",
        // "agree": 1.toString(),
        // "become_seller": 1.toString(),
        "seller_type": userAppTheme.key.toString(),
        //  "land": loginPageController.landInAcres.toString(),
        //    "seller_image": sellerImageURL.toString(),
        //  "additional_comments": "Farmer is the backbone of India",
        "additional_documents": loginPageController.userCertification,
        "upload_document": certificatesURLs.toString(),
        "store_address": userAddress.toString(),
        // "store_status": 1.toString(),
        "language":
            (languages.entries.toList().indexOf(usersLanguage) + 1).toString(),
        "store_name": loginPageController
                .registrationPageFormControllers["storeName"]?.text
                .toString() ??
            "",
        "store_logo": storeLogoURL.toString(),
        "certificate_id": loginPageController
                .registrationPageFormControllers["reg_number"]?.text
                .toString() ??
            "",

        'device_token': await FirebaseMessaging.instance.getToken() ?? ""
        // "agree": "1"
      };

      var registrationURL =
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/restaurantregistration";
      var response = await Server()
          .postFormData(body: body, url: registrationURL)
          .catchError((e) {
        log("64$e");
      });
      onLoginWithServer(response, FirebaseAuth.instance.currentUser?.uid,
          onSuccess, onError, () {},
          navigator: navigator);
    } else {
      //Farmer
      Map<String, String> body = {
        "user_id": FirebaseAuth.instance.currentUser?.uid ?? "",
        "firstname": loginPageController
                .registrationPageFormControllers["first_name"]?.text
                .toString() ??
            "",
        "lastname": loginPageController
                .registrationPageFormControllers["last_name"]?.text
                .toString() ??
            "",
        "email": loginPageController
                .registrationPageFormControllers["email"]?.text
                .toString() ??
            "",
        "telephone": phoneNumber,
        "password": loginPageController
                .registrationPageFormControllers["password"]?.text
                .toString() ??
            "",
        "confirm": loginPageController
                .registrationPageFormControllers["c_password"]?.text
                .toString() ??
            "",
        "agree": 1.toString(),
        "become_seller": 1.toString(),
        "seller_type": userAppTheme.key.toString(),
        "land": loginPageController.landInAcres.toString(),
        "seller_image": sellerImageURL.toString(),
        "additional_comments": "Farmer is the backbone of India",
        "additional_documents": loginPageController.userCertification,
        "upload_document": certificatesURLs.toString(),
        "store_address": userAddress.toString(),
        "store_status": 1.toString(),
        "language":
            (languages.entries.toList().indexOf(usersLanguage) + 1).toString(),

        "certificate_id": loginPageController
                .registrationPageFormControllers["reg_number"]?.text
                .toString() ??
            "",

        'device_token': await FirebaseMessaging.instance.getToken() ?? "",
        // "agree": "1"
      };
      body.addEntries([
        MapEntry("seller_storename",
            "${loginPageController.registrationPageFormControllers["first_name"]?.text.toString() ?? "XYZ"} ${loginPageController.registrationPageFormControllers["last_name"]?.text.toString() ?? "XYZ"}"),
        MapEntry(
          "store_logo",
          sellerImageURL,
        )
      ]);
      var registrationURL =
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/register";
      var response = await Server()
          .postFormData(body: body, url: registrationURL)
          .catchError((e) {
        log("64$e");
      });
      onLoginWithServer(response, FirebaseAuth.instance.currentUser?.uid,
          onSuccess, onError, () {},
          navigator: navigator);
    }
  }
}
