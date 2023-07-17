// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for the My Account Screen

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/nav_items/profile_screen.dart';
import 'package:nandikrushi_farmer/product/address_bottom_sheet.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/loader_screen.dart';
import 'package:nandikrushi_farmer/reusable_widgets/material_you_clipper.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../onboarding/login/login_provider.dart';
import '../utils/size_config.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<LoginProvider>(builder: (context, loginProvider, _) {
        return Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
          return Stack(
            children: [
              !profileProvider.isDataFetched
                  ? Scaffold(
                      appBar: profileScreenAppBar(
                        context,
                        userName: "Nandikrushi Farmer",
                        userPhoneNumber: " ",
                        userEmail: " ",
                        userRole: loginProvider.userAppTheme.key,
                        themeData: Theme.of(context),
                      ),
                      body: SafeArea(
                        bottom: false,
                        child: Column(
                          children: [
                            listTileWithouTI(context,
                                title: "Logout",
                                leading: Icons.power_settings_new, ontap: () {
                              signOut(context);
                            }),
                            const Spacer(),
                            Opacity(
                              opacity: 0.5,
                              child: SizedBox(
                                  height: 56,
                                  child: Image.asset('assets/images/logo.png')),
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Text(
                                'Nandikrushi',
                                style: TextStyle(
                                  fontFamily: 'Samarkan',
                                  fontSize: 48,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TextWidget(
                              "truly food is medicine",
                              size: 12,
                              weight: FontWeight.w600,
                              color: Colors.grey[500],
                              align: TextAlign.center,
                              lSpace: 2.4,
                            ),
                            TextWidget(
                              "v1.2.0+60",
                              size: 12,
                              weight: FontWeight.w600,
                              color: Colors.grey[500],
                              align: TextAlign.center,
                            ),
                          ],
                        ),
                      ))
                  : LayoutBuilder(builder: (context, constraints) {
                      return Scaffold(
                        appBar: profileScreenAppBar(
                          context,
                          userName: loginProvider.isFarmer
                              ? "${profileProvider.firstName} ${profileProvider.lastName}"
                              : profileProvider.storeName,
                          userPhoneNumber: profileProvider.telephone,
                          userEmail: profileProvider.email,
                          userImage: loginProvider.isFarmer
                              ? profileProvider.sellerImage
                              : profileProvider.storeLogo,
                          userRole: loginProvider.userAppTheme.key,
                          themeData: Theme.of(context),
                        ),
                        body: SafeArea(
                          bottom: false,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      listTileWithouST(context,
                                          title: "Profile",
                                          leading: Icons.person, ontap: () {
                                        Navigator.maybeOf(context)?.push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ProfileScreen()));
                                      }),
                                      listTileWithouST(context,
                                          title: "Address",
                                          leading: Icons.location_on,
                                          ontap: () {
                                        showAddressesBottomSheet(context,
                                            profileProvider, Theme.of(context),
                                            isOrderWorkflow: false);
                                      }),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Divider(
                                          thickness: 0.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent),
                                        child: Column(
                                          children: [
                                            ExpansionTile(
                                              collapsedIconColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.6),
                                              iconColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              title: Text(
                                                "Support",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              leading: SizedBox(
                                                height: double.infinity,
                                                child: Icon(
                                                  Icons.support_agent,
                                                  size: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.fontSize,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                              children: [
                                                listTileWithouST(context,
                                                    title: "Contact Us",
                                                    leading: Icons.call,
                                                    ontap: () {
                                                  dialCall();
                                                }),
                                                listTileWithouST(context,
                                                    title: "Email",
                                                    leading: Icons.email,
                                                    ontap: () {
                                                  launchEmail();
                                                }),
                                                listTileWithouST(context,
                                                    title: "Terms & Conditions",
                                                    leading: Icons.description,
                                                    ontap: () {
                                                  log('Terms & Conditions');
                                                }),
                                                listTileWithouST(context,
                                                    title: "Privacy Policy",
                                                    leading: Icons.security,
                                                    ontap: () {
                                                  log('Privacy Policy');
                                                }),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Divider(
                                          thickness: 0.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      listTileWithouTI(context,
                                          title: "Share App",
                                          leading: Icons.share, ontap: () {
                                        Share.share(
                                            "Install and explore the Nandikrushi Farmer app to shop your edibles",
                                            subject: 'Nandikrushi Farmer');
                                      }),
                                      listTileWithouTI(context,
                                          title: "Logout",
                                          leading: Icons.power_settings_new,
                                          ontap: () async {
                                        signOut(context);
                                      }),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 120),
                                Column(
                                  children: [
                                    Opacity(
                                      opacity: 0.5,
                                      child: SizedBox(
                                          height: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.fontSize,
                                          child: Image.asset(
                                              'assets/images/logo.png')),
                                    ),
                                    Text(
                                      "Nandikrushi",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            fontFamily: "Samarkan",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? 0.5
                                                    : 1),
                                          ),
                                    ),
                                    Text(
                                      "truly food is medicine",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? 0.1
                                                      : 0.55),
                                              fontSize: getProportionateHeight(
                                                  11, constraints),
                                              letterSpacing: 2.4),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextWidget(
                                      "v1.2.0+60",
                                      size: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.fontSize,
                                      weight: FontWeight.w600,
                                      color: Colors.lightGreen.shade200,
                                      align: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              profileProvider.shouldShowLoader
                  ? LoaderScreen(profileProvider)
                  : const SizedBox(),
            ],
          );
        });
      });
    });
  }

  PreferredSizeWidget profileScreenAppBar(BuildContext context,
      {String? userImage,
      required String userName,
      required String userPhoneNumber,
      required String userEmail,
      required String userRole,
      required ThemeData themeData}) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(164),
      child: Container(
        height: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(35),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24).copyWith(top: 64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              userImage == null
                  ? Image.asset("assets/images/account_farmer.png")
                  : ClipPath(
                      clipper: MaterialClipper(),
                      child: Image.network(
                        userImage,
                        fit: BoxFit.cover,
                        height: ((userName.length < 12
                                    ? themeData
                                        .textTheme.headlineMedium?.fontSize
                                    : themeData
                                        .textTheme.titleLarge?.fontSize) ??
                                50) +
                            (themeData.textTheme.titleMedium?.fontSize ?? 50) +
                            (themeData.textTheme.bodySmall?.fontSize ?? 50) +
                            (themeData.textTheme.titleMedium?.fontSize ?? 14) *
                                0.7 +
                            24,
                        width: ((userName.length < 12
                                    ? themeData
                                        .textTheme.headlineMedium?.fontSize
                                    : themeData
                                        .textTheme.titleLarge?.fontSize) ??
                                50) +
                            (themeData.textTheme.titleMedium?.fontSize ?? 50) +
                            (themeData.textTheme.bodySmall?.fontSize ?? 50) +
                            (themeData.textTheme.titleMedium?.fontSize ?? 14) *
                                0.7 +
                            24,
                      )),
              const SizedBox(
                width: 32,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      userName,
                      size: userName.length < 12
                          ? themeData.textTheme.headlineMedium?.fontSize
                          : themeData.textTheme.titleLarge?.fontSize,
                      color: themeData.colorScheme.primary,
                      height: 1,
                    ),
                    TextWidget(
                      userRole.toUpperCase(),
                      weight: FontWeight.w500,
                      color: themeData.colorScheme.primary.withOpacity(0.5),
                      size: (themeData.textTheme.titleMedium?.fontSize ?? 14) *
                          0.7,
                      lSpace: 3,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextWidget(
                      userPhoneNumber,
                      weight: FontWeight.w500,
                      color: themeData.colorScheme.primary.withOpacity(0.5),
                      size: themeData.textTheme.titleMedium?.fontSize,
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: TextWidget(
                        userEmail,
                        weight: FontWeight.w500,
                        size: themeData.textTheme.bodySmall?.fontSize,
                        color: themeData.colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future signOut(
  BuildContext context,
) {
  return showModalBottomSheet(
      context: context,
      elevation: 22,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 30),
                  height: 160,
                  child: Image.asset('assets/images/farmer_ploughing.png')),
              const SizedBox(
                height: 54,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Logout',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Are Sure, You Want to Leave the App?',
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButtonWidget(
                    height: 56,
                    textColor: Colors.white,
                    buttonName: 'Yes, I want to leave',
                    textStyle: FontWeight.w600,
                    borderRadius: 5.0,
                    borderSideColor: Colors.indigo[900],
                    onClick: () async {
                      LoginProvider loginProvider =
                          Provider.of(context, listen: false);
                      loginProvider.hideLoader();
                      FirebaseAuth.instance.signOut();
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.clear();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => const SplashScreen())));
                    }),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: ElevatedButtonWidget(
                  bgColor: Colors.green[50],
                  height: 56,
                  textColor: Colors.grey[900],
                  buttonName: 'Close',
                  textStyle: FontWeight.w600,
                  borderRadius: 5.0,
                  borderSideColor: Colors.indigo[50],
                  onClick: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      });
}

ListTile listTileWithouST(BuildContext context,
    {title, leading, VoidCallback? ontap}) {
  return ListTile(
    title: TextWidget(
      title,
      size: Theme.of(context).textTheme.titleMedium?.fontSize,
      weight: Theme.of(context).textTheme.titleMedium?.fontWeight,
    ),
    leading: SizedBox(
      height: double.infinity,
      child: Icon(
        leading,
        size: Theme.of(context).textTheme.titleMedium?.fontSize,
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: Theme.of(context).textTheme.titleMedium?.fontSize,
    ),
    onTap: ontap,
  );
}

listTileWithouTI(BuildContext context, {title, leading, VoidCallback? ontap}) {
  return ListTile(
    title: TextWidget(
      title,
      size: Theme.of(context).textTheme.titleMedium?.fontSize,
      weight: Theme.of(context).textTheme.titleMedium?.fontWeight,
    ),
    leading: SizedBox(
      height: double.infinity,
      child: Icon(
        leading,
        size: Theme.of(context).textTheme.titleMedium?.fontSize,
      ),
    ),
    onTap: ontap,
  );
}

dialCall({String mobileNumber = "8341980196"}) async {
  var url = "tel:$mobileNumber";
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

void launchEmail({String mailID = "info@spotmies.com"}) async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: mailID,
  );
  if (await canLaunchUrl(params)) {
    await launchUrl(params);
  } else {
    log('Could not launch $params');
  }
}
