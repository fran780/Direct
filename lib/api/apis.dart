import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:direct/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  //para autenticarse
  static FirebaseAuth auth = FirebaseAuth.instance;

  //para tener acceso a la base de datos de firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Para devolver el usuario actual
  static User get user => auth.currentUser!;

  //Verificar si el usuario existe o no
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //crear un nuevo usuario
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using Direct",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
}
