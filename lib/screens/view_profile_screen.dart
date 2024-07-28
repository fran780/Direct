import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:direct/api/apis.dart';
import 'package:direct/helper/dialogs.dart';
import 'package:direct/helper/my_date_util.dart';
import 'package:direct/models/chat_user.dart';
import 'package:direct/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

//pantalla para ver la informacion del usuario
class viewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const viewProfileScreen({super.key, required this.user});

  @override
  State<viewProfileScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<viewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //para ocultar teclado
      onTap: () => FocusScope.of(context).unfocus,

      child: Scaffold(
          appBar: AppBar(title: Text(widget.user.name)),

          floatingActionButton: //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Joined On:',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt, showYear :true),
                          style:
                              TextStyle(color: Colors.black54, fontSize: 15)),
                    ],
                  ),

          // body:
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //para añadir espacio
                  SizedBox(width: mq.width, height: mq.height * .03),

                  // Imagen de perfil del usuario
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  //para añadir espacio
                  SizedBox(height: mq.height * .03),

                  Text(widget.user.email,
                      style: TextStyle(color: Colors.black87, fontSize: 16)),

                  SizedBox(height: mq.height * .02),

                  //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text(widget.user.about,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
