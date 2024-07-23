import 'package:flutter/material.dart';

class DevelopersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desarrolladores:'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          DeveloperTile(name: 'David Andrés Aguilar Castillo'),
          DeveloperTile(name: 'Francisco Javier Fernández Mejía'),
          DeveloperTile(name: 'Héctor Alejandro Palacios Aguilar'),
          DeveloperTile(name: 'Marcos Andrés Enamorado Gómez'),
          DeveloperTile(name: 'Milton Josué Ponce Lemus'),
        ],
      ),
    );
  }
}

class DeveloperTile extends StatelessWidget {
  final String name;

  DeveloperTile({required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(name),
    );
  }
}