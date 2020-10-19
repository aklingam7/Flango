import 'package:flutter/material.dart'
    show
        Color,
        Colors,
        EdgeInsets,
        FloatingActionButton,
        Icon,
        Icons,
        MaterialColor,
        Padding,
        Widget;

class ColorsService {
  List<Map> colors = [
    {
      'color': Colors.amber,
      'amber100': 0xFFFFECB3,
      'amber200': 0xFFFFE082,
      'amber300': 0xFFFFD54F,
      'amber400': 0xFFFFCA28,
      'amber500': 0xFFFFC107,
      'amber600': 0xFFFFB300,
      'amber700': 0xFFFFA000,
      'amber800': 0xFFFF8F00,
      'amber900': 0xFFFF6F00
    },
    {
      'color': Colors.blue,
      'blue100': 0xFFBBDEFB,
      'blue200': 0xFF90CAF9,
      'blue300': 0xFF64B5F6,
      'blue400': 0xFF42A5F5,
      'blue500': 0xFF2196F3,
      'blue600': 0xFF1E88E5,
      'blue700': 0xFF1976D2,
      'blue800': 0xFF1565C0,
      'blue900': 0xFF0D47A1
    },
    {
      'color': Colors.blueGrey,
      'blueGrey100': 0xFFCFD8DC,
      'blueGrey200': 0xFFB0BEC5,
      'blueGrey300': 0xFF90A4AE,
      'blueGrey400': 0xFF78909C,
      'blueGrey500': 0xFF607D8B,
      'blueGrey600': 0xFF546E7A,
      'blueGrey700': 0xFF455A64,
      'blueGrey800': 0xFF37474F,
      'blueGrey900': 0xFF263238
    },
    {
      'color': Colors.brown,
      'brown100': 0xFFD7CCC8,
      'brown200': 0xFFBCAAA4,
      'brown300': 0xFFA1887F,
      'brown400': 0xFF8D6E63,
      'brown500': 0xFF795548,
      'brown600': 0xFF6D4C41,
      'brown700': 0xFF5D4037,
      'brown800': 0xFF4E342E,
      'brown900': 0xFF3E2723
    },
    {
      'color': Colors.cyan,
      'cyan100': 0xFFB2EBF2,
      'cyan200': 0xFF80DEEA,
      'cyan300': 0xFF4DD0E1,
      'cyan400': 0xFF26C6DA,
      'cyan500': 0xFF00BCD4,
      'cyan600': 0xFF00ACC1,
      'cyan700': 0xFF0097A7,
      'cyan800': 0xFF00838F,
      'cyan900': 0xFF006064
    },
    {
      'color': Colors.deepOrange,
      'deepOrange100': 0xFFFFCCBC,
      'deepOrange200': 0xFFFFAB91,
      'deepOrange300': 0xFFFF8A65,
      'deepOrange400': 0xFFFF7043,
      'deepOrange500': 0xFFFF5722,
      'deepOrange600': 0xFFF4511E,
      'deepOrange700': 0xFFE64A19,
      'deepOrange800': 0xFFD84315,
      'deepOrange900': 0xFFBF360C
    },
    {
      'color': Colors.deepPurple,
      'deepPurple100': 0xFFD1C4E9,
      'deepPurple200': 0xFFB39DDB,
      'deepPurple300': 0xFF9575CD,
      'deepPurple400': 0xFF7E57C2,
      'deepPurple500': 0xFF673AB7,
      'deepPurple600': 0xFF5E35B1,
      'deepPurple700': 0xFF512DA8,
      'deepPurple800': 0xFF4527A0,
      'deepPurple900': 0xFF311B92
    },
    {
      'color': Colors.green,
      'green100': 0xFFC8E6C9,
      'green200': 0xFFA5D6A7,
      'green300': 0xFF81C784,
      'green400': 0xFF66BB6A,
      'green500': 0xFF4CAF50,
      'green600': 0xFF43A047,
      'green700': 0xFF388E3C,
      'green800': 0xFF2E7D32,
      'green900': 0xFF1B5E20
    },
    {
      'color': Colors.indigo,
      'indigo100': 0xFFC5CAE9,
      'indigo200': 0xFF9FA8DA,
      'indigo300': 0xFF7986CB,
      'indigo400': 0xFF5C6BC0,
      'indigo500': 0xFF3F51B5,
      'indigo600': 0xFF3949AB,
      'indigo700': 0xFF303F9F,
      'indigo800': 0xFF283593,
      'indigo900': 0xFF1A237E
    },
    {
      'color': Colors.lightBlue,
      'lightBlue100': 0xFFB3E5FC,
      'lightBlue200': 0xFF81D4FA,
      'lightBlue300': 0xFF4FC3F7,
      'lightBlue400': 0xFF29B6F6,
      'lightBlue500': 0xFF03A9F4,
      'lightBlue600': 0xFF039BE5,
      'lightBlue700': 0xFF0288D1,
      'lightBlue800': 0xFF0277BD,
      'lightBlue900': 0xFF01579B
    },
    {
      'color': Colors.lightGreen,
      'lightGreen100': 0xFFDCEDC8,
      'lightGreen200': 0xFFC5E1A5,
      'lightGreen300': 0xFFAED581,
      'lightGreen400': 0xFF9CCC65,
      'lightGreen500': 0xFF8BC34A,
      'lightGreen600': 0xFF7CB342,
      'lightGreen700': 0xFF689F38,
      'lightGreen800': 0xFF558B2F,
      'lightGreen900': 0xFF33691E
    },
    {
      'color': Colors.lime,
      'lime100': 0xFFF0F4C3,
      'lime200': 0xFFE6EE9C,
      'lime300': 0xFFDCE775,
      'lime400': 0xFFD4E157,
      'lime500': 0xFFCDDC39,
      'lime600': 0xFFC0CA33,
      'lime700': 0xFFAFB42B,
      'lime800': 0xFF9E9D24,
      'lime900': 0xFF827717
    },
    {
      'color': Colors.orange,
      'orange100': 0xFFFFE0B2,
      'orange200': 0xFFFFCC80,
      'orange300': 0xFFFFB74D,
      'orange400': 0xFFFFA726,
      'orange500': 0xFFFF9800,
      'orange600': 0xFFFB8C00,
      'orange700': 0xFFF57C00,
      'orange800': 0xFFEF6C00,
      'orange900': 0xFFE65100
    },
    {
      'color': Colors.pink,
      'pink100': 0xFFF8BBD0,
      'pink200': 0xFFF48FB1,
      'pink300': 0xFFF06292,
      'pink400': 0xFFEC407A,
      'pink500': 0xFFE91E63,
      'pink600': 0xFFD81B60,
      'pink700': 0xFFC2185B,
      'pink800': 0xFFAD1457,
      'pink900': 0xFF880E4F
    },
    {
      'color': Colors.purple,
      'purple100': 0xFFE1BEE7,
      'purple200': 0xFFCE93D8,
      'purple300': 0xFFBA68C8,
      'purple400': 0xFFAB47BC,
      'purple500': 0xFF9C27B0,
      'purple600': 0xFF8E24AA,
      'purple700': 0xFF7B1FA2,
      'purple800': 0xFF6A1B9A,
      'purple900': 0xFF4A148C
    },
    {
      'color': Colors.red,
      'red100': 0xFFFFCDD2,
      'red200': 0xFFEF9A9A,
      'red300': 0xFFE57373,
      'red400': 0xFFEF5350,
      'red500': 0xFFF44336,
      'red600': 0xFFE53935,
      'red700': 0xFFD32F2F,
      'red800': 0xFFC62828,
      'red900': 0xFFB71C1C
    },
    {
      'color': Colors.teal,
      'teal100': 0xFFB2DFDB,
      'teal200': 0xFF80CBC4,
      'teal300': 0xFF4DB6AC,
      'teal400': 0xFF26A69A,
      'teal500': 0xFF009688,
      'teal600': 0xFF00897B,
      'teal700': 0xFF00796B,
      'teal800': 0xFF00695C,
      'teal900': 0xFF004D40
    },
    {
      'color': Colors.yellow,
      'yellow100': 0xFFFFF9C4,
      'yellow200': 0xFFFFF59D,
      'yellow300': 0xFFFFF176,
      'yellow400': 0xFFFFEE58,
      'yellow500': 0xFFFFEB3B,
      'yellow600': 0xFFFDD835,
      'yellow700': 0xFFFBC02D,
      'yellow800': 0xFFF9A825,
      'yellow900': 0xFFF57F17
    },
  ];

