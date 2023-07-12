// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The provider that handles every product related workflow

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:nandikrushi_farmer/domain/entity/product.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/utils/login_utils.dart';

import '../data/models/product_model.dart';
import '../utils/server.dart';

class ProductProvider extends ChangeNotifier {
  var selectedIndex = 0;

  Map<String, Map<String, String>> units = {
    "Vegetables": {
      "Kilogram": "kg",
      "Gram": "g",
      "Liter": "lt",
      "Milliliter": "ml",
      "Dozen": "dz"
    }
  };

  changeScreen(int _) {
    selectedIndex = _;
    notifyListeners();
  }

  var categories = {
    "A2 Milk": 17,
    "Vegetables": 24,
    "Fruits": 33,
    "Ghee": 57,
    "Oil": 20,
    "Millets": 18,
  };
  var allCategories = {
    "A2 Milk": 17,
    "Vegetables": 24,
    "Fruits": 33,
    "Ghee": 57,
    "Oil": 20,
    "Millets": 18,
  };
  var subcategories = {
    17: [
      {"A2 Milk": 17}
    ],
    24: [
      {"Vegetables": 24}
    ],
    33: [
      {"Fruits": 33}
    ],
    57: [
      {"Ghee": 57}
    ],
    20: [
      {"Oil": 20}
    ],
    18: [
      {"Millets": 18}
    ],
  };

  List<Map<String, String>> cart = [];
  List<Product> products = [];
  List<Map<String, String>> myProducts = [];
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> myPurchases = [];
  List<Map<String, String>> coupons = [];
  Map<String, List<Product>> categorizedProducts = {};
  Map<String, String> appliedCoupon = {};
  String myProductsMessage = "Oops!";
  bool deliverySlot = false;

  updateDeliverySlot(value) {
    deliverySlot = value;
    notifyListeners();
  }

  getCategories(
      {required Function(String) showMessage,
      required ProfileProvider profileProvider,
      bool isFromNavHost = false}) async {
    profileProvider.fetchingDataType = "fetch the categories";
    notifyListeners();
    profileProvider.showLoader();
    var url =
        "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/getcategories";
    var response = await Server().getMethodParams(url);
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
          categories = {};
          units = {};
          allCategories = {};
          (jsonDecode(response.body)["message"])
              .where((element) =>
                  element["customer_group_id"].toString() ==
                  profileProvider.customerGroupId)
              .toList()
              .forEach((e) {
            categories.addAll({
              capitalize(e["category_name"].toString().toLowerCase()):
                  int.tryParse(e["category_id"]) ?? 24
            });
            Map<String, String> tempUnitsMap = {};
            if (e["units"] != null) {
              e["units"].forEach((el) {
                tempUnitsMap
                    .addAll({el["id"].toString(): el["title"] ?? "units"});
              });
              units[capitalize(e["category_name"].toString().toLowerCase())] =
                  tempUnitsMap;
            }
          });
          //get all categories
          (jsonDecode(response.body)["message"]).toList().forEach((e) {
            allCategories.addAll({
              capitalize(e["category_name"].toString().toLowerCase()):
                  int.tryParse(e["category_id"]) ?? 24
            });
          });
          //if categories are empty for user group
          if (categories.isEmpty) {
            categories = profileProvider.customerGroupId == 3.toString()
                ? {"Flours": 0}
                : profileProvider.customerGroupId == 2.toString()
                    ? {"Vegetables": 24}
                    : {"Breakfast": 0};
            allCategories = {"Flours": 0, "Vegetables": 24, "Breakfast": 0};
            units = profileProvider.customerGroupId == 3.toString()
                ? {
                    "Flours": {"kilograms": "kgs"}
                  }
                : profileProvider.customerGroupId == 2.toString()
                    ? {
                        "Vegetables": {"kilograms": "kgs"}
                      }
                    : {
                        "Breakfast": {"plates": "plates"}
                      };
          }
        } else {
          showMessage("Error fetching categories 1!");
          profileProvider.hideLoader();
          notifyListeners();
        }

