//import 'dart:math';

import 'dart:io';

import 'package:direct/helper/dialogs.dart';
import 'package:direct/main.dart';
import 'package:direct/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//Pantalla Login - implementa iniciar sesion o registrase con google
class _LoginScreenState extends State<LoginScreen> {
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
  //btn que maneja iniciar sesion con google con un clock
  _handleGoogleBtnClick() {
    //para mostrar la barra de progreso
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //para esconder la barra de progreso
      Navigator.pop(context);
      if (user != null) {
        print("User: ${user.user}");
        print('UserAdditionalInfo: ${user.additionalUserInfo}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(
          context, 'Algo salió mal (Revisa tu conexión a internet)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    //inicializa el media query (para obtener el tamoño de la pnatalla del dispositivo)
    //mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Bienvenido a Direct'),
      ),
      body: Stack(
        children: [
          //app logo
          AnimatedPositioned(
              top: mq.height * .15,
              right: _isAnimate ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .5,
              duration: const Duration(seconds: 1),
              child: Image.asset('images/icon.png')),
          //boton de login google
          Positioned(
              bottom: mq.height * .15,
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
                  //icono google
                  icon:
                      Image.asset('images/google.png', height: mq.height * .03),
                  //texto Loging con google
                  label: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16),
                          children: [
                        TextSpan(text: 'Iniciar Sesion con '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ])))),
        ],
      ),
    );
  }
}
