class AlphaQuiz {
  final NewQuiz? newQuiz;
  final Map? context;
  final Instance? instance;
  final int platformUserId;
  final List<SubmissionData> submissionData;

  AlphaQuiz({
    required this.newQuiz,
    required this.context,
    required this.instance,
    required this.platformUserId,
    required this.submissionData,
  });

  factory AlphaQuiz.fromJson(Map<String, dynamic> json) {
    final newQuiz =
        json['new_quiz'] != null ? NewQuiz.fromJson(json['new_quiz']) : null;
    final instance =
        json['instance'] != null ? Instance.fromJson(json['instance']) : null;
    final context = json['context'];

    final platformUserId = json['new_user']['id'];
    final submissionDataJson = json['submission_data'];
    List<SubmissionData> submissionData = [];

    if (submissionDataJson != null && submissionDataJson is List) {
      submissionData = submissionDataJson.map((v) {
        return SubmissionData.fromJson(v);
      }).toList();
    }
    return AlphaQuiz(
      newQuiz: newQuiz,
      context: context,
      instance: instance,
      platformUserId: platformUserId,
      submissionData: submissionData,
    );
  }
}

class NewQuiz {
  final int id;
  final String? platformId;
  final String? ltiResourceId;
  final String? quizId;
  final String? name;
  final Map<String, dynamic>? additionalInfo;
  final int? newQuizInstanceActiveId;
  final String? createdAt;
  final String? updatedAt;

  NewQuiz({
    required this.id,
    this.platformId,
    this.ltiResourceId,
    this.quizId,
    this.name,
    this.additionalInfo,
    this.newQuizInstanceActiveId,
    this.createdAt,
    this.updatedAt,
  });

  factory NewQuiz.fromJson(Map<String, dynamic> json) {
    return NewQuiz(
      id: json['id'],
      platformId: json['platform_id'],
      ltiResourceId: json['lti_resource_id'],
      quizId: json['quiz_id'],
      name: json['name'],
      additionalInfo: json['additional_info'],
      newQuizInstanceActiveId: json['new_quiz_instance_active_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Instance {
  final int id;
  final String? newQuizId;
  final String? name;
  final Map<String, dynamic>? additionalInfo;
  final String? status;
  final String? socketId;
  final int? currentQuestion;
  final double? sumGrade;

  Instance({
    required this.id,
    this.newQuizId,
    this.name,
    this.additionalInfo,
    this.status,
    this.socketId,
    this.currentQuestion,
    this.sumGrade,
  });

  factory Instance.fromJson(Map<String, dynamic> json) {
    return Instance(
      id: json['id'],
      newQuizId: json['new_quiz_id'],
      name: json['name'],
      additionalInfo: json['additional_info'],
      status: json['status'],
      socketId: json['socket_id'],
      currentQuestion: json['current_question'],
      sumGrade: json['sum_grade'] == null
          ? null
          : (json['sum_grade'] as num).toDouble(),
    );
  }
}

class SubmissionData {
  final int id;
  final String? name;
  final double? grade;
  final int? rank;

  SubmissionData({
    required this.id,
    this.name,
    this.grade,
    this.rank,
  });

  factory SubmissionData.fromJson(Map<String, dynamic> json) {
    final grade = json['data']['total_grade'];

    return SubmissionData(
      id: json['id'],
      name: json['name'],
      rank: json['rank'],
      grade: double.tryParse(grade.toString()),
    );
  }
}
