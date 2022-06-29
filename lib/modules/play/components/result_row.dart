import 'package:alpha_quiz/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ResultRow extends StatelessWidget {
  const ResultRow({
    Key? key,
    this.question = '',
    this.userGrade = '',
    this.questionGrade = '',
    this.textStyle = TextStyles.subtitle1Regular,
    this.showRightArrow = true,
    this.isCorrect,
  }) : super(key: key);

  final String question;
  final String userGrade;
  final String questionGrade;
  final TextStyle textStyle;
  final bool showRightArrow;
  final bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                question,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                questionGrade,
                textAlign: TextAlign.center,
                style: textStyle.copyWith(
                  color: _getUserAnswerTextColor(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                userGrade,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '',
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color? _getUserAnswerTextColor() {
    if (isCorrect == null) {
      return null;
    }

    if (isCorrect!) {
      return Colors.green;
    }

    return Colors.red;
  }
}
