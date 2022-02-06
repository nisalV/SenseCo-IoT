import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      'name' : name,
      'email' : email,
    });
  }

  // get data stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Future updateName(String name) async {
    return await userCollection.doc(uid).update({
      'name' : name,
    });
  }

  Future updateLink(String description, String link) async {
    Map<String,Object> linkData = {'sheets.$description' : link};
    return await userCollection.doc(uid).update(linkData);
  }
}