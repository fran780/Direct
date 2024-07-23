import 'package:flutter/material.dart';

class FeaturesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de la aplicación:'),
      ),
      body: ListView(
        padding: EdgeInsets.all(40.0),
        children: [
          Text(
            'Estas son las principales características que lo harán disfrutar de Direct:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16), // Espacio entre el título y las características
          FeatureTile(
            feature: 'La aplicación permitirá la interacción únicamente con contactos conocidos para mejorar la seguridad y privacidad.',
          ),
          FeatureTile(
            feature: 'Los usuarios podrán acceder a la aplicación mediante su cuenta de Google, eliminando la necesidad de crear una cuenta específica o proporcionar un número de teléfono móvil.',
          ),
          FeatureTile(
            feature: 'Los usuarios podrán encontrar y agregar nuevos contactos utilizando sus direcciones de correo electrónico.',
          ),
          FeatureTile(
            feature: 'Cada usuario tendrá un perfil que incluye una foto, información básica, la fecha de la última conexión y la fecha de creación de la cuenta.',
          ),
          FeatureTile(
            feature: 'Los usuarios podrán ver cuándo sus mensajes han sido leídos por el destinatario.',
          ),
          FeatureTile(
            feature: 'Se permitirá a los usuarios editar o eliminar mensajes enviados, ofreciendo más control sobre sus comunicaciones.',
          ),
          FeatureTile(
            feature: 'Las notificaciones push alertarán a los usuarios sobre nuevos mensajes recibidos, asegurando que no se pierda ninguna comunicación importante.',
          ),
          FeatureTile(
            feature: 'La aplicación contará con una interfaz de usuario atractiva y fácil de usar.',
          ),
        ],
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String feature;

  FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.check_circle),
      title: Text(feature),
    );
  }
}
