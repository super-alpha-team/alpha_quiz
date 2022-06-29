class LTIQuiz{
  int id;
  int courseId;
  int courseModule;
  String name;
  String? intro;

  LTIQuiz({
    required this.id,
    required this.courseId,
    required this.courseModule,
    required this.name,
    required this.intro,
  });

  factory LTIQuiz.fromJson(dynamic json) {
    return LTIQuiz(
      id: json['id'],
      courseId: json['course'],
      courseModule: json['coursemodule'],
      name: json['name'],
      intro: json['intro'],
    );
  }
}
