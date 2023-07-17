// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the Add Address screen

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/places.dart' as gmw;
import 'package:http/http.dart';
import 'package:location/location.dart' as location;
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/onboarding/login/login_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/loader_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/reusable_widgets/textfield_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddAddressesScreen extends StatefulWidget {
  const AddAddressesScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressesScreen> createState() => _AddAddressesScreenState();
}

class _AddAddressesScreenState extends State<AddAddressesScreen> {
  var searchController = TextEditingController();
  List<Map<String, String>> addresses = [];
  Position? userLocation;
  var isSearching = true;
  PageController pageController = PageController();
  var userAddress = {};
  GlobalKey<FormState> addressFormKey = GlobalKey();
  var formControllers = {
    'house_number': TextEditingController(),
    'landmark': TextEditingController(),
    'full_address': TextEditingController(),
    'city': TextEditingController(),
    'state': TextEditingController(),
    'country': TextEditingController(),
    'pincode': TextEditingController(),
    'alternate_mobile_number': TextEditingController(),
  };

  var chipSelection = 0;
  var otherController = TextEditingController();

  Future<Position?> getLocationAndPermission() async {
    bool serviceEnabled;

    LocationPermission permissionGranted;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.Location().requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await Geolocator.checkPermission();
    log(permissionGranted.name.toString());
    if (permissionGranted == LocationPermission.denied) {
      permissionGranted = await Geolocator.requestPermission();
      if (permissionGranted != location.PermissionStatus.granted) {
        return null;
      }
    }

    userLocation = await Geolocator.getCurrentPosition();
    log(userLocation.toString());

    gmw.GoogleMapsPlaces places =
        gmw.GoogleMapsPlaces(apiKey: PlacesAPISDK.apiKey);
    gmw.PlacesSearchResponse results = await places
        .searchNearbyWithRadius(
            gmw.Location(
                lat: userLocation?.latitude ?? 0,
                lng: userLocation?.longitude ?? 0),
            searchController.text.isNotEmpty ? 20000 : 100000,
            keyword: searchController.text)
        .timeout(const Duration(seconds: 10));
    addresses = [];
    // ignore: avoid_function_literals_in_foreach_calls
    results.results.forEach((e) async {
      final sessionToken = const Uuid().v4();
      final request =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=${e.placeId}&fields=address_component&key=${PlacesAPISDK.apiKey}&sessiontoken=$sessionToken';
      await get(Uri.parse(request)).then((value) {
        List<dynamic> address =
            jsonDecode(value.body)["result"]["address_components"];
        log(address.toString());
        var postalCode = address.firstWhere((value) {
          List<dynamic> types = value["types"];
          var isPCorPremise = types.contains("postal_code");
          return isPCorPremise;
        }, orElse: () {
          return {"long_name": ""};
        })["long_name"];
        var premise = address.firstWhere((value) {
          List<dynamic> types = value["types"];
          var isPCorPremise = types.contains("premise");
          return isPCorPremise;
        }, orElse: () {
          return {"long_name": ""};
        })["long_name"];
        var city = address.firstWhere((value) {
          List<dynamic> types = value["types"];
          var isPCorPremise = types.contains("administrative_area_level_2");
          return isPCorPremise;
        }, orElse: () {
          return {"long_name": ""};
        })["long_name"];
        var state = address.firstWhere((value) {
          List<dynamic> types = value["types"];
          var isPCorPremise = types.contains("administrative_area_level_1");
          return isPCorPremise;
        }, orElse: () {
          return {"long_name": ""};
        })["long_name"];
        var country = address.firstWhere((value) {
          List<dynamic> types = value["types"];
          var isPCorPremise = types.contains("country");
          return isPCorPremise;
        }, orElse: () {
          return {"long_name": ""};
        })["long_name"];
        address.retainWhere((value) {
          List<dynamic> types = value["types"];
          var isPCorPremise = types.contains("postal_code") ||
              types.contains("premise") ||
              types.contains("administrative_area_level_2") ||
              types.contains("administrative_area_level_1") ||
              types.contains("country");
          log(isPCorPremise.toString());
          return !isPCorPremise;
        });
        var tempData = address
            .map(
              (e) => e["long_name"].toString(),
            )
            .toSet()
            .toList();
        tempData.insert(0, e.name);
        var data = tempData.join(", ");
        //log(data);
        var geolocatedLocationAddress = {
          "name": e.name,
          "address": data.toString(),
          "postal_code": postalCode.toString(),
          "premise": premise.toString(),
          "city": city.toString(),
          "state": state.toString(),
          "country": country.toString(),
        };
        addresses.add(geolocatedLocationAddress);
        addresses = addresses.toSet().toList();
        setState(() {
          isSearching = false;
        });
      });
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getLocationAndPermission();
      //log(userLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              toolbarHeight: kToolbarHeight,
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.location_searching_rounded,
                  )),
              title: TextWidget(
                'Add Address',
                size: Theme.of(context).textTheme.titleMedium?.fontSize,
                weight: FontWeight.w700,
              ),
            ),
            body: PageView.builder(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, pageIndex) {
                  return pageIndex == 0
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: TextFieldWidget(
                                  onChanged: (_) {
                                    setState(() {
                                      isSearching = true;
                                      getLocationAndPermission();
                                    });
                                  },
                                  textInputAction: TextInputAction.search,
                                  onSubmitField: () {
                                    setState(() {
                                      isSearching = true;
                                      getLocationAndPermission();
                                    });
                                  },
                                  controller: searchController,
                                  label: "Search",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  suffix: Container(
                                    margin: const EdgeInsets.all(12),
                                    child: ClipOval(
                                        child: Container(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            padding: const EdgeInsets.all(0),
                                            child: const Icon(
                                              Icons.search_rounded,
                                              color: Colors.white,
                                            ))),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 23,
                              ),
                              !isSearching
                                  ? addresses.isNotEmpty
                                      ? ListView.separated(
                                          shrinkWrap: true,
                                          primary: false,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: ((context, index) {
                                            return InkWell(
                                              onTap: () {
                                                userAddress = addresses[index];
                                                pageController.animateToPage(1,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeInOut);
                                                formControllers["house_number"]
                                                        ?.text =
                                                    userAddress["premise"] ??
                                                        "";
                                                formControllers["full_address"]
                                                        ?.text =
                                                    userAddress["address"] ??
                                                        "";
                                                formControllers["city"]?.text =
                                                    userAddress["city"] ?? "";
                                                formControllers["state"]?.text =
                                                    userAddress["state"] ?? "";
                                                formControllers["country"]
                                                        ?.text =
                                                    userAddress["country"] ??
                                                        "";
                                                formControllers["pincode"]
                                                    ?.text = userAddress[
                                                        "postal_code"] ??
                                                    "";
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                    const SizedBox(
                                                      width: 24,
                                                    ),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextWidget(
                                                            addresses[index]
                                                                ["name"],
                                                            weight:
                                                                FontWeight.w700,
                                                            flow: TextOverflow
                                                                .visible,
                                                            size: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.fontSize,
                                                          ),
                                                          TextWidget(
                                                              addresses[index]
                                                                  ["address"],
                                                              flow: TextOverflow
                                                                  .visible,
                                                              color:
                                                                  Colors.grey),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                          separatorBuilder: (context, index) {
                                            return const Divider();
                                          },
                                          itemCount: addresses.length,
                                        )
                                      : Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Image(
                                                    image: AssetImage(
                                                        'assets/images/delivery_address.png')),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                TextWidget(
                                                  'Oops!',
                                                  weight: FontWeight.w800,
                                                  size: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.fontSize,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                TextWidget(
                                                  'Couldn\'t find a place around you with that name 😢',
                                                  weight: FontWeight.w600,
                                                  color: Colors.grey,
                                                  flow: TextOverflow.visible,
                                                  align: TextAlign.center,
                                                  size: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.fontSize,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          const SizedBox(
                                            height: 27,
                                          ),
                                          TextWidget(
                                            "Loading...",
                                            weight: FontWeight.bold,
                                            align: TextAlign.center,
                                            size: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.fontSize,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : Form(
                          key: addressFormKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 256,
                                  child: Image.network(
                                    "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller: formControllers[
                                                  'house_number'],
                                              label: 'House / Flat No.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              validator: (_) {
                                                if (_ == null || _.isEmpty) {
                                                  return "Please enter your valid house number";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 24,
                                          ),
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller:
                                                  formControllers['landmark'],
                                              label: 'Landmark',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              validator: (_) {
                                                if (_ == null || _.isEmpty) {
                                                  return "Please enter a valid landmark";
                                                }
                                                return null;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      TextFieldWidget(
                                        controller:
                                            formControllers['full_address'],
                                        label: 'Address',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        validator: (_) {
                                          if (_ == null || _.isEmpty) {
                                            return "Please enter your valid address";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller:
                                                  formControllers['city'],
                                              label: 'City',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              validator: (_) {
                                                if (_ == null || _.isEmpty) {
                                                  return "Please enter a valid city";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 24,
                                          ),
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller:
                                                  formControllers['state'],
                                              label: 'State',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              validator: (_) {
                                                if (_ == null || _.isEmpty) {
                                                  return "Please enter a valid state";
                                                }
                                                return null;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller:
                                                  formControllers['country'],
                                              label: 'Country',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              validator: (_) {
                                                if (_ == null || _.isEmpty) {
                                                  return "Please enter a valid country";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 24,
                                          ),
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller:
                                                  formControllers['pincode'],
                                              label: 'Pincode',
                                              showCounter: false,
                                              maxLength: 6,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              validator: (_) {
                                                if (_ == null ||
                                                    _.isEmpty ||
                                                    _.length != 6) {
                                                  return "Please enter a valid pincode";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: TextFieldWidget(
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: formControllers[
                                                  'alternate_mobile_number'],
                                              label: 'Alternative Contact',
                                              maxLength: 10,
                                              showCounter: true,
                                              validator: (_) {
                                                if (_ == null ||
                                                    _.isEmpty ||
                                                    _.length != 10) {
                                                  return "Please enter a valid contact number";
                                                }
                                                return null;
                                              },
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          chipSelection = 0;
                                        });
                                      },
                                      child: Chip(
                                        backgroundColor: chipSelection == 0
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.5),
                                        avatar: const Icon(
                                          Icons.home_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        label: const TextWidget(
                                          'Home',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          chipSelection = 1;
                                        });
                                      },
                                      child: Chip(
                                        backgroundColor: chipSelection == 1
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.5),
                                        avatar: const Icon(
                                          Icons.work_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        label: const TextWidget(
                                          'Office',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              chipSelection = 2;
                                            });
                                          },
                                          child: Chip(
                                            backgroundColor: chipSelection == 2
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.5),
                                            avatar: const Icon(
                                              Icons.place_rounded,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            label: const TextWidget(
                                              'Other',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          height: 24,
                                          width: chipSelection == 2 ? 80 : 0,
                                          child: TextFieldWidget(
                                            controller: otherController,
                                            textInputAction:
                                                TextInputAction.done,
                                            validator: (_) {
                                              if (chipSelection == 2) {
                                                if (_ == null || _.isEmpty) {
                                                  return "Please enter a valid address type";
                                                }
                                              }
                                              return null;
                                            },
                                            hint: 'Other',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 12, 24, 24),
                                  alignment: Alignment.center,
                                  child: ElevatedButtonWidget(
                                    onClick: () {
                                      profileProvider.showLoader();
                                      var validateForm = addressFormKey
                                              .currentState
                                              ?.validate() ??
                                          false;
                                      Map<String, String> addressList = {};
                                      if (validateForm) {
                                        formControllers.forEach((key, value) {
                                          addressList[key] = value.text;
                                        });
                                        addressList.addAll({
                                          "address_type": chipSelection == 0
                                              ? "Home"
                                              : chipSelection == 1
                                                  ? "Office"
                                                  : otherController.text
                                                      .toString()
                                        });
                                        LoginProvider loginProvider =
                                            Provider.of<LoginProvider>(context,
                                                listen: false);

                                        profileProvider.createAddress(
                                            Navigator.of(context),
                                            addressList,
                                            userLocation, (_) {
                                          snackbar(context, _);
                                        }, loginProvider,
                                            Navigator.of(context));
                                      } else {
                                        profileProvider.hideLoader();
                                      }
                                    },
                                    height: 56,
                                    borderRadius: 12,
                                    bgColor:
                                        Theme.of(context).colorScheme.primary,
                                    textColor: Colors.white,
                                    buttonName: 'Save'.toUpperCase(),
                                    trailingIcon: Icons.check_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                }),
          ),
          profileProvider.shouldShowLoader
              ? LoaderScreen(profileProvider)
              : const SizedBox(),
        ],
      );
    });
  }
}

class PlacesAPISDK {
  static const apiKey = 'AIzaSyD9RFDxjCbHTBGX5bmoE6aDG8HswIH8xZk';
  late Prediction? instance;
  Future<Prediction?> init(context) async {
    instance = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      mode: Mode.overlay,
    );
    return instance;
  }
}
