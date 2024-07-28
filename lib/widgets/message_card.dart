import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:direct/api/apis.dart';
import 'package:direct/helper/dialogs.dart';
import 'package:direct/helper/my_date_util.dart';
import 'package:direct/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';

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
    bool isMe = APIs.user.uid == widget.message.fromld;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  // Mensaje azul para usuario
  Widget _blueMessage() {
    // Actualizar lectura del ultimo mensaje cuando se envien y reciben mensajes diferentes
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      print('mensaje actualizado');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.message.type == Type.text
                ?
                //Show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),

        // Etiqueta de hora de envio de mensaje
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
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
            if (widget.message.read.isNotEmpty)
              // double tick blue for message read
              Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),

            //para añadir un espacio
            const SizedBox(width: 2),
            // Enviar tiempo
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 252, 209),
                border: Border.all(color: Colors.lightGreen),
                //
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // Boton para que el usuario elija foto de usuario
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(
                      vertical: mq.height * .015, horizontal: mq.width * .4),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8))),

              //boton de copiar
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copiar Texto',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          Navigator.pop(context);

                          Dialogs.showSnackbar(context, 'Texto copiado');
                        });
                      })

                  // descargar o guardar imagen
                  : _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Guardar imagen',
                      onTap: () async {
                        try {
                          print('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'Direct')
                              .then((success) {
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, 'Imagen guardada correctamente');
                            }
                          });
                        } catch (e) {
                          print('Error al guardar la imagen: $e');
                        }
                      }),

              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

              //boton de editar
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Editar mensaje',
                    onTap: () {}),

              //boton de eliminar
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Borrar mensaje',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        Navigator.pop(context);
                      });
                    }),

              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              //tiempo de mensaje enviado
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye,
                      color: Colors.blue, size: 26),
                  name:
                      'Enviado: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //tiempo de leido
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye,
                      color: Colors.green, size: 26),
                  name: widget.message.read.isEmpty
                      ? 'Leido: No ha sido leido'
                      : 'Leido: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .02),
          child: Row(children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: const TextStyle(
                  fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
            ))
          ]),
        ));
  }
}
