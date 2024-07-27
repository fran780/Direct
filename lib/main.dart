import 'package:direct/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

import 'firebase_options.dart';
import 'package:direct/screens/auth/login_screen.dart';
import 'package:direct/screens/developers_screen.dart';
import 'package:direct/screens/about_screen.dart';

// objeto global para acceder al tamaño de pantalla del dispositivo
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // entra en pantalla completa
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // para configurar la orientación a solo retrato
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Direct',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
        backgroundColor: Colors.white,
      )),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/developers': (context) => DevelopersScreen(),
        '/features': (context) => FeaturesScreen(),
      },
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats');
print('\nNotification channel Result: $result');

}