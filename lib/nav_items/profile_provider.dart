// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A provider that includes all of the data required to work with the profile workflow

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:nandikrushi_farmer/data/models/video_model.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/utils/server.dart';

import '../domain/entity/video.dart';
import '../onboarding/login/login_provider.dart';
import '../reusable_widgets/application_pending.dart';

class ProfileProvider extends ChangeNotifier {
  bool shouldShowLoader = false;
  String fetchingDataType = "fetch your data";

  //DataStates
  String sellerID = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String telephone = "";
  int languageID = 1;
  String customerGroupId = "";
  String sellerType = "";
  int landInAcres = 1;
  String sellerImage = "";
  String additionalComments = "";
  String certificationType = "";
  List<String> certificates = [];
  String storeName = "";
  String storeLogo = "";
  String certificateID = "";
  Map<String, String> storeAddress = {};
  List<Map<String, String>> userAddresses = [];
  String userIdForAddress = "";
  Map<String, dynamic> checkBox = {"value": false, "index": null};
  List<Map<String, dynamic>> checkAdd = [];
  List checkLength = [];
  List<Map<String, String>> notifications = [];
  bool isDataFetched = false;
  dynamic ordKey;

  List<Video> videos = [];

  showLoader() {
    shouldShowLoader = true;
    notifyListeners();
  }

  saveOrderKey(value) {
    ordKey = value;
  }

  checkBoxUpdate(value, index, BuildContext context) async {
    checkBox = {"value": value, "index": index};

    if (checkLength.isEmpty && value == true) {
      checkLength.add(checkBox);
      checkAdd[index] = {"num": index, "value": value};
    }
    if (checkLength.isEmpty && value == false) {
      log("no addresses selected");
      // snackbar(context, "No address selected");
    }
    if (checkLength.isNotEmpty && value == true) {
      log("cant add more addresses");
      // snackbar(context, "You can add only one address");
    }
    if (checkLength.isNotEmpty && value == false) {
      checkLength.clear();
      checkAdd[index] = {"num": index, "value": value};
    }
    notifyListeners();
  }

  checkBoxAdd() {
    int i;
    checkAdd.clear();
    for (i = 0; i <= userAddresses.length - 1; i++) {
      Map<String, dynamic> jsonData = {"num": i, "value": false};
      checkAdd.add(jsonData);
    }
    log(checkAdd.toString());
  }

  hideLoader() {
    shouldShowLoader = false;
    notifyListeners();
  }

