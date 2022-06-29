import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class ShortAnswerView extends StatefulWidget {
  const ShortAnswerView({
    Key? key,
    required this.question,
    required this.choose,
  }) : super(key: key);

  final String question;
  final void Function(String)? choose;

  @override
  State<ShortAnswerView> createState() => _ShortAnswerViewState();
}

class _ShortAnswerViewState extends State<ShortAnswerView> {
  final _textEditController = TextEditingController();

  @override
  void dispose() {
    _textEditController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: LayoutBuilder(builder: (context, constraints) {
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
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: TextField(
                        controller: _textEditController,
                        enableSuggestions: false,
                        autocorrect: false,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Answer',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.choose?.call(_textEditController.text);
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
