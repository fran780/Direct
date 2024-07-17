import 'package:direct/main.dart';
import 'package:direct/screens/home_screen.dart';
import 'package:flutter/material.dart';

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
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
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
