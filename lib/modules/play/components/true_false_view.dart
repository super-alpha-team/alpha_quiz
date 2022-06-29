import 'package:alpha_quiz/modules/play/components/answer_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class TrueFalseView extends StatelessWidget {
  const TrueFalseView({
    Key? key,
    required this.question,
    required this.choose,
  }) : super(key: key);

  final String question;
  final void Function(int)? choose;

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
                    horizontal: 24,
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
                      child: TeXViewColumn(children: [
                        TeXViewInkWell(
                            id: 'True',
                            rippleEffect: false,
                            style: TeXViewStyle.fromCSS(
                              'overflow: hidden; position: relative; background-color: ${_getAnswerButtonColorCSS(0)}; margin: 0px 24px 16px 24px; border-radius: 4px; box-shadow: 0px 3px ${_getAnswerButtonShadowColorCSS(0)};',
                            ),
                            child: TeXViewDocument(
                              'True',
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
                              choose?.call(1);
                            }),
                        TeXViewInkWell(
                            id: 'False',
                            rippleEffect: false,
                            style: TeXViewStyle.fromCSS(
                              'overflow: hidden; position: relative; background-color: ${_getAnswerButtonColorCSS(1)}; margin: 0px 24px 16px 24px; border-radius: 4px; box-shadow: 0px 3px ${_getAnswerButtonShadowColorCSS(1)};',
                            ),
                            child: TeXViewDocument(
                              'False',
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
                              choose?.call(2);
                            }),
                      ]),
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
