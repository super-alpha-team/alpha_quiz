import 'package:alpha_quiz/modles/quiz/question.dart';
import 'package:alpha_quiz/modules/play/components/answer_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class MatchingView extends StatefulWidget {
  const MatchingView({
    Key? key,
    required this.question,
    required this.leftAnswers,
    required this.rightAnswers,
    required this.choose,
  }) : super(key: key);

  final List<Answer>? leftAnswers;
  final List<Answer>? rightAnswers;
  final String question;
  final void Function(dynamic)? choose;

  @override
  State<MatchingView> createState() => _MatchingViewState();
}

class _MatchingAnswer {
  String leftAnswer = '';
  String rightAnswer = '';
  int colorIndex = -1;
  int leftAnswerIndex = -1;
}

class _MatchingViewState extends State<MatchingView> {
  List<_MatchingAnswer> selected = [];

  int currentAnswerTab = 0;

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
                      'user-select: none; -ms-user-select: none; -webkit-user-select: none; background-color:transparent; padding: 16px',
                    ),
                    child: TeXViewDocument(
                      widget.question,
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
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        color: Colors.transparent,
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: currentAnswerTab == 0 ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: currentAnswerTab == 1,
                          child: _buildLeftAnswers(),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: currentAnswerTab == 0 ? 0 : 1,
                        child: IgnorePointer(
                          ignoring: currentAnswerTab == 0,
                          child: _buildRightAnswers(),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: currentAnswerTab == 0
                          ? null
                          : () {
                              setState(() {
                                currentAnswerTab = 0;
                              });
                            },
                      icon: const Icon(
                        Icons.arrow_left,
                        size: 24,
                      ),
                      splashColor: Colors.grey.shade100,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    IconButton(
                      onPressed: currentAnswerTab == 1
                          ? null
                          : () {
                              setState(() {
                                currentAnswerTab = 1;
                              });
                            },
                      icon: const Icon(
                        Icons.arrow_right,
                        size: 24,
                      ),
                      splashColor: Colors.grey.shade100,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  height: 48,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: ElevatedButton(
                    onPressed: submit,
                    child: const Text('Submit'),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void submit() {
    final ans =
        selected.map((e) => MapEntry(e.leftAnswer, e.rightAnswer)).toList();
    widget.choose?.call(Map.fromEntries(ans));
  }

  String _leftSelecting = '';
  String _rightSelecting = '';

  void _leftSelect(String id) {
    int selectedIndex = selected.indexWhere((e) => e.leftAnswer == id);
    int leftAnswerIndex =
        widget.leftAnswers?.indexWhere((e) => e.id == id) ?? 0;

    if (selectedIndex > -1) {
      selected.removeAt(selectedIndex);
    } else if (_rightSelecting.isEmpty) {
      if (_leftSelecting == id) {
        _leftSelecting = '';
      } else {
        _leftSelecting = id;
      }
    } else {
      _leftSelecting = id;
      final ans = _MatchingAnswer()
        ..leftAnswer = _leftSelecting
        ..rightAnswer = _rightSelecting
        ..leftAnswerIndex = leftAnswerIndex
        ..colorIndex = _getNextColor();

      selected.add(ans);
      _leftSelecting = '';
      _rightSelecting = '';
    }

    setState(() {});
  }

  void _rightSelect(String id) {
    int selectedIndex = selected.indexWhere((e) => e.rightAnswer == id);
    if (selectedIndex > -1) {
      selected.removeAt(selectedIndex);
    } else if (_leftSelecting.isEmpty) {
      if (_rightSelecting == id) {
        _rightSelecting = '';
      } else {
        _rightSelecting = id;
      }
    } else {
      _rightSelecting = id;

      final ans = _MatchingAnswer();
      ans.leftAnswer = _leftSelecting;
      ans.rightAnswer = _rightSelecting;
      ans.colorIndex = _getNextColor();
      ans.leftAnswerIndex =
          widget.leftAnswers?.indexWhere((e) => e.id == _leftSelecting) ?? 0;

      selected.add(ans);
      _leftSelecting = '';
      _rightSelecting = '';
    }

    setState(() {});
  }

  int _getNextColor() {
    final colors = selected.map((e) => e.colorIndex).toList();

    if (colors.isEmpty) {
      return 0;
    }
    colors.sort();
    int n = colors.length;

    if (n == 1 && colors[0] != 0) {
      return 0;
    }
    for (int i = 0; i < n - 1; i++) {
      if (colors[i] != colors[i + 1] - 1) {
        return colors[i] + 1;
      }
    }
    return colors[n - 1] + 1;
  }

  Widget _buildLeftAnswers() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: TeXView(
        style: const TeXViewStyle.fromCSS(
          'user-select: none; -ms-user-select: none; background-color:transparent; -webkit-user-select: none;',
        ),
        child: TeXViewColumn(
          children: List.generate(
            widget.leftAnswers?.length ?? 0,
            (index) {
              final id = widget.leftAnswers?[index].id ?? '-1';

              bool isSelected = id == _leftSelecting;

              if (!isSelected) {
                isSelected =
                    selected.indexWhere((e) => e.leftAnswer == id) > -1;
              }

              return TeXViewInkWell(
                id: id,
                rippleEffect: true,
                style: TeXViewStyle.fromCSS(_getLeftAnswerCSS(index)),
                child: TeXViewDocument(
                  _getLeftAnswer(index),
                  style: TeXViewStyle(
                    contentColor: isSelected ? Colors.white : Colors.black,
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
                  _leftSelect(id);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRightAnswers() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: TeXView(
        style: const TeXViewStyle.fromCSS(
          'user-select: none; -ms-user-select: none; background-color:transparent; -webkit-user-select: none;',
        ),
        child: TeXViewColumn(
          children: List.generate(widget.leftAnswers?.length ?? 0, (index) {
            final id = widget.rightAnswers?[index].id ?? '-1';

            bool isSelected = id == _rightSelecting;

            if (!isSelected) {
              isSelected = selected.indexWhere((e) => e.rightAnswer == id) > -1;
            }

            return TeXViewInkWell(
              id: id,
              rippleEffect: true,
              style: TeXViewStyle.fromCSS(_getRightAnswerCSS(index)),
              child: TeXViewDocument(
                _getRightAnswer(index),
                style: TeXViewStyle(
                  contentColor: isSelected ? Colors.white : Colors.black,
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
                _rightSelect(id);
              },
            );
          }),
        ),
      ),
    );
  }

  String _getLeftAnswer(int index) {
    final ans = widget.leftAnswers?[index].answer ?? '';

    String selectIdTag = '<p style="display: flex;'
        ' background-color: white;'
        ' color: black;'
        ' border-radius: 100%;'
        ' width: 24px; height: 24px;'
        ' justify-content: center; align-items: center;">'
        '${index + 1}</p>';

    final ansTag = '<p'
        ' style="width: 100%;'
        ' display: flex;'
        ' align-items: center;'
        ' justify-content: center;">'
        '$ans'
        '</p>';

    return '<div style="display: flex; vertical-align: middle;">'
        '$selectIdTag'
        '$ansTag'
        '</div>';
  }

  String _getRightAnswer(int index) {
    final ans = widget.rightAnswers?[index].answer ?? '';
    final ansId = widget.rightAnswers?[index].id ?? '';
    String selectIdTag = '';
    final ansTag = '<p'
        ' style="width: 100%;'
        ' display: flex;'
        ' align-items: center;'
        ' justify-content: center;">'
        '$ans'
        '</p>';

    final selectId = selected.indexWhere((e) => e.rightAnswer == ansId);

    if (selectId > -1) {
      selectIdTag = '<p style="display: flex;'
          ' background-color: white;'
          ' color: black;'
          ' border-radius: 100%;'
          ' width: 24px; height: 24px;'
          ' justify-content: center; align-items: center;">'
          '${selected[selectId].leftAnswerIndex + 1}</p>';
    }
    return '<div style="display: flex;">'
        '$selectIdTag'
        '$ansTag'
        '</div>';
  }

  String _getLeftAnswerCSS(int index) {
    final id = widget.leftAnswers?[index].id;
    if (_leftSelecting == id) {
      final colorIndex = _getNextColor();
      final color = AnswerButtonColors.colorAt(colorIndex);
      final shadow = AnswerButtonColors.shadowColorAt(colorIndex);
      return _getAnswerCSS(color, shadow);
    }

    for (final ans in selected) {
      if (ans.leftAnswer == id) {
        final color = AnswerButtonColors.colorAt(ans.colorIndex);
        final shadow = AnswerButtonColors.shadowColorAt(ans.colorIndex);
        return _getAnswerCSS(color, shadow);
      }
    }
    return _getAnswerCSS(Colors.grey.shade200, Colors.grey.shade400);
  }

  String _getRightAnswerCSS(int index) {
    final id = widget.rightAnswers?[index].id;
    if (_rightSelecting == id) {
      final colorIndex = _getNextColor();
      final color = AnswerButtonColors.colorAt(colorIndex);
      final shadow = AnswerButtonColors.shadowColorAt(colorIndex);
      return _getAnswerCSS(color, shadow);
    }

    for (final ans in selected) {
      if (ans.rightAnswer == id) {
        final color = AnswerButtonColors.colorAt(ans.colorIndex);
        final shadow = AnswerButtonColors.shadowColorAt(ans.colorIndex);
        return _getAnswerCSS(color, shadow);
      }
    }
    return _getAnswerCSS(Colors.grey.shade200, Colors.grey.shade400);
  }

  String _getAnswerCSS(Color color, Color shadow) {
    final colorRGBA = AnswerButtonColors.rgba(color);
    final shadowRGBA = AnswerButtonColors.rgba(shadow);
    return 'overflow: hidden; position: relative;'
        ' background-color: $colorRGBA;'
        ' margin: 0px 24px 16px 24px;'
        ' border-radius: 4px;'
        ' box-shadow: 0px 3px $shadowRGBA;';
  }
}
