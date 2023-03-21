import 'package:frontend/Screens/resultScreen.dart';
import 'package:frontend/Screens/testOverviewScreen.dart';
import 'package:frontend/Screens/quizScreen.dart';
import 'package:frontend/Screens/splashScreen.dart';
import 'package:frontend/Screens/testScreen.dart';
import 'package:frontend/Screens/watchCourseScreen.dart';
import 'package:frontend/controllers/question_paper/data_uploader.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:get/get.dart';

import '../Screens/answerCheckScreen.dart';

class AppRoutes {
  static List<GetPage> routes() => [
        GetPage(
            name: QuizScreen.routeName,
            page: () => const QuizScreen(),
            binding: BindingsBuilder(() {
              Get.put(QuestionsController());
              Get.put(DataUpLoader());
            })),
        GetPage(
            name: WatchCourse.routeName,
            page: () => const WatchCourse(),
            binding: BindingsBuilder(() {})),
        GetPage(
            name: TestScreen.routeName,
            page: () => const TestScreen(),
            binding: BindingsBuilder(() {
              Get.put(QuestionsController());
            })),
        GetPage(
            name: TestOverviewScreen.routeName,
            page: () => const TestOverviewScreen(),
            binding: BindingsBuilder(() {
              Get.put(QuestionsController());
            })),
        GetPage(
            name: ResultScreen.routeName,
            page: () => const ResultScreen(),
            binding: BindingsBuilder(() {
              Get.put(QuestionsController());
            })),
        GetPage(
            name: AnswerCheckScreen.routeName,
            page: () => const AnswerCheckScreen(),
            binding: BindingsBuilder(() {
              Get.put(QuestionsController());
            }))
      ];
}
