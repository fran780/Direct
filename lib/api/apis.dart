import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs{
  //para autenticarse
  static FirebaseAuth auth = FirebaseAuth.instance;

  //para tener acceso a la base de datos de firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
}