        notifyListeners();
      } on Exception catch (e) {
        showMessage("Error fetching categories - 2: $e");
        profileProvider.hideLoader();
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
  }

  getSubCategories(
      {required Function(String) showMessage,
      required ProfileProvider profileProvider,
      bool isFromNavHost = false}) async {
    profileProvider.showLoader();

    profileProvider.fetchingDataType = "fetch the subcategories";
    notifyListeners();
    var url =
        "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/getsubcategories";
    var response = await Server().getMethodParams(url);
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
          subcategories = {};
          (jsonDecode(response.body)["message"])
              .where(
                  (element) => element["customer_group_id"].toString() == "2")
              .toList()
              .forEach((e) {
            if (subcategories.isNotEmpty &&
                (subcategories[int.tryParse(e["parent_id"]) ?? 0]?.isNotEmpty ??
                    false)) {
              subcategories[int.tryParse(e["parent_id"]) ?? 0]!.add({
                capitalize(e["sub_category_name"].toString().toLowerCase()):
                    int.tryParse(e["sub_category_id"]) ?? 62
              });
            } else {
              subcategories.addAll({
                int.tryParse(e["parent_id"]) ?? 0: [
                  {
                    capitalize(e["sub_category_name"].toString().toLowerCase()):
                        int.tryParse(e["sub_category_id"]) ?? 62
                  }
                ]
              });
            }
          });
          if (subcategories.isEmpty) {
            subcategories = profileProvider.customerGroupId == 3.toString()
                ? {
                    0: [
                      {"Atta": 0}
                    ]
                  }
                : profileProvider.customerGroupId == 2.toString()
                    ? {
                        24: [
                          {"Leafy Vegetables": 0}
                        ]
                      }
                    : {
                        0: [
                          {"Idli": 0}
                        ]
                      };
          }
        } else {
          showMessage("Error fetching subcategories -2 !");
          profileProvider.hideLoader();
          notifyListeners();
        }

        notifyListeners();
      } on Exception catch (e) {
        showMessage("Error fetching subcategories: $e");
        profileProvider.hideLoader();
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
  }

  cancelOrder(BuildContext context,
      {required ProfileProvider profileProvider, required ordId}) async {
    profileProvider.showLoader();
    dynamic body = {"order_id": "$ordId"};
    var response = await post(
      Uri.parse(
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/getorders/cancelorder"),
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    dynamic resData = jsonDecode(response.body);
    log(resData.toString());
    if (response.statusCode == 200 && resData["status"] == true) {
      await getMyPurchases(
          showMessage: (s) {
            log(s);
          },
          profileProvider: profileProvider);
    } else {
      snackbar(context, "Something went wrong");
    }
    profileProvider.hideLoader();
  }

  updateTimeSlot(BuildContext context,
      {required ProfileProvider profileProvider, required dynamic body}) async {
    profileProvider.showLoader();
    var response = await post(
      Uri.parse(
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/updateordertimeslot"),
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    dynamic resData = jsonDecode(response.body);
    log(resData.toString());

    if (response.statusCode == 200 && resData["status"] == true) {
      await getMyPurchases(
          showMessage: (s) {
            log(s);
          },
          profileProvider: profileProvider);
    } else {
      snackbar(context, "Something went wrong");
    }
    profileProvider.hideLoader();
  }

  updateMyProduct(BuildContext context,
      {required ProfileProvider profileProvider, required dynamic body}) async {
    profileProvider.showLoader();
    var response = await post(
      Uri.parse(
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/productinstock"),
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    dynamic resData = jsonDecode(response.body);
    log(resData.toString());

    if (response.statusCode == 200 && resData["status"] == true) {
      await getMyProducts(
          showMessage: (s) {
            log(s);
          },
          profileProvider: profileProvider);
    } else {
      snackbar(context, "Something went wrong");
    }
    profileProvider.hideLoader();
  }

  acceptOrder(BuildContext context,
      {required ProfileProvider profileProvider, required dynamic body}) async {
    profileProvider.showLoader();
    var response = await post(
      Uri.parse(
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/acceptorder"),
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    dynamic resData = jsonDecode(response.body);
    log(resData.toString());

    if (response.statusCode == 200 && resData["status"] == true) {
      await getOrders(
          showMessage: (s) {
            log(s);
          },
          profileProvider: profileProvider);
    } else {
      snackbar(context, "Something went wrong");
    }
    profileProvider.hideLoader();
  }

  rejectOrder(BuildContext context,
      {required ProfileProvider profileProvider, required dynamic body}) async {
    profileProvider.showLoader();
    var response = await post(
      Uri.parse(
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/rejectorder"),
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    dynamic resData = jsonDecode(response.body);
    log(resData.toString());

    if (response.statusCode == 200 && resData["status"] == true) {
      await getOrders(
          showMessage: (s) {
            log(s);
          },
          profileProvider: profileProvider);
    } else {
      snackbar(context, "Something went wrong");
    }
    profileProvider.hideLoader();
  }

  getAllProducts(
      {required Function(String) showMessage,
      required ProfileProvider profileProvider,
      bool isFromNavHost = false}) async {
    profileProvider.fetchingDataType = "fetch our products";
    notifyListeners();
    profileProvider.showLoader();
    var url =
        "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/getallproducts";
    var response = await Server().getMethodParams(url);
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
        List<dynamic> decodedResponse = jsonDecode(response.body)["Products"];
        products = [];

        for (var e in decodedResponse) {
          if (allCategories.entries
              .where((element) =>
                  element.value ==
                  int.tryParse(e["category"][0]["category_id"] ?? "-1"))
              .isNotEmpty) {
            var product = ProductModel.fromJson(e, allCategories).toEntity();
                
              // 'customer_ratings': jsonEncode(e["Products"][0]["rating"]),
            //TODO Replace sellerID with actual data and certificate and add reviews

            
            

            log("12Prod->$product ,; $e");
            products.add(product);
          }
        }
        products = products.toSet().toList();

        for (var element in allCategories.keys) {
          categorizedProducts[element] = [];
          for (var product in products) {
            if (product.category == element) {
              categorizedProducts[element]?.add(product);
            }
          }
        }
        notifyListeners();
        await getMyProducts(
            showMessage: showMessage,
            profileProvider: profileProvider,
            isFromNavHost: isFromNavHost);
      } on Exception catch (e) {
        showMessage("Error fetching all products: $e");
        profileProvider.hideLoader();
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
  }

  getOrders(
      {required Function(String) showMessage,
      required ProfileProvider profileProvider,
      bool isFromNavHost = false}) async {
    profileProvider.fetchingDataType = "fetch your orders";
    notifyListeners();
    profileProvider.showLoader();

    var ordersData = await post(
      Uri.parse(
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/getorders"),
      body: jsonEncode({"customer_id": profileProvider.sellerID.toString()}),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (ordersData.statusCode == 200) {
      orders = [];
      try {
        if (jsonDecode(ordersData.body)["status"]) {
          List<dynamic> orderJSONResponse =
              jsonDecode(ordersData.body)["order"];
          for (var element in orderJSONResponse) {
            var orderData = {"order_id": element["order_id"]};
            orderData["products"] = [];
            for (var productOrderDetails
                in (element["product_details"] as List<dynamic>)) {
              // if (products
              //     .where((e) =>
              //         e.productId == productOrderDetails["product_id"])
              //     .isNotEmpty) {
              (orderData["products"]).add({
                "product_name": productOrderDetails["product_name"],
                "description": products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .isNotEmpty
                    ? products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .first.description
                    : (productOrderDetails["description"] ??
                        "Nandikrushi products are organic and fresh"),
                "url": products
                            .where((e) =>
                                e.productId ==
                                productOrderDetails["product_id"])
                            .isNotEmpty &&
                        (Uri.tryParse(products
                                    .where((e) =>
                                        e.productId ==
                                        productOrderDetails["product_id"])
                                    .first.image)
                                ?.host
                                .isNotEmpty ??
                            false)
                    ? products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .first.image
                    : "http://images.jdmagicbox.com/comp/visakhapatnam/q2/0891px891.x891.180329082226.k1q2/catalogue/nandi-krushi-visakhapatnam-e-commerce-service-providers-aomg9cai5i-250.jpg",
                "price": productOrderDetails["price"],
                "product_id": productOrderDetails["product_id"],
                "quantity": productOrderDetails["quantity"],
                "units": products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .isNotEmpty
                    ? products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .first.units
                    : "units",
                "place": element["shipping_details"][0]["shipping_city"],
              });
              // }
            }
            orderData.addAll({
              "customer_name":
                  "${element["customer_details"][0]["firstname"]} ${element["customer_details"][0]["lastname"]}",
              "date": element["delivery_details"][0]["delivery_date"],
              "order_status": element["delivery_details"][0]["order_status"],
            });

            orders.add(orderData);
          }
          log(orders.toString());
          if (!isFromNavHost) {
            profileProvider.isDataFetched = true;
            notifyListeners();
            profileProvider.hideLoader();
          } else {
            notifyListeners();
          }
        } else {
          orders = [];
          notifyListeners();
          if (!isFromNavHost) {
            profileProvider.isDataFetched = true;
            notifyListeners();
            profileProvider.hideLoader();
          } else {
            notifyListeners();
          }
        }
      } on Exception catch (e) {
        showMessage("Error fetching orders: $e");
        profileProvider.hideLoader();
        notifyListeners();
      }

      await getMyPurchases(
          showMessage: showMessage,
          profileProvider: profileProvider,
          isFromNavHost: isFromNavHost);
    } else if (ordersData.statusCode == 400) {
      showMessage("Undefined parameter when calling API");
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else if (ordersData.statusCode == 404) {
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
  }

  getMyPurchases(
      {required Function(String) showMessage,
      required ProfileProvider profileProvider,
      bool isFromNavHost = false}) async {
    profileProvider.fetchingDataType = "fetch your purchases";
    notifyListeners();
    profileProvider.showLoader();

    var myPurchasesData = await post(
      Uri.parse(
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/mypurchases"),
      body: jsonEncode({"customer_id": profileProvider.sellerID.toString()}),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (myPurchasesData.statusCode == 200) {
      myPurchases = [];
      try {
        if (jsonDecode(myPurchasesData.body)["status"]) {
          List<dynamic> myPurchasesJSONResponse =
              jsonDecode(myPurchasesData.body)["order"];
          for (var element in myPurchasesJSONResponse) {
            var myPurchasesData = {"order_id": element["order_id"]};
            myPurchasesData["products"] = [];
            for (var productOrderDetails
                in (element["product_details"] as List<dynamic>)) {
              // print(
              //     "The rating of the product you've purchased: ${}");
              // if (products
              //     .where((e) =>
              //         e.productId == productOrderDetails["product_id"])
              //     .isNotEmpty) {
              (myPurchasesData["products"]).add({
                "product_name": productOrderDetails["product_name"],
                "order_status_id": element["order_status_id"],
                "order_status": element["order_status"],
                "delivery_time": element["delivery_details"][0]
                    ["delivery_time"],
                "description": products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .isNotEmpty
                    ? products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .first.description
                    : (productOrderDetails["description"] ??
                        "Nandikrushi products are organic and fresh"),
                "url": products
                            .where((e) =>
                                e.productId ==
                                productOrderDetails["product_id"])
                            .isNotEmpty &&
                        (Uri.tryParse(products
                                    .where((e) =>
                                        e.productId ==
                                        productOrderDetails["product_id"])
                                    .first.image)
                                ?.host
                                .isNotEmpty ??
                            false)
                    ? products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .first.image
                    : "http://images.jdmagicbox.com/comp/visakhapatnam/q2/0891px891.x891.180329082226.k1q2/catalogue/nandi-krushi-visakhapatnam-e-commerce-service-providers-aomg9cai5i-250.jpg",
                "price": productOrderDetails["price"],
                "product_id": productOrderDetails["product_id"],
                "quantity": productOrderDetails["quantity"],
                "units": products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .isNotEmpty
                    ? products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .first.units
                    : "units",
                "payment_method": element["payment_details"][0]
                    ["payment_method"],
                "place": element["shipping_details"][0]["shipping_city"],
                "shipping_firstname": element["shipping_details"][0]
                    ["shipping_firstname"],
                "shipping_lastname": element["shipping_details"][0]
                    ["shipping_lastname"],
                "shipping_address_1": element["shipping_details"][0]
                    ["shipping_address_1"],
                "shipping_house_number": element["shipping_details"][0]
                    ["house_no"],
                "shipping_address_2": element["shipping_details"][0]
                    ["shipping_address_2"],
                "shipping_city": element["shipping_details"][0]
                    ["shipping_city"],
                "shipping_postcode": element["shipping_details"][0]
                    ["shipping_postcode"],
                "shipping_country": element["shipping_details"][0]
                    ["shipping_country"],
                "shipping_zone": element["shipping_details"][0]
                    ["shipping_zone"],
                "telephone": element["customer_details"][0]["telephone"],
                "rating": products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .isNotEmpty
                    ? products
                        .where((e) =>
                            e.productId ==
                            productOrderDetails["product_id"])
                        .first.aggregateRating
                    : "3.5"
              });
              // }
            }
            myPurchasesData.addAll({
              "store_name": "${element["store_details"][0]["store_name"]}",
              "date": element["delivery_details"][0]["delivery_date"],
            });

            myPurchases.add(myPurchasesData);
          }
          log(myPurchases.toString());
          if (!isFromNavHost) {
            profileProvider.isDataFetched = true;
            notifyListeners();
            profileProvider.hideLoader();
          } else {
            notifyListeners();
          }
        } else {
          myPurchases = [];
          notifyListeners();
          if (!isFromNavHost) {
            profileProvider.isDataFetched = true;
            notifyListeners();
            profileProvider.hideLoader();
          } else {
            notifyListeners();
          }
        }
      } on Exception catch (e) {
        showMessage("Error fetching my purchases: $e");
        profileProvider.hideLoader();
        notifyListeners();
      }
    } else if (myPurchasesData.statusCode == 400) {
      showMessage("Undefined parameter when calling API");
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else if (myPurchasesData.statusCode == 404) {
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
  }

  getCart(
      {required Function(String) showMessage,
      required ProfileProvider profileProvider,
      bool isFromNavHost = false}) async {
    profileProvider.fetchingDataType = "fetch your cart";
    notifyListeners();
    var cartData = await Server().postFormData(
        url:
            "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/cart/products",
        body: {
          "customer_id": profileProvider.sellerID.toString(),
        });
    if (cartData == null) {
      showMessage("Failed to get a response from the server!");
      //hideLoader();
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return;
    }
    if (cartData.statusCode == 200) {
      try {
        if (jsonDecode(cartData.body)["status"]) {
          List<dynamic> cartJSONResponse =
              jsonDecode(cartData.body)["cart_products"];
          cart = cartJSONResponse.where((cartItem) {
            return products
                .where((element) =>
                    element.productId.toString() ==
                    (cartItem["product_id"].toString()))
                .isNotEmpty;
          }).map((cartItem) {
            var productCartItem = products
                .where((element) =>
                    element.productId.toString() ==
                    (cartItem["product_id"].toString()))
                .first;
            return {
              "cart_id": cartItem["cart_id"].toString(),
              "name": productCartItem.name.toString(),
              'unit': productCartItem.units.toString(),
              "product_id": cartItem["product_id"].toString(),
              "quantity": cartItem['quantity'].toString(),
              'price': productCartItem.price
                  .toString()
                  .replaceFirst("\$", "")
                  .toString(),
              'place': productCartItem.produceLocation.toString(),
              'url': (Uri.tryParse(productCartItem.image.toString())
                          ?.host
                          .isNotEmpty ??
                      false)
                  ? productCartItem.image.toString()
                  : "http://images.jdmagicbox.com/comp/visakhapatnam/q2/0891px891.x891.180329082226.k1q2/catalogue/nandi-krushi-visakhapatnam-e-commerce-service-providers-aomg9cai5i-250.jpg",
            };
          }).toList();
          log("CART: $cart");
          if (!isFromNavHost) {
            profileProvider.isDataFetched = true;
            notifyListeners();
            profileProvider.hideLoader();
          } else {
            notifyListeners();
          }
        } else {
          cart = [];

          log("CART: $cart");
          if (!isFromNavHost) {
            profileProvider.isDataFetched = true;
            notifyListeners();
            profileProvider.hideLoader();
          } else {
            notifyListeners();
          }
        }
      } on Exception catch (e) {
        showMessage("Error fetching cart: $e");
        profileProvider.hideLoader();
        notifyListeners();
      }
    } else if (cartData.statusCode == 400) {
      showMessage("Undefined parameter when calling API");
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else if (cartData.statusCode == 404) {
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
  }

  getMyProducts(
      {required Function(String) showMessage,
      required ProfileProvider profileProvider,
      bool isFromNavHost = false}) async {
    profileProvider.fetchingDataType = "fetch your products";
    notifyListeners();
    var myProductsData = await Server().postFormData(
        url:
            "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/sellerproduct/GetSellerproductdata",
        body: {
          "user_id": profileProvider.userIdForAddress,
        });
    if (myProductsData == null) {
      showMessage("Failed to get a response from the server!");
      //hideLoader();
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return;
    }

    if (myProductsData.statusCode == 200) {
      try {
        if (jsonDecode(myProductsData.body)["status"]) {
          List<dynamic> myProductsJSONResponse =
              jsonDecode(myProductsData.body)["message"];
          myProducts = myProductsJSONResponse
              .map((e) => (e as Map<String, dynamic>)
                  .map((key, value) => MapEntry(key, value.toString())))
              .toList();
          log(myProducts.toString());
        } else {
          myProducts = [];
          myProductsMessage =
              myProductsData.body.toLowerCase().contains("disabled")
                  ? "Products have been disabled"
                  : "Oops!";
        }
        if (!isFromNavHost) {
          profileProvider.isDataFetched = true;
          notifyListeners();
          profileProvider.hideLoader();
        } else {
          notifyListeners();
        }
      } on Exception catch (e) {
        showMessage("Error fetching my products: $e");
        profileProvider.hideLoader();
        notifyListeners();
      }
    } else if (myProductsData.statusCode == 400) {
      showMessage("Undefined parameter when calling API");
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else if (myProductsData.statusCode == 404) {
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
  }

  getCoupons(
      {required Function(String) showMessage,
      required ProfileProvider profileProvider,
      bool isFromNavHost = false}) async {
    profileProvider.fetchingDataType = "fetch great coupons";
    notifyListeners();
    var couponsData = await Server().getMethodParams(
        "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/coupon/getcoupon");
    if (couponsData == null) {
      showMessage("Failed to get a response from the server!");
      //hideLoader();
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return;
    }
    if (couponsData.statusCode == 200) {
      try {
        if (jsonDecode(couponsData.body)["status"]) {
          List<dynamic> couponsJSONResponse =
              jsonDecode(couponsData.body)["message"];
          coupons = couponsJSONResponse
              .map((e) => (e as Map<String, dynamic>)
                  .map((key, value) => MapEntry(key, value.toString())))
              .toList();
          coupons.retainWhere((e) {
            return DateFormat("yyyy-MM-dd")
                    .parse(e["date_end"].toString())
                    .isAfter(DateTime.now()) &&
                DateFormat("yyyy-MM-dd")
                    .parse(e["date_start"].toString())
                    .isBefore(DateTime.now());
          });
          log(coupons.toString());
        }
        if (!isFromNavHost) {
          profileProvider.isDataFetched = true;
          notifyListeners();
          profileProvider.hideLoader();
        } else {
          notifyListeners();
        }
      } on Exception catch (e) {
        showMessage("Error fetching coupons: $e");
        profileProvider.hideLoader();
        notifyListeners();
      }
    } else if (couponsData.statusCode == 400) {
      showMessage("Undefined parameter when calling API");
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } else if (couponsData.statusCode == 404) {
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
  }

  Future<void> addProductToCart(
      {required BuildContext context,
      required String productID,
      required Function() onSuccessful,
      required Function(String) showMessage,
      required ProfileProvider profileProvider}) async {
    var cartElementExists =
        cart.where((element) => element["product_id"] == productID).isNotEmpty;

    profileProvider.fetchingDataType = "modify your cart";
    notifyListeners();
    profileProvider.showLoader();
    if (cartElementExists) {
      modifyProductToCart(
          context: context,
          productID: productID,
          onSuccessful: onSuccessful,
          showMessage: showMessage,
          profileProvider: profileProvider);

      profileProvider.hideLoader();
    } else {
      String apiURL =
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/cart/add";
      var cartData = await Server().postFormData(url: apiURL, body: {
        "customer_id": profileProvider.sellerID,
        "product_id": productID,
        "quantity": 1.toString(),
      });
      if (cartData == null) {
        showMessage("Failed to get a response from the server!");
        profileProvider.hideLoader();
        return;
      }
      if (cartData.statusCode == 200) {
        if (jsonDecode(cartData.body)["status"]) {
          await getCart(
              showMessage: showMessage, profileProvider: profileProvider);
          await getAllProducts(
              showMessage: showMessage, profileProvider: profileProvider);
        } else {
          snackbar(context, jsonDecode(cartData.body)["message"]);
        }
        profileProvider.isDataFetched = true;
      } else if (cartData.statusCode == 400) {
        showMessage("Undefined parameter when calling API");
      } else if (cartData.statusCode == 404) {
        showMessage("API not found");
      } else {
        showMessage("Failed to get data!");
      }
      profileProvider.hideLoader();
    }
  }

  Future<void> modifyProductToCart(
      {required BuildContext context,
      required String productID,
      required Function() onSuccessful,
      required Function(String) showMessage,
      required ProfileProvider profileProvider}) async {
    var productDetails =
        products.where((e) => e.productId.toString() == productID).first;
    var initialCartIems = int.tryParse(cart
                .where((e) => e["product_id"] == productDetails.productId.toString())
                .first["quantity"] ??
            "0") ??
        0;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, setSheetState) {
            return Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productDetails.name ?? "Product Name",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          productDetails.category ?? "Category",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        productDetails.description != null
                            ? SizedBox(
                                width: double.infinity,
                                child: TextWidget(
                                  productDetails.description,
                                  flow: TextOverflow.ellipsis,
                                ),
                              )
                            : const SizedBox(),
                        TextWidget(
                            "Rs. ${productDetails.price.toStringAsFixed(2)}"),
                        TextWidget(productDetails.units ?? "1 unit"),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded),
                            Expanded(
                              child: TextWidget(
                                productDetails.produceLocation ?? "Visakhapatnam",
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  minimumSize: Size.zero, // Set this
                                  padding: const EdgeInsets.all(4), // and this
                                  side: const BorderSide(width: 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100))),
                              onPressed: () {
                                setSheetState(() {
                                  initialCartIems--;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 2),
                                child: Icon(
                                  Icons.remove_rounded,
                                  size: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            Text(
                              initialCartIems.toString(),
                              style: Theme.of(context).textTheme.button,
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  minimumSize: Size.zero, // Set this
                                  padding: const EdgeInsets.all(4), // and this
                                  side: const BorderSide(width: 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100))),
                              onPressed: () {
                                setSheetState(() {
                                  initialCartIems++;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 2),
                                child: Icon(
                                  Icons.add,
                                  size: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ElevatedButtonWidget(
                          onClick: () async {
                            Navigator.of(context).pop();
                            profileProvider.fetchingDataType =
                                "modify your cart";
                            notifyListeners();
                            profileProvider.showLoader();
                            String apiURL = initialCartIems == 0
                                ? "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/cart/remove"
                                : "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/cart/update";
                            var updateCartBody = {
                              "customer_id": profileProvider.sellerID,
                              "product_id": productID,
                            };
                            if (initialCartIems != 0) {
                              updateCartBody.addAll({
                                "quantity": initialCartIems.toString(),
                              });
                            }
                            log("payload->$updateCartBody");
                            var cartData = await Server().postFormData(
                                url: apiURL, body: updateCartBody);
                            if (cartData == null) {
                              showMessage(
                                  "Failed to get a response from the server!");
                              //hideLoader();
                              if (Platform.isAndroid) {
                                SystemNavigator.pop();
                              } else if (Platform.isIOS) {
                                exit(0);
                              }
                              return;
                            }

                            if (cartData.statusCode == 200) {
                              if (jsonDecode(cartData.body)["status"]) {
                                await getAllProducts(
                                    showMessage: showMessage,
                                    profileProvider: profileProvider);
                                await getCart(
                                    showMessage: showMessage,
                                    profileProvider: profileProvider);
                              }
                              profileProvider.isDataFetched = true;
                            } else if (cartData.statusCode == 400) {
                              showMessage(
                                  "Undefined parameter when calling API");
                              profileProvider.hideLoader();
                            } else if (cartData.statusCode == 404) {
                              showMessage("API not found");
                              profileProvider.hideLoader();
                            } else {
                              showMessage("Failed to get data!");
                              profileProvider.hideLoader();
                            }
                            // Navigator.of(context).pop();
                          },
                          height: 54,
                          borderRadius: 8,
                          bgColor: Theme.of(context).colorScheme.primary,
                          textColor: Colors.white,
                          buttonName: "Update".toUpperCase(),
                          innerPadding: 0.02,
                          // textStyle: FontWeight.bold,
                          trailingIcon: Icons.auto_fix_high_rounded,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Image.network(
                      productDetails.image ?? "",
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  Future<void> removeProductFromCart(
      {required BuildContext context,
      required String productID,
      required Function() onSuccessful,
      required Function(String) showMessage,
      required ProfileProvider profileProvider}) async {
    var cartElementExists = (int.tryParse(cart
                    .where((element) => element["product_id"] == productID)
                    .first["quantity"] ??
                "") ??
            0) >
        1;

    profileProvider.fetchingDataType = "modify your cart";
    notifyListeners();
    profileProvider.showLoader();
    if (cartElementExists) {
      modifyProductToCart(
          context: context,
          productID: productID,
          onSuccessful: onSuccessful,
          showMessage: showMessage,
          profileProvider: profileProvider);

      profileProvider.hideLoader();
    } else {
      String apiURL =
          "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/cart/remove";
      var body = {
        "customer_id": profileProvider.sellerID,
        "product_id": productID,
      };

      var cartData = await Server().postFormData(url: apiURL, body: body);
      if (cartData == null) {
        showMessage("Failed to get a response from the server!");
        notifyListeners();
        profileProvider.hideLoader();
        return;
      }
      if (cartData.statusCode == 200) {
        if (jsonDecode(cartData.body)["status"]) {
          await getCart(
              showMessage: showMessage, profileProvider: profileProvider);
          await getAllProducts(
              showMessage: showMessage, profileProvider: profileProvider);
        }
        profileProvider.isDataFetched = true;
        notifyListeners();
      } else if (cartData.statusCode == 400) {
        showMessage("Undefined parameter when calling API");
      } else if (cartData.statusCode == 404) {
        showMessage("API not found");
      } else {
        showMessage("Failed to get data!");
      }
      profileProvider.hideLoader();
      notifyListeners();
    }
  }

  updateCoupon(Map<String, String> _) {
    appliedCoupon = _;
    notifyListeners();
  }

  Future<void> getData(
      {required Function(String) showMessage,
      required ProfileProvider profileProvider}) async {
    await getCategories(
        showMessage: showMessage,
        profileProvider: profileProvider,
        isFromNavHost: true);
    await getSubCategories(
        showMessage: showMessage,
        profileProvider: profileProvider,
        isFromNavHost: true);
    await getAllProducts(
        showMessage: showMessage,
        profileProvider: profileProvider,
        isFromNavHost: true);
    await getOrders(
        showMessage: showMessage,
        profileProvider: profileProvider,
        isFromNavHost: true);
    await getCart(
        showMessage: showMessage,
        profileProvider: profileProvider,
        isFromNavHost: true);

    await getCoupons(
        showMessage: showMessage,
        profileProvider: profileProvider,
        isFromNavHost: true);

    profileProvider.isDataFetched = true;
    notifyListeners();
    profileProvider.hideLoader();
  }
}
