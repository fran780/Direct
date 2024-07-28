import 'package:direct/api/apis.dart';
import 'package:direct/main.dart';
import 'package:direct/screens/auth/pantalla_login.dart';
import 'package:direct/screens/pantalla_listadechats.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Pantalla_bienvenida extends StatefulWidget {
  const Pantalla_bienvenida({super.key});

  @override
  State<Pantalla_bienvenida> createState() => _Pantalla_bienvenidaState();
}

class _Pantalla_bienvenidaState extends State<Pantalla_bienvenida> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      //sale de pantalla completa
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white, statusBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        print("User: ${APIs.auth.currentUser}");

        //navega a pantalla lista de chats
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Pantalla_listadechats()));
      } else {
        //navega a pantalla de login
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Pantalla_login()));
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
                'Mantente conectado con Direct',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.black87, letterSpacing: 2),
              )),
        ],
      ),
    );
  }
}