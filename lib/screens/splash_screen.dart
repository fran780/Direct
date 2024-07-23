import 'package:direct/api/apis.dart';
import 'package:direct/main.dart';
import 'package:direct/screens/auth/login_screen.dart';
import 'package:direct/screens/home_screen.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Pantalla Splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      //sale de pantalla completa
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        print("User: ${APIs.auth.currentUser}");
        
        //navega a home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        //navega a login Screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //inicializa el media query (para obtener el tamaño de la pantalla del dispositivo)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          //app logo
          Positioned(
              top: mq.height * .15,
              right: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset('images/icon.png')),
          //boton de login google
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: const Text(
                'Direct Made For You 😃',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.black87, letterSpacing: 2),
              )),
        ],
      ),
    );
  }
}
