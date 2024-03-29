import 'dart:async';

import 'package:frontend/api/my_api.dart';
import 'package:frontend/controllers/marketplace/courses/course_controller.dart';
import 'package:frontend/models/loading_status_model.dart';
import 'package:frontend/models/quizzes/question_paper_model.dart';
import 'package:get/get.dart';

class QuestionsController extends GetxController {
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

  CourseController courseController = Get.put(CourseController());

  @override
  void onReady() async {
    // loadingStatus.value = LoadingStatus.loading;
    // questionPaperModel =
    //     await getTestsBasedOnSectionId(courseController.currentSectionId.value);
    // allQuestions = questionPaperModel.questions!;
    // currentQuestion.value = questionPaperModel.questions![0];
    // _startTimer(questionPaperModel.timeSeconds);
    // loadingStatus.value = LoadingStatus.completed;
    super.onReady();
  }

  Future<dynamic> startUpQuiz() async {
    loadingStatus.value = LoadingStatus.loading;
    questionPaperModel =
        await getTestsBasedOnSectionId(courseController.currentSectionId.value);
    allQuestions = questionPaperModel.questions!;
    currentQuestion.value = questionPaperModel.questions![0];
    _startTimer(questionPaperModel.timeSeconds);
    loadingStatus.value = LoadingStatus.completed;
  }

  Future<QuestionPaperModel> getTestsBasedOnSectionId(sectionId) async {
    loadingStatus.value = LoadingStatus.loading;
    QuestionPaperModel test =
        await CallApi().getTestBasedOnSectionId(sectionId);
    questionPaperModel = test;
    loadingStatus.value = LoadingStatus.completed;
    return test;
  }

  Future<void> sendTheUserResultsPerTest(apiUrl, data) async {
    await CallApi().addUserResultsPerTest(apiUrl, data);
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
        time.value = "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        remainSeconds--;
      }
    });
  }

  void completeTest(userId, testId, numberOfHpPoints) async {
    _timer!.cancel();
    var data = {
      "user_id": userId,
      "test_id": testId,
      "number_of_hp_points": numberOfHpPoints
    };
    await sendTheUserResultsPerTest("/users/testResults", data);
    //Get.offAndToNamed(ResultScreen.routeName);
  }

  void reset() {
    questionIndex.value = 0;
    allQuestions = <Questions>[];
    currentQuestion.value = null;
    loadingStatus.value = LoadingStatus.loading;
    _timer?.cancel();
    remainSeconds = 1;
    time.value = '00:00';
  }
}
