import 'dart:math';

import 'package:direct/api/apis.dart';
import 'package:direct/helper/my_date_util.dart';
import 'package:direct/main.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromld
        ? _greenMessage()
        : _blueMessage();
  }

  // Mensaje azul para usuario
  Widget _blueMessage() {

    // Actualizar lectura del ultimo mensaje cuando se envien y reciben mensajes diferentes
    if(widget.message.read.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
      print('mensaje actualizado');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),

        // Etiqueta de hora de envio de mensaje
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ),

      ],
    );
  }

  //// Mensaje verde para usuario
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //texto de hora de envio de mensaje
        Row(
           children: [
            //para añadir un espacio
            SizedBox(width: mq.width * .04),
            if(widget.message.read.isNotEmpty)
            // double tick blue for message read
            Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),
            
            //para añadir un espacio
            const SizedBox(width: 2),
            // Enviar tiempo
            Text(
              MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
          ],
      ),


        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 252, 209),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
      ],
    ); 
  }
}
