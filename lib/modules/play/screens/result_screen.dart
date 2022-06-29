import 'dart:math';
import 'package:alpha_quiz/extensions/number_utils.dart';
import 'package:alpha_quiz/modules/play/provider/play_screen_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PlayScreenVM>(context, listen: false);
    final quizData = vm.quizData;

    String quizName = '';

    if (quizData?.context != null && quizData?.context?['resource'] != null) {
      quizName = quizData?.context?['resource']['title'];
    }

    if (quizData == null) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(title: Text(quizName)),
        body: const Center(
          child: Text('Quiz submission cannot null'),
        ),
      );
    }

    final double? maxGrade = quizData.instance?.sumGrade;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(title: Text(quizName)),
      body: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Instance')),
                    DataColumn(label: Text('Grade')),
                    DataColumn(label: Text('Correctness')),
                    // DataColumn(label: Text('Rank')),
                  ],
                  rows: List.generate(quizData.submissionData.length, (index) {
                    final submission = quizData.submissionData[index];

                    final correctness =
                        (submission.grade ?? 0) / (maxGrade ?? 1);

                    String grade = NumberUtils.toMark(
                        min(submission.grade ?? 0, maxGrade ?? 0));

                    if (maxGrade != null) {
                      grade = grade + '/' + NumberUtils.toMark(maxGrade);
                    }

                    String rank = '-';
                    if (submission.rank != null) {
                      rank = '#${submission.rank}';
                    }

                    return DataRow(
                      cells: [
                        DataCell(Text(submission.name ?? '')),
                        DataCell(
                          Text(
                            grade,
                            style: TextStyle(
                              color:
                                  correctness < 0.5 ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                        DataCell(
                          LinearProgressIndicator(
                            value: correctness,
                            color:
                                correctness < 0.5 ? Colors.red : Colors.green,
                            minHeight: 4,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                        // DataCell(Text(rank)),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
