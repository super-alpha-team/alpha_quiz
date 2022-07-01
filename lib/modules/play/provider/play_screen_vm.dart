import 'dart:async';
import 'package:alpha_quiz/modles/quiz/alpha_quiz.dart';
import 'package:alpha_quiz/modles/quiz/question.dart';
import 'package:alpha_quiz/modles/quiz/quiz_status.dart';
import 'package:alpha_quiz/services/alpha_quiz_data.dart';
import 'package:alpha_quiz/services/api.dart';
import 'package:alpha_quiz/services/quiz_api.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum PlayScreenState {
  loading,
  playing,
  waiting,
  editing,
  showingAnswerResult,
  showingQuizResult,
  ended,
}

class PlayScreenVM extends ChangeNotifier {
  int _toolId = 0;
  int _platformUserId = -1;
  String? _errorMessage;
  String? get errorMessage {
    return _errorMessage;
  }

  String? _alphaToken;
  String? get alphaToken {
    return _alphaToken;
  }

  String? _username = AlphaQuizData.username;
  String? get username {
    return _username;
  }

  QuizRoom? quizRoom;

  List<Question>? questions;
  Question? currentQuestion;

  DateTime? questionDeadline;

  int _questionIndex = 0;
  int get questionIndex {
    return _questionIndex;
  }

  double? _currentAnswerMark;
  double? get currentAnswerMark {
    return _currentAnswerMark;
  }

  double? _currentMark;
  double? get currentMark {
    return _currentMark;
  }

  int? _currentRank;
  int? get currentRank {
    return _currentRank;
  }

  PlayScreenState _screenState = PlayScreenState.loading;
  PlayScreenState get screenState {
    return _screenState;
  }

  AlphaQuiz? _quizData;
  AlphaQuiz? get quizData {
    return _quizData;
  }

  Timer? _timer;

  final _audioPlayer = AudioPlayer();

