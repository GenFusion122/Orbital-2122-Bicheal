import 'package:beecheal/models/entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beecheal/services/auth.dart';

class DatabaseService {
  // To get current uid to manage database of current user
  final AuthService _auth = AuthService();

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // creating documents
  Future updateUserID() async {
    return await userCollection.doc(_auth.curruid()).set({
      'uid': _auth.curruid(),
    });
  }

  Future updateUserEntry(String? title, DateTime? dateTime, String? description,
      String? body) async {
    return await userCollection
        .doc(_auth.curruid())
        .collection('entries')
        .doc(dateTime.toString().substring(0, 23))
        .set({
      'title': title,
      'dateTime': dateTime,
      'description': description,
      'body': body,
    });
  }

  void deleteUserEntry(String? title, String? dateTime) async {
    userCollection
        .doc(_auth.curruid())
        .collection('entries')
        .doc(dateTime)
        .delete();
    print('Deleted entry ${title.toString()} made on ${dateTime.toString()}');
  }

// get entries stream
  Stream<List<Entry>> get entries {
    return userCollection
        .doc(_auth.curruid())
        .collection('entries')
        .snapshots()
        .map(_EntryListFromSnapshot);
  }
}

//journal entry list from snapshot
List<Entry> _EntryListFromSnapshot(QuerySnapshot snap) {
  return snap.docs
      .map((document) => Entry(document['title'], document['dateTime'].toDate(),
          document['description'], document['body']))
      .toList();
}
