import 'package:flango/services/colors.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flango/services/emoji.dart';

//import 'package:flango/main.dart';

/*class AdminDatabaseService {
  final CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('adminCollection');
}*/

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

  Future updateSet(
    BuildContext context,
    GlobalKey<FormState> key,
    Function setState, {
    String eName,
    String eEmoji,
    int eBgColor,
    List<String> eFlashcards,
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return _EditModalContents(
          fKey: key,
          userCollection: userCollection,
          eName: eName,
          eEmoji: eEmoji,
          eBgColor: eBgColor,
          eFlashcards: eFlashcards,
        );
      },
    );
  }

  Future initializeCollection() async {
    return await userCollection
        .doc('userCollectionInitialDocument')
        .set({'test': 'test'});
  }

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

class _EditModalContents extends StatefulWidget {
  final GlobalKey<FormState> fKey;
  final Key key;
  final String eName;
  final String eEmoji;
  final int eBgColor;
  final List<String> eFlashcards;
  final CollectionReference userCollection;

  _EditModalContents(
      {this.fKey,
      this.key,
      this.eName,
      this.eEmoji,
      this.eBgColor,
      this.eFlashcards,
      this.userCollection})
      : super(key: key);

  @override
  _EditModalContentsState createState() => _EditModalContentsState(
        fKey,
        userCollection,
        eName: eName,
        eEmoji: eEmoji,
        eBgColor: eBgColor,
        eFlashcards: eFlashcards,
      );
}

class _EditModalContentsState extends State<_EditModalContents> {
  String name;
  String initialName;
  String emoji;
  int bgColor;
  Color bgColorClr;
  int bgColorStr;
  List<String> flashcards;
  GlobalKey<FormState> key;
  CollectionReference userCollection;

  _EditModalContentsState(
    GlobalKey<FormState> key,
    CollectionReference userCollection, {
    String eName,
    String eEmoji,
    int eBgColor,
    List<String> eFlashcards,
  }) {
    name = eName ?? "";
    initialName = eName ?? "";
    emoji = eEmoji ?? '🗃️';
    bgColor = eBgColor ?? 0xFF6D4C41;
    print("fdgdfhd${bgColor}");
    bgColorClr = ColorsService().intToColorData(bgColor)['color'];
    print("bgColorClr");
    print(bgColorClr);
    bgColorStr = ColorsService().intToColorData(bgColor)['str'];
    print(bgColorStr);
    flashcards = eFlashcards ?? [];
    this.key = key;
    this.userCollection = userCollection;
  }

  void changeEmoji(String e) {
    setState(
      () {
        emoji = e;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 2 / 5,
            padding: EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 20.0,
            ),
            child: Center(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12.0,
                    ),
                    child: TextFormField(
                      obscureText: false,
                      validator: (val) => val.length < 3
                          ? 'Set names must be longer than 3 charecters'
                          : val.length <= 10
                              ? null
                              : 'Set names must be less than 11 charecters',
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      bottom: 12.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Emoji: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        FloatingActionButton(
                          child: Text(
                            emoji,
                            style: TextStyle(fontSize: 24),
                          ),
                          onPressed: () async {
                            await EmojiSelector(
                              context: context,
                            ).openSelector(changeEmoji);
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      bottom: 12.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Color: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        FloatingActionButton(
                          backgroundColor: bgColorClr,
                          child: Icon(Icons.cancel),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Set Color: "),
                                  content: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    height: MediaQuery.of(context).size.height *
                                        0.23,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        bottom: 7,
                                      ),
                                      child: //Column(
                                          //children: [
                                          Container(
                                        width: double.infinity,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(
                                            left: 4,
                                            right: 4,
                                          ),
                                          children: ColorsService().colorsList(
                                            bgColorClr,
                                            bgColorStr,
                                            (int i) {
                                              setState(
                                                () {
                                                  print(i);
                                                  bgColor = ColorsService()
                                                      .colors[i]['color']
                                                      .value;
                                                  print(bgColor);
                                                  bgColorClr = ColorsService()
                                                      .intToColorData(
                                                          bgColor)['color'];
                                                  print(bgColorClr);
                                                  bgColorStr = ColorsService()
                                                      .intToColorData(
                                                          bgColor)['str'];
                                                  print(bgColorStr);
                                                },
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ),
                                      //],
                                      //),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(
                right: 15,
                bottom: 15,
              ),
              child: FloatingActionButton(
                onPressed: () async {
                  await userCollection.doc(name).set(
                    {
                      'emoji': emoji,
                      'bgColor': bgColor,
                      'flashcards': flashcards,
                    },
                  );
                  if (initialName != "" && initialName != name) {
                    await userCollection.doc(initialName).delete();
                  }
                },
                child: Icon(Icons.check),
              ),
            ),
          )
        ],
      ),
    );
  }
}
