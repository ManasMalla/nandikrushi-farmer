import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/nav_items/profile_screen.dart';
import 'package:nandikrushi_farmer/product/address_bottom_sheet.dart';
import 'package:nandikrushi_farmer/reusable_widgets/elevated_button.dart';
import 'package:nandikrushi_farmer/reusable_widgets/text_widget.dart';
import 'package:nandikrushi_farmer/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      return !profileProvider.isDataFetched
          ? Scaffold(
              appBar: profileScreenAppBar(
                userName: "Nandikrushi Farmer",
                userPhoneNumber: " ",
                userEmail: " ",
                themeData: Theme.of(context),
              ),
              backgroundColor: Colors.white,
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
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextWidget(
                      "an aggregator of natural farmers",
                      size: 12,
                      weight: FontWeight.w600,
                      color: Colors.grey[500],
                      align: TextAlign.center,
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
                  userName:
                      "${profileProvider.firstName} ${profileProvider.lastName}",
                  userPhoneNumber: profileProvider.telephone,
                  userEmail: profileProvider.email,
                  userImage: profileProvider.sellerImage,
                  themeData: Theme.of(context),
                ),
                backgroundColor: Colors.white,
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
                                  leading: Icons.location_on, ontap: () {
                                showAddressesBottomSheet(
                                    context, profileProvider, Theme.of(context),
                                    isOrderWorkflow: false);
                              }),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Divider(
                                  thickness: 0.5,
                                  color: Color(0xFF007D08),
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: Column(
                                  children: [
                                    ExpansionTile(
                                      backgroundColor: Colors.white,
                                      collapsedBackgroundColor: Colors.white,
                                      textColor: Theme.of(context).primaryColor,
                                      iconColor: Theme.of(context).primaryColor,
                                      collapsedIconColor: Colors.grey,
                                      collapsedTextColor: Colors.grey[900],
                                      title: TextWidget(
                                        "Support",
                                        size: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.fontSize,
                                        weight: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.fontWeight,
                                        color: Colors.grey[900],
                                      ),
                                      leading: SizedBox(
                                        height: double.infinity,
                                        child: Icon(
                                          Icons.support_agent,
                                          size: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.fontSize,
                                        ),
                                      ),
                                      children: [
                                        listTileWithouST(context,
                                            title: "Contact Us",
                                            leading: Icons.call, ontap: () {
                                          dialCall();
                                        }),
                                        listTileWithouST(context,
                                            title: "Email",
                                            leading: Icons.email, ontap: () {
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
                                            leading: Icons.security, ontap: () {
                                          log('Privacy Policy');
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Divider(
                                  thickness: 0.5,
                                  color: Color(0xFF007D08),
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
                                FirebaseAuth.instance.signOut();
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.clear();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            SplashScreen())));
                                //signOut(context);
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 180),
                        Column(
                          children: [
                            Opacity(
                              opacity: 0.5,
                              child: SizedBox(
                                  height: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.fontSize,
                                  child: Image.asset('assets/images/logo.png')),
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Text(
                                'Nandikrushi',
                                style: TextStyle(
                                  fontFamily: 'Samarkan',
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.fontSize,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TextWidget(
                              "an aggregator of natural farmers",
                              size: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.fontSize,
                              weight: FontWeight.w600,
                              color: Colors.grey[500],
                              align: TextAlign.center,
                            ),
                            TextWidget(
                              "v1.2.0+60",
                              size: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.fontSize,
                              weight: FontWeight.w600,
                              color: Colors.grey[500],
                              align: TextAlign.center,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
    });
  }

  PreferredSizeWidget profileScreenAppBar(
      {String? userImage,
      required String userName,
      required String userPhoneNumber,
      required String userEmail,
      required ThemeData themeData}) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: Container(
        height: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF007D08).withOpacity(0.12),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(35),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              userImage == null
                  ? Image.asset("assets/images/account_farmer.png")
                  : ClipOval(
                      child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            userImage,
                            fit: BoxFit.cover,
                          ))),
              const SizedBox(
                width: 32,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    userName,
                    size: themeData.textTheme.headlineMedium?.fontSize,
                    color: const Color(0xFF007D08),
                    height: 1,
                  ),
                  TextWidget(
                    userPhoneNumber,
                    weight: FontWeight.w500,
                    color: const Color(0xFF007D08).withOpacity(0.5),
                    size: themeData.textTheme.titleMedium?.fontSize,
                  ),
                  TextWidget(
                    userEmail,
                    weight: FontWeight.w500,
                    size: themeData.textTheme.bodySmall?.fontSize,
                    color: Colors.grey.shade900.withOpacity(0.5),
                  ),
                ],
              )
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
                      await FirebaseAuth.instance
                          .signOut()
                          .then((action) async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.clear().then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SplashScreen()),
                              (route) => false);
                        });
                      }).catchError((e) {
                        log(e);
                      });
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
      color: Colors.grey[900],
    ),
    leading: SizedBox(
      height: double.infinity,
      child: Icon(
        leading,
        size: Theme.of(context).textTheme.titleMedium?.fontSize,
        color: Colors.grey,
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: Theme.of(context).textTheme.titleMedium?.fontSize,
      color: Colors.grey,
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
      color: Colors.grey[900],
    ),
    leading: SizedBox(
      height: double.infinity,
      child: Icon(
        leading,
        size: Theme.of(context).textTheme.titleMedium?.fontSize,
        color: Colors.grey,
      ),
    ),
    onTap: ontap,
  );
}

dialCall() async {
  const url = "tel:8341980196";
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

void launchEmail() async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'info@spotmies.com',
  );
  String url = params.toString();
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    log('Could not launch $url');
  }
}