import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/screens/quiz/quizscreens/resultScreen.dart';
import 'package:frontend/screens/watchCourseScreen.dart';
import 'package:frontend/controllers/data_sender_controller.dart';
import 'package:frontend/controllers/data_uploader_controller.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:frontend/models/quizzes/question_paper_model.dart';
import 'package:get/get.dart';

class QuestionsController extends GetxController {
  // DataUpLoader controller = Get.put(DataUpLoader());

  final questionIndex = 0.obs;
  bool get isFirstQuestion => questionIndex.value > 0;
  bool get isLastQuestion => questionIndex >= allQuestions.length - 1;
  late QuestionPaperModel questionPaperModel;
  List<Questions> allQuestions = <Questions>[];
  Rxn<Questions> currentQuestion = Rxn<Questions>();
  final loadingStatus = LoadingStatus.loading.obs;

  Timer? _timer;
  int remainSeconds = 1;
  final time = '00:00'.obs;

  @override
  void onReady() {
    //DataUpLoader controller = Get.put(DataUpLoader());
    loadingStatus.value = LoadingStatus.loading;
    // final _questionPaper =
    //     ModalRoute.of(Get.context)!.settings.arguments as QuestionPaperModel;
    final _questionPaper = Get.arguments as QuestionPaperModel;
    // final _questionPaper = controller.questionsData[0] as QuestionPaperModel;
    questionPaperModel = _questionPaper;
    allQuestions = _questionPaper.questions!;
    currentQuestion.value = _questionPaper.questions![0];
    _startTimer(_questionPaper.timeSeconds);
    print(_questionPaper.title);
    print(_questionPaper);
    loadingStatus.value = LoadingStatus.completed;
    super.onReady();
  }

  void selectedAnswer(String? answer) {
    currentQuestion.value!.selectedAnswer = answer;
    update([
      'answers_list'
    ]); //it will update the builder of QuestionController that has id of answers_list
  }

  String get completedTest {
    final answered = allQuestions
        .where((element) => element.selectedAnswer != null)
        .toList()
        .length;
    return '$answered out of ${allQuestions.length} answered';
  }

  void nextQuestion() {
    if (questionIndex.value >= allQuestions.length - 1) return;
    questionIndex.value++;
    currentQuestion.value = allQuestions[questionIndex.value];
  }

  void jumpToQuestion(int index, {bool isGoBack = true}) {
    questionIndex.value = index;
    currentQuestion.value = allQuestions[index];
    if (isGoBack) {
      Get.back();
    }
  }

  void prevQuestion() {
    if (questionIndex.value <= 0) {
      return;
    }
    questionIndex.value--;
    currentQuestion.value = allQuestions[questionIndex.value];
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainSeconds == 0) {
        timer.cancel();
      } else {
        int minutes = remainSeconds ~/ 60;
        int seconds = remainSeconds % 60;
        time.value = minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
        remainSeconds--;
      }
    });
  }

  void completeTest(userId, testId, numberOfHpPoints) async {
    _timer!.cancel();
    DataSenderController dataSenderController = Get.put(DataSenderController());
    var data = {
      "user_id": userId,
      "test_id": testId,
      "number_of_hp_points": numberOfHpPoints
    };
    await dataSenderController.sendTheUserResultsPerTest(
        "/users/testResults", data);
    Get.offAndToNamed(ResultScreen.routeName);
  }
}