  Future<void> getVideos(
      {required BuildContext context,
      required Function() onSuccessful,
      required Function(String) showMessage}) async {
    fetchingDataType = "fetch the videos";
    notifyListeners();
    showLoader();
    var url =
        "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/videos/getvideos";
    var response =
        await Server().postFormData(body: {"user_type": "3"}, url: url);
    if (response == null) {
      showMessage("Failed to get a response from the server!");
      //hideLoader();
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return;
    }
    if (response.statusCode == 200) {
      try {
        if (jsonDecode(response.body)["status"]) {
          List<dynamic> jsonData = json.decode(response.body)["message"];
          videos =
              jsonData.map((e) => VideoModel.fromJson(e).toEntity()).toList();
        } else {
          showMessage("Error fetching categories 1!");
          hideLoader();
          notifyListeners();
        }

        notifyListeners();
      } on Exception catch (e) {
        showMessage("Error fetching categories - 2: $e");
        hideLoader();
        notifyListeners();
      }
    } else if (response.statusCode == 400) {
      showMessage("Undefined parameter when calling API");
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else if (response.statusCode == 404) {
      showMessage("API not found");
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else {
      showMessage("Failed to get data!");
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }

    onSuccessful();
  }

  Future<void> getProfile(
      {required LoginProvider loginProvider,
      required String userID,
      required Function(String) showMessage,
      required NavigatorState navigator}) async {
    userIdForAddress = userID;
    fetchingDataType = "fetch your profile";
    notifyListeners();
    var url = loginProvider.isFarmer
        ? "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/getparticularuser"
        : loginProvider.isStore
            ? "https://nkweb.sweken.com/ index.php?route=extension/account/purpletree_multivendor/api/storeregistration/getparticularorganicstore"
            : "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/restaurantregistration/getparticularorganicrestaurant";
    var response =
        await Server().postFormData(body: {"user_id": userID}, url: url);

    if (response == null) {
      showMessage("Failed to get a response from the server!");
      hideLoader();
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return;
    }

    if (response.statusCode == 200 && jsonDecode(response.body)["status"]) {
      log(response.body.toString());
      Map<String, dynamic> profileJSON = jsonDecode(response.body)["message"];
      log(profileJSON.toString());
      sellerID = profileJSON["seller_id"];
      firstName = profileJSON["firstname"];
      lastName = profileJSON["lastname"];
      email = profileJSON["email"];
      telephone =
          "+91 ${profileJSON["telephone"].toString().substring(0, 5)} ${profileJSON["telephone"].toString().substring(5, 10)}";
      languageID = int.tryParse(profileJSON["language_id"]) ?? 1;
      customerGroupId = profileJSON["customer_group_id"] ?? "1";
      certificateID = profileJSON["certificate_id"] ?? "AP123239230MNS";
      if (certificateID.isEmpty) {
        certificateID == "AP123239230MNS";
      }
      sellerType = profileJSON["seller_type"];
      landInAcres = (double.tryParse(profileJSON["land"]) ?? 1.0).ceil();
      sellerImage = profileJSON["seller_image"];
      additionalComments = profileJSON["additional_comments"];
      certificationType = profileJSON["addtional_documents"];
      certificates = profileJSON["document"].runtimeType == String
          ? [profileJSON["document"]].map((e) => e.toString()).toList()
          : profileJSON["document"].map((e) => e.toString()).toList();
      storeName = profileJSON["store_name"];
      storeLogo = profileJSON["store_logo"];
      storeAddress = jsonStringToMap(profileJSON["store_address"]);
      var userAddressResponse = await Server().postFormData(body: {
        "customer_id": sellerID.toString()
      }, url: "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/address/getallAddress");
      print("userAddressResponse: $sellerID");
      fetchingDataType = "fetch your addresses";
      notifyListeners();
      if (userAddressResponse == null) {
        showMessage("Failed to get a response from the server!");
        hideLoader();
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return;
      }
      if (userAddressResponse.statusCode == 200) {
        if (jsonDecode(userAddressResponse.body)["status"]) {
          List<dynamic> userAddressJSON =
              await jsonDecode(userAddressResponse.body)["message"];
          //log(userAddressJSON.toString());
          Map<String, String> body = {};
          userAddresses = [];
          for (var map in userAddressJSON) {
            body = {};
            map.forEach((key, value) {
              body.addAll({key: value.toString()});
            });
            userAddresses.add(body);
          }
          checkAdd.clear();
          checkBoxAdd();
          log(userAddresses.toString());
          notifyListeners();
        }
      } else if (response.statusCode == 400) {
        showMessage("Undefined parameter when calling API");
        hideLoader();
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      } else if (response.statusCode == 404) {
        showMessage("API not found");
        hideLoader();
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      } else {
        log("Error: ${response.statusCode}");
        showMessage("Failed to get data!");
        hideLoader();
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      }
      fetchingDataType = "fetching your notifications";
      notifyListeners();
      notifications = await getNotifications(showMessage);
      notifyListeners();
    } else if (response.statusCode == 400) {
      showMessage("Undefined parameter when calling API");
      hideLoader();
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else if (response.statusCode == 404) {
      showMessage("API not found");
      hideLoader();
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else {
      if (jsonDecode(response.body)["message"]
          .toString()
          .contains("Seller is Under Verification")) {
        hideLoader();
        showMessage("Verification");
        navigator.pushReplacement(MaterialPageRoute(
            builder: (context) => ApplicationStatusScreen(
                  uID: userIdForAddress,
                )));
      } else {
        hideLoader();
        showMessage("Failed to get data!");
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      }
    }
  }

  Map<String, String> jsonStringToMap(String data) {
    List<String> str = data
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll("\"", "")
        .replaceAll("'", "")
        .split(",");
    Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }
    return result
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  Future<void> createAddress(
      NavigatorState navigatorState,
      Map<String, String> addressList,
      Position? location,
      Function(String) showMessage,
      LoginProvider loginProvider,
      NavigatorState navigator) async {
    //Send this data to the server
    var response = await post(
      Uri.parse(
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/address/add"),
      body: jsonEncode({
        "customer_id": sellerID,
        "address_title": addressList["address_type"] ?? "",
        "firstname": firstName.isEmpty ? storeName.split("").first : firstName,
        "lastname": lastName.isEmpty
            ? storeName.replaceFirst("${storeName.split("").first} ", "")
            : lastName,
        "company": "Nandikrushi",
        "flat_no": addressList["house_number"] ?? "",
        "landmark": addressList["landmark"] ?? "",
        "address_1":
            "${(addressList["full_address"] ?? "").split(",")[0]},${(addressList["full_address"] ?? "").split(",")[1]}",
        "address_2": (addressList["full_address"] ?? "").replaceFirst(
            "${(addressList["full_address"] ?? "").split(",")[0]},${(addressList["full_address"] ?? "").split(",")[1]},",
            ""),
        "city": addressList["city"] ?? "",
        "state": addressList["state"] ?? "",
        "country": addressList["country"] ?? "",
        "default": 1.toString(),
        "postcode": addressList["pincode"] ?? "",
        "alternative_number": addressList["alternate_mobile_number"] ?? "",
        "coordinates": [
          {"longitude": location?.longitude, "latitude": location?.latitude}
        ]
      }),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      log(response.body);
      getProfile(
          userID: userIdForAddress,
          showMessage: showMessage,
          loginProvider: loginProvider,
          navigator: navigator);
      hideLoader();
      notifyListeners();
    } else if (response.statusCode == 400) {
      showMessage("Undefined parameter when calling API");
      hideLoader();
    } else if (response.statusCode == 404) {
      showMessage("API not found");
      hideLoader();
    } else {
      showMessage("Failed to get data!");
      hideLoader();
    }

    navigatorState.pop();
  }

  Future<List<Map<String, String>>> getNotifications(
      Function(String) showError) async {
    var isTimedOut = false;
    var url =
        "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/savednotifications/getsavednotifications";

    var response = await Server()
        .getMethodParams(
      url,
    )
        .timeout(const Duration(seconds: 5), onTimeout: () {
      isTimedOut = true;
      return [];
    });

    if (!isTimedOut) {
      if (response.statusCode == 200 && jsonDecode(response.body)["status"]) {
        log("sucess");
        log(response.body);
        List<dynamic> values = jsonDecode(response.body)["message"];

        var iterables = values
            .where((element) =>
                element["user_id"] == null ||
                element["user_id"] == userIdForAddress ||
                element["user_id"] == "")
            .map(
              (e) => {
                "title": e["title"].toString(),
                "description": e["description"].toString(),
                "image": e["image"].toString(),
                "data": e["data"].toString(),
                "type": e["notification_type"].toString()
              },
            )
            .toList();
        return iterables;
      } else if (response.statusCode == 400) {
        showError("Undefined Parameter when calling API");
        log("Undefined Parameter");
        return [];
      } else if (response.statusCode == 404) {
        showError("API Not found");
        log("Not found");
        return [];
      } else {
        showError("Failed to get data!");
        log("failure ${response.statusCode}");
        return [];
      }
    } else {
      showError("Failed to get data!");
      log("failure");
      return [];
    }
  }
}
