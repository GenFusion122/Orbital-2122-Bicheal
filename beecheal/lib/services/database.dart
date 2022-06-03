import 'package:beecheal/models/entry.dart';
import 'package:beecheal/models/occasion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beecheal/services/auth.dart';
import 'package:beecheal/models/task.dart';

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

  Future updateUserTask(String? id, String? title, DateTime? dateTime,
      String? description, DateTime completedOn) async {
    // create new entry
    if (id == '') {
      return await userCollection
          .doc(_auth.curruid())
          .collection('tasks')
          .doc()
          .set({
        'title': title,
        'dateTime': dateTime,
        'description': description,
        'completedOn': completedOn,
      });
      // update existing entry
    } else {
      return await userCollection
          .doc(_auth.curruid())
          .collection('tasks')
          .doc(id)
          .set({
        'title': title,
        'dateTime': dateTime,
        'description': description,
        'completedOn': completedOn,
      });
    }
  }

  void deleteUserTask(String? id, String? title) async {
    userCollection.doc(_auth.curruid()).collection('tasks').doc(id).delete();
    print('Deleted task ${title.toString()}');
  }

  Future updateUserOccasion(String? id, String? title, DateTime? dateTime,
      String? description) async {
    if (id == "") {
      return await userCollection
          .doc(_auth.curruid())
          .collection('occasions')
          .doc()
          .set({
        'title': title,
        'dateTime': dateTime,
        'description': description,
      });
    } else {
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
  }

  void deleteUserOccasion(String? id, String? title) async {
    userCollection
        .doc(_auth.curruid())
        .collection('occasions')
        .doc(id)
        .delete();
    print('Deleted task ${title.toString()}');
  }

// get occasions stream
  Stream<List<Occasion>> get occasion {
    return userCollection
        .doc(_auth.curruid())
        .collection('occasions')
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

  // get tasks stream
  Stream<List<Task>> get tasks {
    return userCollection
        .doc(_auth.curruid())
        .collection('tasks')
        .snapshots()
        .map(_TaskListFromSnapshot);
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

List<Task> _TaskListFromSnapshot(QuerySnapshot snap) {
  return snap.docs
      .map((document) => Task(
          document.id,
          document['title'],
          document['dateTime'].toDate(),
          document['description'],
          document['completedOn'].toDate()))
      .toList();
}