  /*MaterialColor _getColor(String txt) {
    return switch (txt) {
      case 'amber':
        return Colo
        break;
      default:
    };
  }*/

  List<Widget> colorsList(
    //int bgColor,
    MaterialColor bgColorClr,
    int bgColorStr,
    Null Function(int) setState,
  ) {
    List<Widget> toReturn = [];
    for (var i = 0; i < colors.length; i++) {
      MaterialColor tC = ColorsService().colors[i]['color'];
      toReturn.add(
        Padding(
          padding: EdgeInsets.all(4),
          child: (bgColorClr == tC)
              ? FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: tC[bgColorStr],
                  child: Icon(Icons.cancel),
                )
              : FloatingActionButton(
                  backgroundColor: tC[bgColorStr],
                  onPressed: () {
                    print(i);
                    setState(i);
                  },
                ),
        ),
      );
    }
    return toReturn;
  }

  Map intToColorData(int color) {
    print("objectgfhffsh ${color}");
    Map toReturn;
    for (var inColor in colors) {
      print(inColor);
      print("ergregherhset ${inColor.keys}");
      for (var key in inColor.keys) {
        print(
            "object ${inColor[key]} uiui $key gr ${key == 'color'} nn ${inColor[key] == color}");
        if (inColor[key] == color && key != 'color') {
          toReturn = {
            'color': inColor['color'],
            'str': int.parse(key.substring(key.length - 3)),
          };
        }
      }
    }

    return toReturn ??
        {
          'color': Colors.amber,
          'str': 600,
        };
  }
}
