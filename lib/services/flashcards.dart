import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class FlashcardsService {
  Widget startDialog(BuildContext psdContext) =>
      _StartDialog(psdContext: psdContext);
}

class _StartDialog extends StatefulWidget {
  final BuildContext psdContext;
  _StartDialog({Key key, this.psdContext}) : super(key: key);

  @override
  _StartDialogState createState() => _StartDialogState(psdContext);
}

class _StartDialogState extends State<_StartDialog> {
  List<bool> isSelected = [true, false, false];
  BuildContext psdContext;

  _StartDialogState(BuildContext psdContext) {
    this.psdContext = psdContext;
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
                      "T/F Test: ",
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
                      "Select whether the translation for each card is true or false for a score at the end.",
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
                      "MCQ Test: ",
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
                      "Select correct the translation for each card out of four options for a score at the end.",
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
            int cMode = (isSelected ==
                    [
                      true,
                      false,
                      false,
                    ])
                ? 1
                : (isSelected ==
                        [
                          false,
                          true,
                          false,
                        ])
                    ? 2
                    : (isSelected ==
                            [
                              false,
                              true,
                              false,
                            ])
                        ? 3
                        : 4;
            Navigator.push(
              psdContext,
              MaterialPageRoute(
                builder: (context) {
                  return _CardPage(cMode);
                },
              ),
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class _CardPage extends StatefulWidget {
  int cMode;
  _CardPage(int cMode, {Key key}) : super(key: key) {
    this.cMode = cMode;
    assert(cMode == 1 || cMode == 2 || cMode == 3);
  }

  @override
  _CardPageState createState() => _CardPageState(cMode: cMode);
}

class _CardPageState extends State<_CardPage> {
  final int cMode;

  _CardPageState({this.cMode});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (cMode == 1)
          ? true
          : showDialog(
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
              false,
      child: null,
    );
  }
}
