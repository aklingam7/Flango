//import 'dart:html';

import 'package:flango/main.dart';
import 'package:flango/services/auth.dart';
import 'package:flango/services/colors.dart';
import 'package:flango/services/flashcards.dart';
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
    //GlobalKey<FormState> key,
    Function setState,
    String appBarTitle,
    String mode,
    bool tickShouldPop,
    List<String> setNames, {
    String eName,
    String eEmoji,
    int eBgColor,
    List<String> eFlashcards,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _EditPage(
            //fKey: key,
            userCollection: userCollection,
            appBarTitle: appBarTitle,
            mode: mode,
            tickShouldPop: tickShouldPop,
            setNames: setNames,
            eName: eName,
            eEmoji: eEmoji,
            eBgColor: eBgColor,
            eFlashcards: eFlashcards,
          );
        },
      ),
    );
  }

  Future initializeCollection(String lang) async {
    return await userCollection.doc('userCollectionInitialDocument').set({
      'test': 'test',
      'tFcrds': 0,
      'tFcrdSts': 0,
      'pSsns': 0,
      'tSsns': 0,
      'lang': lang,
    });
  }

  Future<String> getLang() async {
    //return "es";
    Map toReturn =
        (await userCollection.doc('userCollectionInitialDocument').get())
            .data();
    return toReturn == null ? "" : toReturn['lang'];
  }

  /*Future updateUserData(c, s) async {
    await userCollection
        .doc('userCollectionInitialDocument')
        .set({'tFcrds': c, 'tFcrdSts': s});
  }*/

  Future deleteSet(String flashcardsSet) async {
    return await userCollection.doc(flashcardsSet).delete();
  }

  Stream<QuerySnapshot> officialSetsChangesStream() {
    return adminCollection.snapshots();
  }

  Stream<QuerySnapshot> userSetsChangesStream() {
    return userCollection.snapshots();
  }

  /*Stream<DocumentSnapshot> userDataChangesStream() {
    return userCollection.doc('userCollectionInitialDocument').snapshots();
  }*/
}

class _EditPage extends StatefulWidget {
  //final GlobalKey<FormState> fKey;
  final Key key;
  final String appBarTitle;
  final String mode;
  final bool tickShouldPop;
  final List<String> setNames;
  final String eName;
  final String eEmoji;
  final int eBgColor;
  final List<String> eFlashcards;
  final CollectionReference userCollection;

  _EditPage({
    //this.fKey,
    this.key,
    this.appBarTitle,
    this.mode,
    this.tickShouldPop,
    this.setNames,
    this.eName,
    this.eEmoji,
    this.eBgColor,
    this.eFlashcards,
    this.userCollection,
  }) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState(
        //fKey,
        userCollection,
        appBarTitle,
        mode,
        setNames,
        tickShouldPop,
        eName: eName,
        eEmoji: eEmoji,
        eBgColor: eBgColor,
        eFlashcards: eFlashcards,
      );
}

class _EditPageState extends State<_EditPage> {
  String name;
  String initialName;
  String emoji;
  int bgColor;
  MaterialColor bgColorClr;
  double bgColorStr;
  List<String> flashcards;
  GlobalKey<FormState> frmKey;
  CollectionReference userCollection;
  String appBarTitle;
  String mode;
  bool tickShouldPop;
  List<String> setNames;

  String _state;

  _EditPageState(
    //GlobalKey<FormState> key,
    CollectionReference userCollection,
    String appBarTitle,
    String mode,
    List<String> setNames,
    bool tickShouldPop, {
    String eName,
    String eEmoji,
    int eBgColor,
    List<String> eFlashcards,
  }) {
    name = eName ?? "";
    initialName = eName ?? "";
    emoji = eEmoji ?? '🗃️';
    bgColor = eBgColor ?? 0xFF6D4C41;

    bgColorClr = ColorsService().intToColorData(bgColor)['color'];

    bgColorStr = ColorsService().intToColorData(bgColor)['str'];

    flashcards = eFlashcards ?? [];
    this.frmKey = GlobalKey<FormState>();
    this.userCollection = userCollection;
    this.appBarTitle = appBarTitle ?? " ";
    this.mode = mode ?? "view";
    this._state = (mode == "view" || mode == "open") ? 'v' : 'e';
    this.tickShouldPop = tickShouldPop;
    this.setNames = setNames;
  }

