import 'dart:io';

import 'package:direct/api/apis.dart';
import 'package:direct/helper/dialogs.dart';
import 'package:direct/main.dart';
import 'package:direct/screens/pantalla_listadechats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Pantalla_login extends StatefulWidget {
  const Pantalla_login({super.key});

  @override
  State<Pantalla_login> createState() => _Pantalla_loginState();
}

// Pantalla Login - implementa iniciar sesión o registrarse con Google
class _Pantalla_loginState extends State<Pantalla_login> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  // btn que maneja iniciar sesión con Google con un click
  _handleGoogleBtnClick() {
    // para mostrar la barra de progreso
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      // para esconder la barra de progreso
      Navigator.pop(context);
      if (user != null) {
        print("\nUser: ${user.user}");
        print('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Pantalla_listadechats()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const Pantalla_listadechats()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Activar el flujo de autenticación
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Detalles de autenticación de la solicitud
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Crear una nueva credencial
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      print('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(
          context, 'Algo salió mal (Revisa tu conexión a internet)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // inicializa el media query (para obtener el tamaño de la pantalla del dispositivo)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Bienvenido a Direct'),
      ),
      body: Stack(
        children: [
          // app logo
          AnimatedPositioned(
              top: mq.height * .15,
              right: _isAnimate ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .5,
              duration: const Duration(seconds: 1),
              child: Image.asset('images/icon.png')),
          // botón de login google
          Positioned(
              bottom: mq.height * .19,
              left: mq.width * .05,
              width: mq.width * .9,
              height: mq.height * .06,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 53, 141, 235),
                      shape: const StadiumBorder(),
                      elevation: 1),
                  onPressed: () {
                    _handleGoogleBtnClick();
                  },
                  // icono google
                  icon:
                      Image.asset('images/google.png', height: mq.height * .03),
                  // texto Loging con google
                  label: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16),
                          children: [
                        TextSpan(text: 'Iniciar Sesión con '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ])))),
          // textos interactivos
          Positioned(
            bottom: mq.height * .08,
            left: mq.width * .05,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/developers');
              },
              child: Text(
                'Desarrolladores',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: mq.height * .08,
            right: mq.width * .05,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/features');
              },
              child: Text(
                'Acerca de',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}