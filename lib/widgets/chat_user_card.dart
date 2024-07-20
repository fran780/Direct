import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          // Imagen de perfil del usuario
          leading: CircleAvatar(child: Icon(CupertinoIcons.person)),

          // Nombre de usuario
          title: Text('Demo User'),

          //Ultimo mensaje
          subtitle: Text('Last user message', maxLines: 1),

          // Tiempo del ultimo mensaje
          trailing: Text(
            '12:00 PM',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    ),
    );
  }
}
