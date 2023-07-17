// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:nandikrushi_farmer/firebase_options.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/splash_screen.dart';
import 'package:nandikrushi_farmer/utils/custom_color_util.dart';
import 'package:nandikrushi_farmer/utils/theme.dart';
import 'package:provider/provider.dart';

import 'onboarding/login/login_provider.dart';

Future<void> main() async {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = false;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // if (!kIsWeb) {
  //   if (Platform.isAndroid) {
  //     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //       systemNavigationBarColor: Colors.transparent,
  //     ));
  //     //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //   }
  // }
  var data = await getAppTheme();
  //FirebaseAuth.instance.signOut();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<LoginProvider>(
      create: (context) {
        var loginProvider = LoginProvider();

        loginProvider.updateUserAppType(data);
        return loginProvider;
      },
    ),
    ChangeNotifierProvider<ProductProvider>(
      create: (context) => ProductProvider(),
    ),
    ChangeNotifierProvider<ProfileProvider>(
      create: (context) => ProfileProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, loginProvider, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nandikrushi Farmer',
        theme: ThemeData(
            fontFamily: "Product Sans",
            useMaterial3: true,
            colorScheme: getLightTheme(loginProvider)),
        darkTheme: ThemeData(
          //backgroundColor: Colors.grey.shade900,
          // primarySwatch: createMaterialColor(
          //     createMaterialColor(loginProvider.userAppTheme.value).shade100),
          colorScheme: getDarkTheme(loginProvider),
          fontFamily: "Product Sans",
          useMaterial3: true,
          //scaffoldBackgroundColor: const Color(0xFF191C19),
        ),
        home: const SplashScreen(),
      );
    });
  }
}
