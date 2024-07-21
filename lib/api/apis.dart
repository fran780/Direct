import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:direct/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  //para autenticarse
  static FirebaseAuth auth = FirebaseAuth.instance;

  //para tener acceso a la base de datos de firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //para almacenar informacion personal
  static late ChatUser me;

  //Para devolver el usuario actual
  static User get user => auth.currentUser!;

  //Verificar si el usuario existe o no
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //Para obtner informacion actual del usuario
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        print('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
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

  //para obtener todos los usuarios de la base de datos
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection(('users'))
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

// para actualizar la informacion del usuario
  static Future<void> updateUserInfo() async {
    return await firestore
        .collection('users')
        .doc(user.uid)
        .update({
          'name': me.name,
          'about': me.about,
        });
  }
}
