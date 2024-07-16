import 'package:direct/main.dart';
import 'package:direct/screens/home_screen.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    //inicializa el media query (para obtener el tamoño de la pnatalla del dispositivo)
    mq = MediaQuery.of(context).size;

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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()));
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
