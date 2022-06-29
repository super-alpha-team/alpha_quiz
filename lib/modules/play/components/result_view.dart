import 'package:alpha_quiz/extensions/number_utils.dart';
import 'package:alpha_quiz/styles/text_styles.dart';
import 'package:flutter/material.dart';

class AnswerResultView extends StatelessWidget {
  const AnswerResultView({
    Key? key,
    required this.mark,
  }) : super(key: key);

  final double mark;

  @override
  Widget build(BuildContext context) {
    final isTimesUp = mark < 0.001;
    return Container(
      color: const Color(0xff46178F),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isTimesUp ? 'Opps!' : 'Congrats!',
            style: TextStyles.h4Bold.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          isTimesUp ? _wrongIcon() : _correctIcon(),
          const SizedBox(
            height: 16,
          ),
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Text(
              isTimesUp ? 'Great try.' : '+ ${NumberUtils.toMark(mark)}',
              style: TextStyles.h6Bold.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrongIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: const ShapeDecoration(
        color: Colors.red,
        shape: CircleBorder(
          side: BorderSide(color: Colors.white, width: 4),
        ),
      ),
      child: const Icon(
        Icons.close,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _correctIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: ShapeDecoration(
        color: Colors.lightGreenAccent.shade700,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.white, width: 4),
        ),
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}

class QuizResultView extends StatelessWidget {
  const QuizResultView({
    Key? key,
    required this.mark,
    required this.rank,
  }) : super(key: key);

  final double mark;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff46178F),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Congrats!',
            style: TextStyles.h4Bold.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          _rankWidget(),
          const SizedBox(
            height: 16,
          ),
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Text(
              'Your grade: ${NumberUtils.toMark(mark)}',
              style: TextStyles.h6Bold.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 16,
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _rankWidget() {
    return Container(
      width: 90,
      height: 90,
      alignment: Alignment.center,
      decoration: const ShapeDecoration(
        color: Colors.orange,
        shape: CircleBorder(
          side: BorderSide(color: Colors.white, width: 4),
        ),
      ),
      child: FittedBox(
        child: Text(
          '#$rank',
          style: TextStyles.h4Bold.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
