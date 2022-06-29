class QuizSummary {
  int id;
  int courseId;
  int courseModule;
  String name;
  String? intro;

  QuizSummary({
    required this.id,
    required this.courseId,
    required this.courseModule,
    required this.name,
    required this.intro,
  });

  factory QuizSummary.fromJson(dynamic json) {
    return QuizSummary(
      id: json['id'],
      courseId: json['course'],
      courseModule: json['coursemodule'],
      name: json['name'],
      intro: json['intro'],
    );
  }
}
