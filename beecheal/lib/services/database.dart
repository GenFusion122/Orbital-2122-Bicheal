import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // creating documents
  Future updateUserID(String uid) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
    });
  }

  Future updateUserEntry(
      String title, int dateTime, String description, String body) async {
    return await userCollection
        .doc(uid)
        .collection('entries')
        .doc(dateTime.toString())
        .set({
      'title': title,
      'dateTime': dateTime,
      'description': description,
      'body': body,
    });
  }

  // get users stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }
}
