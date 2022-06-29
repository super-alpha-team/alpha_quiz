import 'package:flutter/material.dart';

class AnswerButtonColors {
  // static const red = <Color>[
  //   Color(0xFFE57373),
  //   Color(0xFFF44336),
  //   Color(0xFFF44336),
  //   Color(0xFFE57373),
  // ];

  // static const orange = <Color>[
  //   Color(0xFFFFB74D),
  //   Color(0xFFFF9800),
  //   Color(0xFFFF9800),
  //   Color(0xFFFFB74D),
  // ];

  // static const lime = <Color>[
  //   Color(0xFFDCE775),
  //   Color(0xFFCDDC39),
  //   Color(0xFFCDDC39),
  //   Color(0xFFDCE775),
  // ];

  // static const green = <Color>[
  //   Color(0xFF81C784),
  //   Color(0xFF4CAF50),
  //   Color(0xFF4CAF50),
  //   Color(0xFF81C784),
  // ];

  // static const blue = <Color>[
  //   Color(0xFF64B5F6),
  //   Color(0xFF2196F3),
  //   Color(0xFF2196F3),
  //   Color(0xFF64B5F6),
  // ];

  // static const teal = <Color>[
  //   Color(0xFF4DB6AC),
  //   Color(0xFF009688),
  //   Color(0xFF009688),
  //   Color(0xFF4DB6AC),
  // ];

  // static const indigo = <Color>[
  //   Color(0xFF7986CB),
  //   Color(0xFF3F51B5),
  //   Color(0xFF3F51B5),
  //   Color(0xFF7986CB),
  // ];

  // static const purple = <Color>[
  //   Color(0xFFBA68C8),
  //   Color(0xFF9C27B0),
  //   Color(0xFF9C27B0),
  //   Color(0xFFBA68C8),
  // ];
  // static const grey = <Color>[
  //   Color(0xFFE0E0E0),
  //   Color(0xFF9E9E9E),
  //   Color(0xFF9E9E9E),
  //   Color(0xFFE0E0E0),
  // ];

  // static const all = [
  //   orange,
  //   purple,
  //   indigo,
  //   blue,
  //   teal,
  //   red,
  //   lime,
  //   green,
  //   grey,
  // ];

  // static List<Color> get(int index) {
  //   return all[index % all.length];
  // }

  // static String toCss(List<Color> colors) {
  //   return 'linear-gradient(90deg, ${rgba(colors[0])} 0%, ${rgba(colors[1])} 10%, ${rgba(colors[2])} 90%, ${rgba(colors[3])} 100%);';
  // }

  static rgba(Color color) {
    return 'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})';
  }

  static const colors = [
    Color(0xff1368CE),
    Color(0xffD89E00),
    Color(0xff26890C),
    Color(0xffE21B3C),
  ];

  static const shadowColors = [
    Color(0xff1059AF),
    Color(0xffB88600),
    Color(0xff20750A),
    Color(0xffC01733),
  ];

  static Color colorAt(int index) {
    final color = colors[index % colors.length];
    return color;
  }

  static Color shadowColorAt(int index) {
    final color = shadowColors[index % shadowColors.length];
    return color;
  }
}

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    Key? key,
    this.width,
    this.height,
    this.onTap,
    this.duration = const Duration(milliseconds: 250),
    this.isDisabled = false,
    required this.child,
  }) : super(key: key);

  final void Function()? onTap;
  final Widget child;
  final double? width;
  final double? height;
  final Duration duration;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      width: width,
      height: height,
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.centerLeft,
      //     end: Alignment
      //         .centerRight, // 10% of the width, so there are ten blinds.
      //     colors: colors,
      //     stops: const [0, 0.1, 0.9, 1],
      //   ),
      // ),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            alignment: Alignment.center,
            child: AnimatedSize(
              duration: duration,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
