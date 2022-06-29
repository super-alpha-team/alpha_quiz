import 'package:alpha_quiz/modles/quiz/question.dart';
import 'package:alpha_quiz/modules/play/components/answer_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class MCQView extends StatelessWidget {
  const MCQView({
    Key? key,
    required this.question,
    required this.answers,
    required this.choose,
  }) : super(key: key);

  final List<Answer>? answers;
  final String question;
  final void Function(String)? choose;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: padding.bottom),
        child: ConstrainedBox(
          constraints: constraints.copyWith(
            minHeight: constraints.maxHeight,
            maxHeight: double.infinity,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.symmetric(
                    // horizontal: 24,
                    vertical: 12,
                  ),
                  child: TeXView(
                    style: const TeXViewStyle.fromCSS(
                      'user-select: none; -ms-user-select: none; -webkit-user-select: none; padding: 16px',
                    ),
                    child: TeXViewDocument(
                      question,
                      style: TeXViewStyle(
                        contentColor:
                            Theme.of(context).textTheme.bodyText1?.color ??
                                Colors.black,
                        //textAlign: TeXViewTextAlign.center,
                        fontStyle: TeXViewFontStyle(
                          fontSize: 20,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 40),
                    child: TeXView(
                      style: const TeXViewStyle.fromCSS(
                        'user-select: none; -ms-user-select: none; -webkit-user-select: none;',
                      ),
                      child: TeXViewColumn(
                        children: List.generate(
                          answers?.length ?? 0,
                          (index) => TeXViewInkWell(
                            id: '$index',
                            rippleEffect: true,
                            style: TeXViewStyle.fromCSS(
                              'overflow: hidden; position: relative; background-color: ${_getAnswerButtonColorCSS(index)}; margin: 0px 24px 16px 24px; border-radius: 4px; box-shadow: 0px 3px ${_getAnswerButtonShadowColorCSS(index)};',
                            ),
                            // style: TeXViewStyle(
                            //   borderRadius: TeXViewBorderRadius.all(4),
                            //   backgroundColor: _getAnswerButtonColor(index),
                            //   elevation: 4,
                            //   margin: const TeXViewMargin.only(
                            //     bottom: 16,
                            //     left: 24,
                            //     right: 24,
                            //   ),
                            // ),
                            child: TeXViewDocument(
                              _getAnswer(index),
                              style: TeXViewStyle(
                                contentColor: Colors.white,
                                //textAlign: TeXViewTextAlign.center,
                                padding: const TeXViewPadding.only(
                                  left: 24,
                                  right: 24,
                                  top: 16,
                                  bottom: 16,
                                ),
                                fontStyle: TeXViewFontStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            onTap: (id) {
                              choose?.call(answers?[index].id ?? '-1');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _getAnswer(int index) {
    // return String.fromCharCode(65 + index) +
    //     '. ' +
    //     answers[_questionIndex][index];

    return answers?[index].answer ?? '';
  }

  // List<Color> _getAnswerButtonColor(int answerIndex) {
  //   if (_selectedAnswer == null) {
  //     return AnswerButtonColors.get(answerIndex);
  //   }
  //   if (answerIndex == _selectedAnswer) {
  //     return AnswerButtonColors.green;
  //   }
  //   return AnswerButtonColors.grey;
  // }

  // String _getAnswerButtonColorCss(int answerIndex) {
  //   final lgr = AnswerButtonColors.toCss(AnswerButtonColors.get(answerIndex));
  //   return 'background: $lgr';
  // }

  Color _getAnswerButtonColor(int answerIndex) {
    final color = AnswerButtonColors.colorAt(answerIndex);
    return color;
  }

  String _getAnswerButtonColorCSS(int answerIndex) {
    return AnswerButtonColors.rgba(_getAnswerButtonColor(answerIndex));
  }

  Color _getAnswerButtonShadowColor(int answerIndex) {
    final color = AnswerButtonColors.shadowColorAt(answerIndex);
    return color;
  }

  String _getAnswerButtonShadowColorCSS(int answerIndex) {
    return AnswerButtonColors.rgba(_getAnswerButtonShadowColor(answerIndex));
  }
}
