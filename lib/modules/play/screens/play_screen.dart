import 'dart:async';

import 'package:alpha_quiz/modles/quiz/question.dart';
import 'package:alpha_quiz/modules/play/components/matching_view.dart';
import 'package:alpha_quiz/modules/play/components/mcq_view.dart';
import 'package:alpha_quiz/modules/play/components/result_view.dart';
import 'package:alpha_quiz/modules/play/components/short_answer_view.dart';
import 'package:alpha_quiz/modules/play/components/true_false_view.dart';
import 'package:alpha_quiz/modules/play/provider/play_screen_vm.dart';
import 'package:alpha_quiz/modules/play/screens/editing_screen.dart';
import 'package:alpha_quiz/modules/play/screens/result_screen.dart';
import 'package:alpha_quiz/modules/play/screens/waiting_screen.dart';
import 'package:alpha_quiz/styles/alpha_quiz_theme.dart';
import 'package:alpha_quiz/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({
    Key? key,
    required this.toolId,
  }) : super(key: key);

  final int toolId;
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final vm = PlayScreenVM();

  @override
  void initState() {
    super.initState();

    vm.init(widget.toolId);
    vm.fetchData();
  }

  @override
  void dispose() {
    vm.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlphaQuizTheme(
      child: ChangeNotifierProvider.value(
        value: vm,
        child: Consumer<PlayScreenVM>(builder: (context, _, __) {
          // final quizRoom = vm.quizRoom;

          if (vm.errorMessage != null) {
            return Scaffold(
              body: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie_files/circle-x.json',
                        package: 'alpha_quiz',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'Error',
                        style: TextStyles.subtitle1SemiBold,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        vm.errorMessage ?? '',
                        style: TextStyles.subtitle1Regular,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Return'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (vm.screenState == PlayScreenState.loading) {
            return const Scaffold(
              body: Center(child: CupertinoActivityIndicator()),
            );
          }

          if (vm.screenState == PlayScreenState.showingQuizResult) {
            return const ResultScreen();
          }

          if (vm.screenState == PlayScreenState.editing) {
            return const EditingScreen(
              message: 'This quiz has not started yet.',
            );
          }

          if (vm.screenState == PlayScreenState.ended) {
            return Scaffold(
              body: QuizResultView(
                mark: vm.currentMark ?? 0,
                rank: vm.currentRank ?? 0,
              ),
            );
          }

          if (vm.screenState == PlayScreenState.showingAnswerResult) {
            return Scaffold(
              body: AnswerResultView(
                mark: vm.currentAnswerMark ?? 0,
              ),
            );
          }

          if (vm.questionDeadline?.isBefore(DateTime.now()) ?? false) {
            return Scaffold(
              body: AnswerResultView(mark: vm.currentAnswerMark ?? 0),
            );
          }

          if (vm.currentQuestion == null) {
            return const WaitingScreen(
              message: 'Waiting for the teacher to start...',
            );
          }

          if (vm.screenState == PlayScreenState.waiting) {
            return Scaffold(
              body: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    CountdownView(
                      deadline: vm.questionDeadline,
                    ),
                    const Expanded(
                      child: WaitingScreen(
                        message: 'Great! Let\'s wait for your mates',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  CountdownView(
                    deadline: vm.questionDeadline,
                  ),
                  Expanded(
                    child: questionView(),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget questionView() {
    final question = vm.currentQuestion;

    if (question == null) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    if (question.qtype == 'true/false') {
      return TrueFalseView(
        question: question.questiontext,
        choose: _choose,
      );
    }

    if (question.qtype == 'shortanswer') {
      return ShortAnswerView(
        question: question.questiontext,
        choose: _shortAnswer,
      );
    }

    if (question.qtype == 'numerical') {
      return ShortAnswerView(
        question: question.questiontext,
        choose: _shortAnswer,
      );
    }

    if (question.qtype == 'matching') {
      return MatchingView(
        question: question.questiontext,
        leftAnswers: question.additionalInfo?.stems?.entries
            .map((e) => Answer(id: e.key, answer: e.value))
            .toList(),
        rightAnswers: question.additionalInfo?.choices?.entries
            .map((e) => Answer(id: e.key, answer: e.value))
            .toList(),
        choose: _choose,
      );
    }

    return MCQView(
      question: question.questiontext,
      answers: question.answers,
      choose: _choose,
    );
  }

  void _choose(dynamic answerId) {
    vm.sendAnswer(answerId);
  }

  void _shortAnswer(String answer) {
    vm.sendAnswer(answer);
  }
}

class CountdownView extends StatefulWidget {
  const CountdownView({
    Key? key,
    required this.deadline,
  }) : super(key: key);

  final DateTime? deadline;

  @override
  State<CountdownView> createState() => CountdownViewState();
}

class CountdownViewState extends State<CountdownView> {
  Timer? _timer;

  String get timeLeft {
    final now = DateTime.now();
    final deadline = widget.deadline;
    if (deadline != null && deadline.isAfter(now)) {
      final duration = deadline.difference(now).inSeconds;
      final m = (duration ~/ 60).toString().padLeft(2, '0');
      final s = (duration % 60).toString().padLeft(2, '0');

      return '$m:$s';
    }

    return '00:00';
  }

  bool get countdown {
    final deadline = widget.deadline;
    final now = DateTime.now();

    return deadline != null && deadline.isAfter(now);
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), _timerBlock);
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  void _timerBlock(Timer timer) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: countdown
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie_files/clock.json',
                    package: 'alpha_quiz',
                    width: 24,
                    height: 24,
                  ),
                  Text(
                    timeLeft,
                    style: TextStyles.subtitle1SemiBold.copyWith(
                      color: Colors.amber[700],
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
