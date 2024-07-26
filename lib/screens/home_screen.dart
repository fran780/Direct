

import 'package:direct/api/apis.dart';
import 'package:direct/models/chat_user.dart';
import 'package:direct/widgets/chat_user_card.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //para almacenar usuarios
  List<ChatUser> _list = [];

  //para almacenar elementos buscados
  final List<ChatUser> _searchList = [];

  //para almacenar el estado de busqueda
  bool _isSearching = false;

  void initState() {
    super.initState();
    APIs.getSelfInfo();
    //Para ver si esta activo
    APIs.updateActiveStatus(true);

//los eventos de activo o inactivo
    SystemChannels.lifecycle.setMessageHandler((message) {
    print('Message: $message');
      
      if (message.toString().contains('resume'))APIs.updateActiveStatus(true);
      if (message.toString().contains('pause'))APIs.updateActiveStatus(false);

    return Future.value(message);

    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //para ocultar el teclado cuando se detecta un toque en la pantalla
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        // Si la búsqueda está activada y se presiona el botón Atrás, cierre la búsqueda
        // o simplemente cerrar la pantalla actual con el botón Atrás
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nombre, Correo, ...'),
                    autofocus: true,
                    style: TextStyle(fontSize: 16, letterSpacing: 0.5),
                    //el texto de búsqueda cambia cuando se actualiza la lista de búsqueda
                    onChanged: (val) {
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : const Text('Direct'),
            actions: [
              //boton para buscar usuarios
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              //boton de mas opciones
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.me)));
                  },
                  icon: const Icon(Icons.more_vert))
            ],
          ),
          //Boton flotante para agregar un nuevo usuario
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
                onPressed: () async {
                  await APIs.auth.signOut();
                  await GoogleSignIn().signOut();
                },
                child: const Icon(Icons.add_comment_rounded)),
          ),

          body: StreamBuilder(
            stream: APIs.getAllUsers(),
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
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        padding: EdgeInsets.only(top: mq.height * .01),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index]);
                          //return Text('Name: ${list[index]}');
                        });
                  } else {
                    return const Center(
                      child: Text('No se encontro conexión',
                          style: TextStyle(fontSize: 20)),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
