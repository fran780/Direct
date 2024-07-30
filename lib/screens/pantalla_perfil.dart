import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:direct/api/apis.dart';
import 'package:direct/helper/dialogs.dart';
import 'package:direct/models/usuarios_chat.dart';
import 'package:direct/screens/auth/pantalla_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

//pantalla para ver la informacion del usuario
class Pantalla_perfil extends StatefulWidget {
  final ChatUser user;

  const Pantalla_perfil({super.key, required this.user});

  @override
  State<Pantalla_perfil> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Pantalla_perfil> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //para ocultar teclado
      onTap: () => FocusScope.of(context).unfocus,

      child: Scaffold(
          appBar: AppBar(title: const Text('Perfil')),
          //Boton flotante para agregar un nuevo usuario
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                //mostrar progresos de dialogo
                Dialogs.showProgressBar(context);

                await APIs.updateActiveStatus(false);

                //salir de la app
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //Para ocultar el dialogo del progreso
                    Navigator.pop(context);

                    //para volver a la pantalla de inicio
                    Navigator.pop(context);
                    APIs.auth = FirebaseAuth.instance;

                    //reemplazando la pantalla de inicio con la pantalla de inicio de sesión
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Pantalla_login()));
                  });
                });
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesion'),
            ),
          ),
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
                        _image != null
                            ?

                            //Imagen local
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                ))
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
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
                            onPressed: () {
                              _showBottomSheet();
                            },
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
                          : 'Campo requerido',
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'Cristiano Ronaldo',
                          label: Text('Nombre')),
                    ),

                    SizedBox(height: mq.height * .02),

                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Campo requerido',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.info_outline,
                              color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'Me siento feliz',
                          label: Text('Información')),
                    ),

                    SizedBox(height: mq.height * .05),

                    // Actualizar el boton de perfil
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          minimumSize: Size(mq.width * .5, mq.height * .06)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackbar(
                                context, 'Perfil actualizado correctamente');
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 28,
                      ),
                      label: const Text(
                        'ACTUALIZAR',
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

  // Boton para que el usuario elija foto de usuario
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .01, bottom: mq.height * .05),
            children: [
              const Text('Imagen de Perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              SizedBox(height: mq.height * .01),

              //botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .2, mq.height * .20)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Poner una imagen
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          print(
                              'Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .2, mq.height * .20)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          if (mounted) Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}