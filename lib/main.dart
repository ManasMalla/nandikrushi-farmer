import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:nandikrushi_farmer/color_schemes.dart';
import 'package:nandikrushi_farmer/domain/enum/user_type.dart';
import 'package:nandikrushi_farmer/firebase_options.dart';
import 'package:nandikrushi_farmer/presentation/layouts/application_pending_screen.dart';
import 'package:nandikrushi_farmer/presentation/layouts/onboarding/language_selection_screen.dart';
import 'package:nandikrushi_farmer/presentation/layouts/onboarding/onboarding_screen.dart';
import 'package:nandikrushi_farmer/presentation/layouts/onboarding/user_type_selection_screen.dart';
import 'package:nandikrushi_farmer/splash_screen.dart';

Future<void> main() async {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = false;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp(
    userType: UserType.restaraunt,
  ));
}

class MyApp extends StatefulWidget {
  final UserType userType;
  const MyApp({Key? key, required this.userType}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nandikrushi Farmer',
      theme: ThemeData(
        fontFamily: "Product Sans",
        colorScheme: getColorSchemeFromType(widget.userType, Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: "Product Sans",
        colorScheme: getColorSchemeFromType(widget.userType, Brightness.dark),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(userType: widget.userType),
        'onboarding': (context) => const OnboardingScreen(),
        'user-type-selection': (context) => const UserTypeSelectionScreen(),
        'language-selection': (context) => LanguageSelectionScreen(),
        'login': (context) => Container(),
        'not-verified': (context) => const ApplicationStatusScreen(),
        'home-screen': (context) => Placeholder(),
      },
    );
  }

  ColorScheme getColorSchemeFromType(UserType userType, Brightness mode) {
    if (mode == Brightness.light) {
      switch (userType) {
        case UserType.farmer:
          return farmerLightColorScheme;
        case UserType.store:
          return storeLightColorScheme;
        case UserType.restaraunt:
          return restaurantLightColorScheme;
      }
    } else {
      switch (userType) {
        case UserType.farmer:
          return farmerDarkColorScheme;
        case UserType.store:
          return storeDarkColorScheme;
        case UserType.restaraunt:
          return restaurantDarkColorScheme;
      }
    }
  }
}
