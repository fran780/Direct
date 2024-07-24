import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:direct/main.dart';
import 'package:direct/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        //body
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //si los datos estan cargando
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());

                    //Si algunos o todos los datos están cargados, muéstrelos.
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      log('Data: ${jsonEncode(data![0].data())}');
                    /*_list =
                        data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                            [];
                    */
                      final _list = ['hola', 'hi'];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: mq.height * .01),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Text('Message: ${_list[index]}');
                            });
                      } else {
                        return const Center(
                          child: Text('Dí hola! 🤙🏼',
                              style: TextStyle(fontSize: 20)),
                        );
                      }
                  }
                },
              ),
            ),
            _chaInput()
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          // Boton de regresar
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black54,
              )),

          //Imagen de perfil de usuario
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .03),
            child: CachedNetworkImage(
              width: mq.height * .05,
              height: mq.height * .05,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) =>
                  const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),

          //para añadir un espacio
          const SizedBox(width: 10),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500)),
              //para añadir un espacio
              const SizedBox(height: 2),
              const Text('Última vez a las 12:00 pm',
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500)),
            ],
          )
        ],
      ),
    );
  }

  Widget _chaInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  // Boton de emoji
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),
                  const Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Escribe algo...',
                        hintStyle: TextStyle(
                          color: Colors.blueAccent,
                        ),
                        border: InputBorder.none),
                  )),

                  // Boton de galeria
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 26,
                      )),

                  // Boton de camara
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blueAccent,
                      )),

                  //añadir un espacio
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),

          //Boton de enviar mensaje
          MaterialButton(
            onPressed: () {},
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: CircleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
