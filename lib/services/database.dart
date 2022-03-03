import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {

  final String uid;
  String nameState = "";
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      'name' : name,
      'email' : email,
    });
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

  getUserId(){
    return uid;
  }

  Future doesDataUrlExist(String description, String link) async {
    await userCollection.doc(uid).get().then((snapshot) {
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    if(map.containsKey('sheets')){
      Map<String, dynamic> sheets = map['sheets'];
      if (sheets.containsKey(description)) {
        nameState = "description";
      }
      if (sheets.containsKey(link)) {
        nameState = "sheet";
      }
    } else {
      nameState = "proceed";
    }
    });
    return nameState;
  }

}