import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_project/service/background_service.dart';
import 'views/home.dart';
import 'provider/provider.dart';
import 'views/auth/login.dart';
import 'config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // initializeService();
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  MobileAds.instance.initialize();

  AwesomeNotifications().initialize(
    "resource://drawable/didapedia",
    [
      NotificationChannel(
          channelKey: "dida_pedia",
          channelName: "DidaPedia",
          channelDescription: "DidaPedia Online Shop")
    ],
  );
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(ChangeNotifierProvider(
    create: (context) => CartProviderV2(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dida Pedia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: VerifyLoggedUser(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
      ],
    );
  }
}

class VerifyLoggedUser extends StatelessWidget {
  const VerifyLoggedUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data as User?;
          if (user == null) {
            return LoginPage();
          } else {
            return MyHome();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
