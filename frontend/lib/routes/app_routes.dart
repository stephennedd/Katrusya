import 'package:frontend/screens/quiz/quizscreens/resultScreen.dart';
import 'package:frontend/screens/quiz/quizscreens/testOverviewScreen.dart';
import 'package:frontend/screens/quiz/quizscreens/testScreen.dart';
import 'package:frontend/screens/watchCourseScreen.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:get/get.dart';

import '../screens/quiz/quizscreens/answerCheckScreen.dart';

class AppRoutes {
  static List<GetPage> routes() => [
        GetPage(
          name: WatchCourse.routeName,
          page: () => const WatchCourse(),
          binding: BindingsBuilder(() {}),
        ),
        GetPage(
          name: TestScreen.routeName,
          page: () => const TestScreen(),
          binding: BindingsBuilder(() {
            Get.put<QuestionsController>(QuestionsController());
          }),
        ),
        GetPage(
          name: TestOverviewScreen.routeName,
          page: () => TestOverviewScreen(),
          binding: BindingsBuilder(() {
            Get.put<QuestionsController>(QuestionsController());
          }),
        ),
        GetPage(
          name: ResultScreen.routeName,
          page: () => ResultScreen(),
          binding: BindingsBuilder(() {
            Get.put<QuestionsController>(QuestionsController());
          }),
        ),
        GetPage(
          name: AnswerCheckScreen.routeName,
          page: () => const AnswerCheckScreen(),
          binding: BindingsBuilder(() {
            Get.put<QuestionsController>(QuestionsController());
          }),
        ),
      ];
}
