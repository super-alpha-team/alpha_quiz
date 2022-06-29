class QuizRoom {
  int id;
  QuizStatus status;
  String quizId;
  String socketId;

  QuizRoom({
    required this.id,
    required this.status,
    required this.socketId,
    required this.quizId,
  });

  factory QuizRoom.fromJson(dynamic json) {
    final id = json['id'];
    final quizId = json['quiz_id'];
    final socketId = json['socket_id'];
    final status = _quizStatusValues[(json['status'] as String?) ?? ''] ??
        QuizStatus.unknown;

    return QuizRoom(
      id: id,
      status: status,
      socketId: socketId,
      quizId: quizId,
    );
  }

  factory QuizRoom.fromLtiSyncLti(dynamic json) {
    final id = json['data']['new_quiz']['id'];
    final quizId = json['data']['new_quiz']['quiz_id'];
    final socketId = json['data']['instance']['socket_id'];
    final status = _quizStatusValues[
            (json['data']['instance']['status'] as String?) ?? ''] ??
        QuizStatus.unknown;

    return QuizRoom(
      id: id,
      status: status,
      socketId: socketId,
      quizId: quizId,
    );
  }
}

enum QuizStatus {
  editing,
  playing,
  done,
  unknown,
}

final Map<String, QuizStatus> _quizStatusValues = {
  'editing': QuizStatus.editing,
  'playing': QuizStatus.playing,
  'done': QuizStatus.done,
  '': QuizStatus.unknown,
};
