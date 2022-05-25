import 'package:beecheal/models/entry.dart';
import 'package:beecheal/models/occasion.dart';
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

  Future updateUserEntry(String? id, String? title, DateTime? dateTime,
      String? description, String? body) async {
    // create new entry
    if (id == '') {
      return await userCollection
          .doc(_auth.curruid())
          .collection('entries')
          .doc()
          .set({
        'title': title,
        'dateTime': dateTime,
        'description': description,
        'body': body,
      });
      // update existing entry
    } else {
      return await userCollection
          .doc(_auth.curruid())
          .collection('entries')
          .doc(id)
          .set({
        'title': title,
        'dateTime': dateTime,
        'description': description,
        'body': body,
      });
    }
  }

  void deleteUserEntry(String? id, String? title, String? dateTime) async {
    userCollection.doc(_auth.curruid()).collection('entries').doc(id).delete();
    print('Deleted entry ${title.toString()} made on ${dateTime.toString()}');
  }

  Future updateUserOccasion(String? id, String? title, DateTime? dateTime,
      String? description) async {
    return await userCollection
        .doc(_auth.curruid())
        .collection('occasions')
        .doc(id)
        .set({
      'title': title,
      'dateTime': dateTime,
      'description': description,
    });
  }

// get occasions stream
  Stream<List<Occasion>> get occasion {
    return userCollection
        .doc(_auth.curruid())
        .collection('occasion')
        .snapshots()
        .map(_OccasionListFromSnapshot);
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
      .map((document) => Entry(
          document.id,
          document['title'],
          document['dateTime'].toDate(),
          document['description'],
          document['body']))
      .toList();
}

//occasion list from snapshot
List<Occasion> _OccasionListFromSnapshot(QuerySnapshot snap) {
  return snap.docs
      .map((document) => Occasion(document.id, document['title'],
          document['dateTime'].toDate(), document['description']))
      .toList();
}
