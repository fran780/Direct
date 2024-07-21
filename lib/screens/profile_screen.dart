import 'package:cached_network_image/cached_network_image.dart';
import 'package:direct/api/apis.dart';
import 'package:direct/helper/dialogs.dart';
import 'package:direct/models/chat_user.dart';
import 'package:direct/screens/auth/login_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

//pantalla para ver la informacion del usuario
class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //para ocultar teclado
      onTap: () => FocusScope.of(context).unfocus,

      child: Scaffold(
          appBar: AppBar(title: const Text('Profile Screen')),
          //Boton flotante para agregar un nuevo usuario
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                //mostrar progresos de dialogo
                Dialogs.showProgressBar(context);

                //salir de la app
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //Para ocultar el dialogo del progreso
                    Navigator.pop(context);

                    //para volver a la pantalla de inicio
                    Navigator.pop(context);

                    //reemplazando la pantalla de inicio con la pantalla de inicio de sesión
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  });
                });
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),

          // body:
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //para añadir espacio
                    SizedBox(width: mq.width, height: mq.height * .03),

                    // Imagen de perfil del usuario
                    Stack(
                      children: [
                        //foto de perfil
                        ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .1),
                          child: CachedNetworkImage(
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.fill,
                            imageUrl: widget.user.image,
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                                    child: Icon(CupertinoIcons.person)),
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {},
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),

                    //para añadir espacio
                    SizedBox(height: mq.height * .03),

                    Text(widget.user.email,
                        style: TextStyle(color: Colors.black54, fontSize: 16)),

                    SizedBox(height: mq.height * .05),

                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Happy Singh',
                          label: Text('Name')),
                    ),

                    SizedBox(height: mq.height * .02),

                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.info_outline,
                              color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Feeling Happy',
                          label: Text('About')),
                    ),

                    SizedBox(height: mq.height * .05),

                    // Actualizar el boton de perfil
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          minimumSize: Size(mq.width * .5, mq.height * .06)),
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value){
                            Dialogs.showSnackbar(context, 'Perfil actualizado correctamente');
                          });
                        }

                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 28,
                      ),
                      label: const Text(
                        'UPDATE',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