  void loadAudio() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAsset('packages/alpha_quiz/assets/audios/audio.mp3');
    await _audioPlayer.play();
  }

  //Socket
  final Socket socket = io(
      AlphaAPI.alphaSocket,
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .build());

  @override
  void dispose() {
    socket.dispose();
    _timer?.cancel();
    _audioPlayer.dispose();

    super.dispose();
  }

  void init(int toolId) {
    _toolId = toolId;
  }

  void onReceiveGrade(data) {
    print('${DateTime.now()} Socket Event grade_student ${data}');

    if (data['grade'] != null && data['grade'] is Map<String, dynamic>) {
      final Map<String, dynamic> grade = data['grade'];

      final row = grade[questionIndex.toString()];

      if (row != null) {
        final mark = row[_platformUserId.toString()];
        print('mark $mark');

        if (mark is num) {
          _currentAnswerMark = mark.toDouble();

          if (_screenState != PlayScreenState.ended) {
            _screenState = PlayScreenState.showingAnswerResult;
          }
        }
      }
    }

    notifyListeners();
  }

  void onReceiveRank(data) {
    print('${DateTime.now()} Socket Event rank ${data}');

    try {
      final rankList = data['rank_list'] as List;

      final rank =
          rankList.firstWhere((e) => e['id'] == _platformUserId) as Map;

      _currentMark = (rank['sum_grade'] as num).toDouble();
      _currentRank = rank['rank'] as int;
    } catch (e, s) {
      print(e);
      print(s);
    }

    notifyListeners();
  }

  void onReceiveQuestion(data) {
    print('${DateTime.now()} Socket Event question ${data}');

    if (data is! Map<String, dynamic>) {
      return;
    }

    final currentQuestionIndex = data['current_question_index'] as int?;
    if (currentQuestionIndex != null) {
      if (currentQuestionIndex > -1) {
        _screenState = PlayScreenState.playing;

        _currentAnswerMark = null;

        _questionIndex = currentQuestionIndex;

        currentQuestion = Question.fromJson(data['question']);

        final endTime = data['question']['time_end'] as int;

        final deadline = DateTime.fromMillisecondsSinceEpoch(endTime);
        questionDeadline = deadline;

        final timeDiff = deadline.difference(DateTime.now());

        _timer?.cancel();
        _timer = Timer(timeDiff, () async {
          if (currentQuestionIndex == _questionIndex &&
              _screenState != PlayScreenState.waiting &&
              _screenState != PlayScreenState.ended) {
            sendAnswer(null);
          }

          notifyListeners();
        });
      } else {
        print('Socket Event end');
        _screenState = PlayScreenState.ended;
      }
    }

    notifyListeners();
  }

  Future<void> fetchData() async {
    _screenState = PlayScreenState.loading;
    notifyListeners();

    final quizData = await QuizAPI.syncInfo(_toolId);

    _quizData = quizData;
    _platformUserId = quizData.platformUserId;

    final status = quizData.instance?.status;

    if (status == null || status == 'editing') {
      _screenState = PlayScreenState.editing;
    } else if (status == 'done') {
      _screenState = PlayScreenState.showingQuizResult;
    } else {
      _screenState = PlayScreenState.waiting;

      start();
    }

    notifyListeners();
  }

  Future<void> start() async {
    loadAudio();

    socket.connect();
    socket.onDisconnect((data) {
      print('Socket disconnect');
    });

    socket.on('question', onReceiveQuestion);
    socket.on('grade_student', onReceiveGrade);
    socket.on('rank', onReceiveRank);

    socket.onConnect((data) {
      final room = quizRoom?.socketId;
      if (room != null && username != null) {
        print('Socket join-onConnect"$room" "$username"');
        socket.emit(
          'join',
          {'username': username, 'room': room, 'token': alphaToken},
        );
      }
    });
    //
    try {
      _screenState = PlayScreenState.waiting;
      final response = await QuizAPI.getQuizRoom(_toolId);
      quizRoom = response;

      final token = await QuizAPI.joinQuiz(
        _toolId,
        response.id,
        username ?? AlphaQuizData.username,
      );
      _alphaToken = token;
      final room = response.socketId;

      if (socket.connected && username != null) {
        print('Socket join-onConnect"$room" "$username"');
        socket.emit(
          'join',
          {'username': username, 'room': room, 'token': token},
        );
      }

      // final quizId = int.parse(quizRoom?.quizId ?? '');
      // fetchQuestions(quizId);
      // print('quizId $quizId');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Future<void> fetchQuestions(int quizId) async {
  //   try {
  //     final response = await QuizAPI.getAllQuestions(quizId);

  //     if (response.response != null) {
  //       questions = response.response!;
  //     } else {
  //       _errorMessage = response.error?.error.toString() ?? '';
  //     }
  //   } catch (e, s) {
  //     debugPrint(e.toString());
  //     debugPrint(s.toString());
  //     _errorMessage = e.toString();
  //   }

  //   notifyListeners();
  // }

  void sendAnswer(dynamic answer) {
    final quizRoom = this.quizRoom;
    if (quizRoom == null) {
      return;
    }

    print('${DateTime.now()} submit');
    _screenState = PlayScreenState.waiting;

    final qtype = currentQuestion?.qtype ?? '';

    Map<String, dynamic> answerLogData = {};

    switch (qtype) {
      case 'choice':
      case 'true/false':
        answerLogData['answer_id'] = answer;
        break;

      case 'matching':
      case 'draganddrop':
        answerLogData['answer'] = answer;
        break;

      case 'shortanswer':
        answerLogData['answer_text'] = answer;
        break;

      case 'numerical':
        answerLogData['answer_number'] = answer;
        break;

      default:
        answerLogData['answer'] = answer;
        break;
    }

    socket.emit('send', {
      'room': quizRoom.socketId,
      'new_quiz_id': quizRoom.id,
      'current_question_index': questionIndex,
      'answer_log_data': answerLogData,
    });

    notifyListeners();
  }

  void setUsername(String text) {
    _username = text;
    start();
    notifyListeners();
  }

  void stopAudio() {
    _audioPlayer.stop();
  }
}
