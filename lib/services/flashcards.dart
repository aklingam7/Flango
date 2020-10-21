import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flango/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:translator/translator.dart';

import '../main.dart';

class FlashcardsService {
  Widget startDialog(Map pmMap) => _StartDialog(pmMap: pmMap);
}

class _StartDialog extends StatefulWidget {
  final Map pmMap;
  _StartDialog({Key key, this.pmMap}) : super(key: key);

  @override
  _StartDialogState createState() => _StartDialogState(pmMap);
}

class _StartDialogState extends State<_StartDialog> {
  List<bool> isSelected = [
    true,
    false,
  ];
  Map pmMap;

  _StartDialogState(Map pmMap) {
    this.pmMap = pmMap;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Mode: "),
      content: RotatedBox(
        quarterTurns: 1,
        child: ToggleButtons(
          selectedColor: color1[900].withAlpha(254),
          fillColor: color1[100],
          borderColor: color1[400],
          borderWidth: 2,
          selectedBorderColor: color1[900],
          renderBorder: true,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
          children: <Widget>[
            RotatedBox(
              quarterTurns: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 14,
                      left: 14,
                      right: 14,
                      bottom: 8,
                    ),
                    child: Text(
                      "Practice: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 14,
                      right: 14,
                      bottom: 14,
                    ),
                    child: Text(
                      "Just skim through the cards and their corresponding translation. No pressure!",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 14,
                      left: 14,
                      right: 14,
                      bottom: 8,
                    ),
                    child: Text(
                      "Test: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 14,
                      right: 14,
                      bottom: 14,
                    ),
                    child: Text(
                      "Fill in the translation of each card for a score at the end.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
          isSelected: isSelected,
          onPressed: (int index) {
            setState(
              () {
                for (int indexBtn = 0;
                    indexBtn < isSelected.length;
                    indexBtn++) {
                  if (indexBtn == index) {
                    isSelected[indexBtn] = true;
                  } else {
                    isSelected[indexBtn] = false;
                  }
                }
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Okay"),
          onPressed: () {
            print("pls: $isSelected");
            int cMode = (isSelected[0] == true)
                ? 1
                : (isSelected[1] == true)
                    ? 2
                    : 4;
            print(
                "rehergherserhsdrhsdthdsfshbsdfhgsyhe56hgresghserhesrhgserhs");
            print(pmMap['context']);
            Navigator.of(context).pop((cMode == null) ? 5 : cMode);

            /*Navigator.of(
              pmMap['context'],
            ).push(
              MaterialPageRoute(
                builder: (context) {
                  print(
                      "rehergherserhsdrhsdthdsfshbsdfhgsyhe56hgresghserhesrhgserhss");
                  return _CardPage(cMode, pmMap);
                },
              ),
            );*/
          },
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CardPage extends StatefulWidget {
  int cMode;
  Map pmMap;
  CardPage(int cMode, Map pmMap, {Key key}) : super(key: key) {
    this.cMode = cMode;
    this.pmMap = pmMap;
    assert(cMode == 1 || cMode == 2 || cMode == 3);
    assert(pmMap['name'] != null);
  }

  @override
  _CardPageState createState() => _CardPageState(cMode: cMode, pmMap: pmMap);
}

class _CardPageState extends State<CardPage> {
  final int cMode;
  final Map pmMap;
  final translator = GoogleTranslator();

  Future<List<String>> fBuilder;

  int taps = 0;
  int score;
  bool submitted = false;
  bool over = false;

  _CardPageState({
    this.cMode,
    this.pmMap,
  }) {
    print(pmMap['flashcards']);
    fBuilder = updatePracticeList(pmMap['flashcards']);
  }

  Future<List<String>> updatePracticeList(List<String> ix) async {
    List<String> cardList = [];
    String xy = (await (pmMap['uc'] as CollectionReference)
            .doc('userCollectionInitialDocument')
            .get())
        .data()['lang'];
    print(xy);
    print('fs');
    await () async {
      for (var item in ix) {
        print('fs');
        var trR = await translator.translate(item, from: 'en', to: xy);
        cardList.add(item);
        cardList.add(trR.toString());
      }
    }();
    return cardList;
  }

  /*Future<List<Text Function(double)>> updateMCQList() async {
    //var fCardList = [];
    //var qCardList = [];
    //var a1CardList = [];
    //var a2CardList = [];
    var fList = [];
    for (var item in pmMap['flashcards']) {
      var trR = await translator.translate(item,
          from: 'en',
          to: (await (pmMap['uc'] as CollectionReference)
                  .doc('userCollectionInitialDocument')
                  .get())
              .data()['lang']);
      var isTrue = Random().nextInt(100) < 50;
      Align(
        alignment: Alignment.topCenter,
        child: Column(),
      );
    }
    return [
      ...fList
      //fCardList,
      //qCardList,
      //a1CardList,
      //a2CardList,
    ];
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (cMode == 1 || over == true)
            ? true
            : await showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: Text('Confirmation: '),
                    content: Text(
                        'Are you sure you want to exit. Your progress will be lost.'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("No"),
                      ),
                      //SizedBox(height: 16),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text("Yes"),
                      ),
                    ],
                  ),
                ) ??
                false;
      },
      child: Scaffold(
        appBar: (cMode == 1)
            ? AppBar(
                centerTitle: true,
                title: Text("Practice"),
              )
            : AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                actions: [
                  IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () async {
                        var y = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirmation: '),
                            content: Text(
                                'Are you sure you want to exit. Your progress will be lost.'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("No"),
                              ),
                              //SizedBox(height: 16),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text("Yes"),
                              ),
                            ],
                          ),
                        );
                        if (y) {
                          Navigator.pop(context);
                        }
                      })
                ],
                title: Text("${(cMode == 2) ? "Test" : "Test"}"),
              ),
        body: FutureBuilder<List<String>>(
            //initialData: null,
            future: updatePracticeList(pmMap['flashcards']),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              //print(snapshot.data.length);
              if (snapshot.data != null
                  ? snapshot.data.length == pmMap['flashcards'].length * 2
                  : false) {
                /*if (snapshot.hasError) {
                        return Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              "An error occured. Please kill the app and try again.",
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        );
                      }*/
                //print(cMode);
                return (cMode == 1)
                    ? ListView(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.8),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return SizedBox(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight,
                                    child: Center(
                                      child: DefaultTabController(
                                        length:
                                            (snapshot.data.length / 2).toInt(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Spacer(),
                                            SizedBox(
                                              width: constraints.maxWidth - 70,
                                              height:
                                                  (constraints.maxWidth - 70) *
                                                      0.66,
                                              child: TabBarView(children: [
                                                for (var i = 0;
                                                    i <
                                                        (snapshot.data.length /
                                                                2)
                                                            .toInt();
                                                    i += 1)
                                                  AspectCard(
                                                      snapshot: snapshot, i: i),
                                              ]),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Spacer(),
                                            SizedBox(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .5,
                                              child: Column(
                                                children: [
                                                  TabBar(
                                                    isScrollable: true,
                                                    indicatorPadding:
                                                        EdgeInsets.all(2),
                                                    indicator: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Color(0x19000000),
                                                          blurRadius: 3,
                                                          spreadRadius: 2,
                                                        )
                                                      ],
                                                      border: Border.all(
                                                        color:
                                                            Colors.transparent,
                                                        width: 2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  18)),
                                                      color: color1[300],
                                                    ),
                                                    indicatorColor:
                                                        Colors.transparent,
                                                    indicatorWeight: 2,
                                                    //indicatorColor: Colors.transparent,
                                                    tabs: [
                                                      for (var i = 0;
                                                          i <
                                                              (snapshot.data
                                                                          .length /
                                                                      2)
                                                                  .toInt();
                                                          i += 1)
                                                        Tab(
                                                            child: Container(
                                                                //color: color1[900],
                                                                child: FittedBox(
                                                                    fit: BoxFit.contain,
                                                                    child: Icon(
                                                                      Icons
                                                                          .circle,
                                                                      color: color1[
                                                                          200],
                                                                    )))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      )
                    : AspectFormCard(
                        snapshot: snapshot,
                        setOver: () {
                          setState(() {
                            over = true;
                          });
                        },
                        over: over,
                      );
              } else {
                //TODO: conectivity package mobile data recomendation
                return Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
              }
            }),
        /*floatingActionButton: (cMode == 2)
            ? FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    submitted = true;
                  });
                },
                label: Text("Submit"),
                icon: Icon(Icons.check),
              )
            : null,*/
      ),
    );
  }
}

class AspectCard extends StatefulWidget {
  AspectCard({
    Key key,
    //@required this.taps,
    @required this.i,
    @required this.snapshot,
  }) : super(key: key);

  int taps = 0;
  final int i;
  final AsyncSnapshot<List<String>> snapshot;

  @override
  _AspectCardState createState() => _AspectCardState();
}

class _AspectCardState extends State<AspectCard> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: GestureDetector(
        onTap: () => setState(() {
          if (widget.taps + 1 != 2) {
            widget.taps = widget.taps + 1;
          } else {
            widget.taps = 0;
          }
        }),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              width: 2,
              color: color1[300],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: (widget.taps == 0)
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.snapshot.data[widget.taps + widget.i * 2],
                              style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.135),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Tap to see the translation",
                              style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.065),
                            ),
                          ],
                        )
                      : Text(
                          widget.snapshot.data[widget.taps + widget.i * 2],
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.124,
                            color: color1[600],
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AspectFormCard extends StatefulWidget {
  AspectFormCard({
    Key key,
    //@required this.taps,

    @required this.snapshot,
    @required this.setOver,
    @required this.over,
  }) : super(key: key);

  int taps = 0;

  final AsyncSnapshot<List<String>> snapshot;
  final Function setOver;
  final bool over;

  @override
  _AspectFormCardState createState() => _AspectFormCardState();
}

class _AspectFormCardState extends State<AspectFormCard> {
  List<String> answer = [];
  int score;
  var frmKey = GlobalKey<FormState>();

  /*FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    submitted = true;
                  });
                },
                label: Text("Submit"),
                icon: Icon(Icons.check),
              )*/

  @override
  void initState() {
    super.initState();
    int sdf = 0;
    for (var item in widget.snapshot.data) {
      if (sdf % 2 == 0) {
        answer.add(item);
      }
      sdf = sdf + 1;
    }

    //answer = widget.snapshot.data.where((element) => false).map((e) => " ").toList();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: frmKey,
      child: Stack(
        children: [
          ListView(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Center(
                          child: DefaultTabController(
                            length: (widget.snapshot.data.length / 2).toInt(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  (score == null) ? " " : "Score",
                                  style: TextStyle(fontSize: 40),
                                ),
                                Text(
                                  (score == null) ? " " : "$score",
                                  style: TextStyle(fontSize: 36),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: constraints.maxWidth - 70,
                                  height: (constraints.maxWidth - 70) * 1.3,
                                  child: TabBarView(children: [
                                    for (var i = 0;
                                        i <
                                            (widget.snapshot.data.length / 2)
                                                .toInt();
                                        i += 1)
                                      Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 24 / 29,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                width: 2,
                                                color: color1[300],
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: AspectRatio(
                                                    aspectRatio: 3 / 2,
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          side: BorderSide(
                                                            width: 2,
                                                            color: color1[300],
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              return Center(
                                                                child:
                                                                    (widget.taps ==
                                                                            0)
                                                                        ? Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                widget.snapshot.data[widget.taps + i * 2],
                                                                                style: TextStyle(fontSize: constraints.maxWidth * 0.135),
                                                                              ),
                                                                              /*SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "Tap to see the translation",
                                                style: TextStyle(
                                                    fontSize: constraints.maxWidth * 0.065),
                                              ),*/
                                                                            ],
                                                                          )
                                                                        : Text(
                                                                            widget.snapshot.data[widget.taps +
                                                                                i * 2],
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: constraints.maxWidth * 0.124,
                                                                              color: color1[600],
                                                                            ),
                                                                          ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    validator: (val) => widget
                                                                .snapshot
                                                                .data[
                                                                    (i * 2) + 1]
                                                                .toUpperCase() !=
                                                            val.toUpperCase()
                                                        ? 'Incorrect'
                                                        : null,
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          answer[i] = val);
                                                    },
                                                    decoration: InputDecoration(
                                                      //suffixIcon: Icon(Icons.edit),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      labelText: 'Answer',
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                  ]),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Spacer(),
                                SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Column(
                                    children: [
                                      TabBar(
                                        isScrollable: true,
                                        indicatorPadding: EdgeInsets.all(2),
                                        indicator: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x19000000),
                                              blurRadius: 3,
                                              spreadRadius: 2,
                                            )
                                          ],
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18)),
                                          color: color1[300],
                                        ),
                                        indicatorColor: Colors.transparent,
                                        indicatorWeight: 2,
                                        //indicatorColor: Colors.transparent,
                                        tabs: [
                                          for (var i = 0;
                                              i <
                                                  (widget.snapshot.data.length /
                                                          2)
                                                      .toInt();
                                              i += 1)
                                            Tab(
                                                child: Container(
                                                    //color: color1[900],
                                                    child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Icon(
                                                          Icons.circle,
                                                          color: color1[200],
                                                        )))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton.extended(
                backgroundColor: (widget.over) ? Colors.grey : color1[300],
                onPressed: widget.over
                    ? null
                    : () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Confirmation:"),
                                content:
                                    Text("Are you sure you want to submit?"),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        int xd = 0;
                                        print(answer.length);
                                        score = 0;
                                        for (var iAnswer in answer) {
                                          print(iAnswer.toUpperCase());
                                          print(widget
                                              .snapshot.data[(xd * 2) + 1]
                                              .toUpperCase());
                                          if (iAnswer.toUpperCase() ==
                                              widget.snapshot.data[(xd * 2) + 1]
                                                  .toUpperCase()) {
                                            score = score + 1;
                                          }
                                          xd = xd + 1;
                                        }
                                        widget.setOver();
                                        setState(() {
                                          score = score ?? 0;
                                        });
                                        if (frmKey.currentState.validate()) {}
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Yes")),
                                  FlatButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                        //print(iAnswer.toUpperCase());
                        //print(answer);
                        //print(widget.snapshot.data[(answer.indexOf(iAnswer) * 2) + 1]
                        //.toUpperCase());
                      },
                label: Text("Submit"),
                icon: Icon(Icons.check),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
