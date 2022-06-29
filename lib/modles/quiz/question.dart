class Question {
  int id;
  String questiontext;
  String? questiontextformat;
  String qtype;
  String? penalty;
  String? defaultmark;
  List<Answer>? answers;
  QuestionAdditionalInfo? additionalInfo;

  Question({
    required this.id,
    required this.questiontext,
    this.questiontextformat,
    required this.qtype,
    this.penalty,
    this.defaultmark,
    this.answers,
    this.additionalInfo,
  });

  factory Question.fromJson(dynamic json) => Question(
        id: json['id'] as int,
        questiontext: json['questiontext'] as String,
        questiontextformat: json['questiontextformat'] as String?,
        qtype: json['qtype'] as String,
        penalty: json['penalty'] as String?,
        defaultmark: json['defaultmark'] as String?,
        answers: (json['answers'] as List<dynamic>?)
            ?.map((e) => Answer.fromJson(e))
            .toList(),
        additionalInfo:
            QuestionAdditionalInfo.fromJson(json['additional_info']),
      );
}

class Answer {
  String id;
  String answer;
  String? answerformat;
  String? fraction;

  Answer({
    required this.id,
    required this.answer,
    this.answerformat,
    this.fraction,
  });
  factory Answer.fromJson(dynamic json) => Answer(
        id: json['id'] as String,
        answer: json['answer'] as String,
        answerformat: json['answerformat'] as String?,
        fraction: json['fraction'] as String?,
      );
}

class QuestionAdditionalInfo {
  Map<String, dynamic>? stems;
  Map<String, dynamic>? choices;

  QuestionAdditionalInfo({
    this.stems,
    this.choices,
  });
  factory QuestionAdditionalInfo.fromJson(dynamic json) =>
      QuestionAdditionalInfo(
        stems: (json['stems'] as Map<String, dynamic>?),
        choices: (json['choices'] as Map<String, dynamic>?),
      );
}
