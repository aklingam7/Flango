import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:flango/main.dart';

class AdminDatabaseService {
  final CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('adminCollection');
}

class DatabaseService {
  //String _uid;
  CollectionReference userCollection;
  CollectionReference adminCollection;

  DatabaseService(String uid) {
    //this._uid = uid;
    this.adminCollection =
        FirebaseFirestore.instance.collection('adminCollection');
    this.userCollection = FirebaseFirestore.instance.collection(uid);
  }

  /*List<Map> _flashcardSetListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return {
        'name': doc.id,
        'emoji': doc.data()['emoji'],
        'bgColor': doc.data()['bgColor'],
        'flashcards': doc.data()['flashcards'],
      };
    })
        /*.where(
      (doc) {
        FlashcardSet a = doc;
        print(a.emoji);
        print(a.emoji != null);
        print(a.bgColor != null);
        return (a.emoji != null) && (a.bgColor != null);
      },
    )*/
        .toList();
  }*/

  /*List<FlashcardSet> _flashcardSetListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        print(doc.data);
        print("ffhg");
        print(
          doc.id,
        );
        String cName = doc.id;
        print(
          doc.data()['emoji'],
        );
        String cEmoji = doc.data()['bgColor'];
        print(
          doc.data()['bgColor'],
        );
        int cBgColor = doc.data()['bgColor'];
        print(
          doc.data()['flashcards'],
        );
        print(
          doc.data()['flashcards'] ?? [],
        );
        //return 2;
        print(
          doc.data()['emoji'],
        );
        print(cEmoji);
        print("doc.data()['bgColor'],");
        print(FlashcardSet(
          cName,
          cEmoji,
          cBgColor,
          [],
        ).emoji);
        print("doc.data()['bgColor'],");
        print("objectggfdd");
        return FlashcardSet(
          doc.id,
          doc.data()['emoji'],
          doc.data()['bgColor'],
          doc.data()['flashcards'] ?? [],
        );
      },
    ).where(
      (doc) {
        FlashcardSet a = doc;
        print(a.emoji);
        print(a.emoji != null);
        print(a.bgColor != null);
        return (a.emoji != null) && (a.bgColor != null);
      },
    ).toList();
  }*/

  /*List<FlashcardSet> _flashcardSetListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.where(
      (doc) {
        print(doc.data()['emoji']);
        print(doc.data()['emoji'] != null);
        print(doc.data()['bgColor'] != null);
        return (doc.data()['emoji'] != null) && (doc.data()['bgColor'] != null);
      },
    ).map(
      (doc) {
        print(doc.data);
        print("ffhg");
        print(
          doc.id,
        );
        print(
          doc.data()['emoji'],
        );
        print(
          doc.data()['bgColor'],
        );
        print(
          doc.data()['flashcards'],
        );
        print(
          doc.data()['flashcards'] ?? [],
        );
        return 2;
        print(FlashcardSet(
          doc.id,
          doc.data()['emoji'],
          doc.data()['bgColor'],
          doc.data()['flashcards'] ?? [],
        ).bgColor);
        print("objectggfdd");
        return FlashcardSet(
          doc.id,
          doc.data()['emoji'],
          doc.data()['bgColor'],
          doc.data()['flashcards'] ?? [],
        );
      },
    ).toList();
  }*/

  /*Map _flashcardSetFromSnapshot(DocumentSnapshot snapshot) {
    return !snapshot.exists
        ? null
        : {
            'name': snapshot.id,
            'emoji': snapshot.data()['emoji'],
            'bgColor': snapshot.data()['bgColor'],
            'flashcards': snapshot.data()['flashcards'],
          };
  }*/

  Future initializeCollection() async {
    return await userCollection
        .doc('userCollectionInitialDocument')
        .set({'test': 'test'});
  }

  Future updateSet(Map flashcardsSet) async {
    return await userCollection.doc(flashcardsSet['name']).set({
      'emoji': flashcardsSet['emoji'],
      'bgColor': flashcardsSet['bgColor'],
      'flashcards': flashcardsSet['flashcards'],
    });
  }

  // check if this is the right method
  Future deleteSet(String flashcardsSet) async {
    return await userCollection.doc(flashcardsSet).delete();
  }

  Stream<QuerySnapshot> officialSetsChangesStream() {
    return adminCollection.snapshots();
  }

  Stream<QuerySnapshot> userSetsChangesStream() {
    return userCollection.snapshots();
  }

  Stream<DocumentSnapshot> selectedSetChangesStream(String name) {
    return userCollection.doc(name).snapshots();
  }
}
