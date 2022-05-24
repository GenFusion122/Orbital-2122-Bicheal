import 'package:beecheal/models/entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  Future updateUserEntry(String? title, String? dateTime, String? description,
      String? body) async {
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

  void deleteUserEntry(String? title, String? dateTime) async {
    userCollection
        .doc(uid)
        .collection('entries')
        .doc(dateTime.toString())
        .delete();
    print('Deleted entry ${title.toString()} made on ${dateTime.toString()}');
  }

// get entries stream
  Stream<List<Entry>> get entries {
    return userCollection
        .doc(uid)
        .collection('entries')
        .snapshots()
        .map(_EntryListFromSnapshot);
  }
}

//journal entry list from snapshot
List<Entry> _EntryListFromSnapshot(QuerySnapshot snap) {
  return snap.docs
      .map((document) => Entry(
          document['title'],
          DateFormat('dd-MM-yyyy HH:mm').parse(document['dateTime']),
          document['description'],
          document['body']))
      .toList();
}