  void changeEmoji(String e) {
    setState(
      () {
        emoji = e;
      },
    );
  }

  FloatingActionButton start(String nm, Null Function(Scaffold) psdCtx) {
    //print(flashcards == null ? true : flashcards.isEmpty);
    //print("objectdfsgserg");
    return FloatingActionButton(
      backgroundColor: (flashcards == null ? true : flashcards.isEmpty)
          ? Colors.blueGrey
          : null,
      heroTag: AuthService().heroTagGenerator(),
      onPressed: (flashcards == null ? true : flashcards.isEmpty)
          ? null
          : () async {
              var x = await showDialog<int>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return FlashcardsService().startDialog({
                    'name': name,
                    'flashcards': flashcards,
                    'context': psdCtx
                  });
                },
              );
              if (x == 1 || x == 2 || x == 3) {
                print(x);
                Navigator.push(context, MaterialPageRoute(builder: (cbv) {
                  return CardPage(x, {
                    'name': name,
                    'flashcards': flashcards,
                    'uc': userCollection,
                  });
                }));
              }
            },
      child: Icon(Icons.play_arrow),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: frmKey,
      child: Scaffold(
        appBar: AppBar(
          title: (mode == "edit")
              ? Text("Create New Set: ")
              : (_state == "e")
                  ? Text("Edit: ")
                  : Text(name),
        ),
        floatingActionButton: (mode == "view")
            ? start(
                name,
                (Scaffold x) {
                  print("sdfjsjkjgasduigvjarfhasjdjdrgndguigvl");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (xctx) {
                        return x;
                      },
                    ),
                  );
                },
              )
            : (mode == "edit")
                ? FloatingActionButton(
                    heroTag: AuthService().heroTagGenerator(),
                    onPressed: () async {
                      if (frmKey.currentState.validate()) {
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
                        if (mode == "edit") {
                          Navigator.of(context).pop();
                        } else {
                          _state = "v";
                        }
                      }
                    },
                    child: Icon(Icons.check),
                  )
                : (mode == "open")
                    ? (_state == "e")
                        ? FloatingActionButton(
                            heroTag: AuthService().heroTagGenerator(),
                            onPressed: () async {
                              if (frmKey.currentState.validate()) {
                                await userCollection.doc(name).set(
                                  {
                                    'emoji': emoji,
                                    'bgColor': bgColor,
                                    'flashcards': flashcards,
                                  },
                                );
                                if (initialName != "" && initialName != name) {
                                  await userCollection
                                      .doc(initialName)
                                      .delete();
                                }
                                if (mode == "edit") {
                                  Navigator.of(context).pop();
                                } else {
                                  setState(() {
                                    _state = "v";
                                    initialName = name;
                                  });
                                }
                              }
                            },
                            child: Icon(Icons.check),
                          )
                        : Container(
                            //heroTag: AuthService().heroTagGenerator(),
                            //onPressed: () {},
                            color: Colors.transparent,
                            //color: Colors.transparent,
                            child: SizedBox(
                              height: 60,
                              width: 190,
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    start(name, (Scaffold x) {
                                      print(
                                          "sdfjsjkjgasduigvjarfhasjdjdrgndguigvl");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (xctx) {
                                            return x;
                                          },
                                        ),
                                      );
                                      print(
                                          "sdfjsjkjgasduigvjarfhasjdjdrgndguigvl");
                                    }),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    FloatingActionButton(
                                      heroTag: AuthService().heroTagGenerator(),
                                      onPressed: () {
                                        setState(() {
                                          _state = "e";
                                        });
                                      },
                                      child: Icon(Icons.edit),
                                    ),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    FloatingActionButton(
                                      heroTag: AuthService().heroTagGenerator(),
                                      onPressed: () async {
                                        print("object");
                                        await showDialog(
                                            context: context,
                                            builder: (tcontext) => AlertDialog(
                                                    title:
                                                        Text('Confirmation: '),
                                                    content: Text(
                                                        'Are you sure you want to delete this set?'),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          onPressed: () {
                                                            userCollection
                                                                .doc(name)
                                                                .delete();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    tcontext)
                                                                .pop();
                                                          },
                                                          child: Text("Yes")),
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    tcontext)
                                                                .pop();
                                                          },
                                                          child: Text("No"))
                                                    ]));
                                      },
                                      child: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                    : FloatingActionButton(
                        heroTag: AuthService().heroTagGenerator(),
                        onPressed: null,
                        backgroundColor: Colors.black45,
                      ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: LayoutBuilder(builder: (
              context,
              constraints,
            ) {
              print("fegsfsdghrsehesthesrghregrwgsrgsdgsdfsf");
              print(constraints.maxHeight);
              print(constraints.maxWidth);
              print(_state);
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: (flashcards.length == 0 && _state != 'e')
                    ? Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text(
                            "Tap on the edit icon to add flashcards to this set.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28),
                          ),
                        ),
                      )
                    : ListView(
                        children: (_state == 'e')
                            ? [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    bottom: 12.0,
                                  ),
                                  child: TextFormField(
                                    initialValue: initialName,
                                    obscureText: false,
                                    validator: (val) => val.length < 3
                                        ? 'Set names must be longer than 3 charecters'
                                        : val.length <= 10
                                            ? (setNames.contains(val)
                                                    ? name != initialName
                                                    : false)
                                                ? "You already have a set called $val"
                                                : null
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
                                        heroTag:
                                            AuthService().heroTagGenerator(),
                                        backgroundColor: color1[300],
                                        child: Text(
                                          emoji,
                                          style: TextStyle(fontSize: 24),
                                        ),
                                        onPressed: () async {
                                          await EmojiSelector(
                                            context: context,
                                          ).openSelector(changeEmoji);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    bottom: 8.0,
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
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    bottom: 12,
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        bottom: 12,
                                      ),
                                      child: Column(
                                        children: [
                                          Card(
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Builder(
                                                builder: (context) {
                                                  return SizedBox(
                                                    width: 200,
                                                    height: 70,
                                                    child: Center(
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 4,
                                                          right: 4,
                                                        ),
                                                        children:
                                                            ColorsService()
                                                                .colorsList(
                                                          bgColorClr,
                                                          bgColorStr,
                                                          (int i) {
                                                            setState(
                                                              () {
                                                                bgColor = ColorsService()
                                                                    .colors[i][
                                                                        'color']
                                                                        [
                                                                        bgColorStr
                                                                            .toInt()]
                                                                    .value;

                                                                bgColorClr =
                                                                    ColorsService()
                                                                        .intToColorData(
                                                                  bgColor,
                                                                )['color'];

                                                                bgColorStr =
                                                                    ColorsService()
                                                                        .intToColorData(
                                                                  bgColor,
                                                                )['str'];
                                                              },
                                                            );
                                                            //Navigator.pop(
                                                            //context);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Slider(
                                            value: bgColorStr,
                                            activeColor: Color(bgColor),
                                            inactiveColor: bgColorClr[900],
                                            min: 100,
                                            max: 900,
                                            divisions: 8,
                                            label:
                                                bgColorStr.round().toString(),
                                            onChanged: (double value) {
                                              setState(() {
                                                bgColor =
                                                    bgColorClr[value.toInt()]
                                                        .value;
                                                bgColorStr = value;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    bottom: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Flashcards: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      FloatingActionButton(
                                        heroTag:
                                            AuthService().heroTagGenerator(),
                                        child: Icon(Icons.add),
                                        backgroundColor: color1[300],
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AddDialog(
                                                flashCL: flashcards,
                                                updateCards: (String v) {
                                                  setState(() {
                                                    print(flashcards);
                                                    flashcards.add(v);
                                                    print(flashcards);
                                                  });
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth,
                                  height: (constraints.maxHeight - 395 > 70)
                                      ? constraints.maxHeight - 395
                                      : 75,
                                  child: Container(
                                    //color: Colors.amber,
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        //bottom: 2.0,
                                        //bottom: 8.0,
                                      ),
                                      child: Builder(builder: (context) {
                                        return Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Card(
                                            child: (flashcards != null
                                                    ? flashcards.isNotEmpty
                                                    : false)
                                                ? ReorderableListView(
                                                    children: flashcards
                                                        .map(
                                                          (e) => Padding(
                                                            key: ValueKey(e),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Card(
                                                              color: color1[50],
                                                              child: ListTile(
                                                                leading: Icon(
                                                                    Icons.menu),
                                                                title: Text(
                                                                  e,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                trailing:
                                                                    IconButton(
                                                                        icon: Icon(Icons
                                                                            .delete),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                            () {
                                                                              flashcards.removeAt(
                                                                                flashcards.indexOf(e),
                                                                              );
                                                                            },
                                                                          );
                                                                        }),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                    onReorder: (
                                                      oldIndex,
                                                      newIndex,
                                                    ) {
                                                      setState(() {
                                                        print(
                                                            flashcards.length);
                                                        print(newIndex);
                                                        print(oldIndex);
                                                        if (newIndex ==
                                                            flashcards.length) {
                                                          flashcards.add(
                                                            flashcards.removeAt(
                                                                oldIndex),
                                                          );
                                                        } else {
                                                          flashcards.insert(
                                                            newIndex,
                                                            flashcards.removeAt(
                                                                oldIndex),
                                                          );
                                                        }
                                                      });
                                                    },
                                                  )
                                                : Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                        "Press the + buttton to add flashcards to your set",
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                )
                                /*
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                        bottom: 2.0,
                        //bottom: 8.0,
                      ),
                      child: Builder(builder: (context) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Card(
                            child: ReorderableListView(
                              children: flashcards
                                  .map(
                                    (e) => Card(
                                      key: ValueKey(e),
                                      child: ListTile(
                                        leading: Icon(Icons.menu),
                                        title: Text(e),
                                        trailing: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              setState(
                                                () {
                                                  flashcards.removeAt(
                                                    flashcards.indexOf(e),
                                                  );
                                                },
                                              );
                                            }),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onReorder: (
                                oldIndex,
                                newIndex,
                              ) {
                                setState(() {
                                  flashcards.insert(
                                    newIndex,
                                    flashcards.removeAt(oldIndex),
                                  );
                                });
                              },
                            ),
                          ),
                        );
                      }),
                    ),*/
                              ]
                            : flashcards
                                .map(
                                  (e) => Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Card(
                                      color: color1[50],
                                      child: ListTile(
                                        title: Text(
                                          e,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class AddDialog extends StatefulWidget {
  final Null Function(String) updateCards;
  final List<String> flashCL;

  AddDialog({Key key, this.updateCards, this.flashCL}) : super(key: key);

  @override
  _AddDialogState createState() =>
      _AddDialogState(updateCards: updateCards, flashCL: flashCL);
}

class _AddDialogState extends State<AddDialog> {
  final _addFormKey = GlobalKey<FormState>();
  var cardName = "";
  final Null Function(String) updateCards;
  final List<String> flashCL;

  _AddDialogState({this.updateCards, this.flashCL});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addFormKey,
      child: AlertDialog(
        title: Text(
          "Add Flashcard",
        ),
        content: TextFormField(
          validator: (val) => val.isEmpty
              ? 'This field can\'t be empty'
              : ((flashCL != null) ? flashCL.contains(val) : false)
                  ? "This Card is already in the set"
                  : (val.length >= 16)
                      ? "Flashcards can't be more than 16 charecters long"
                      : (val.contains(" "))
                          ? "Flashcards can't be longer than one word or contain spaces"
                          : null,
          onChanged: (val) {
            setState(() => cardName = val);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.card_membership),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            //labelText: '',
          ),
        ),
        actions: [
          FlatButton(
            child: Text("Add"),
            onPressed: () {
              if (_addFormKey.currentState.validate()) {
                print(flashCL);
                updateCards(cardName);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
