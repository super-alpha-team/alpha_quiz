import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alpha_quiz/alpha_quiz.dart';

void main() {
  const MethodChannel channel = MethodChannel('alpha_quiz');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

}
