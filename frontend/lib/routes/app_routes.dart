import 'package:frontend/Screens/home.dart';
import 'package:frontend/Screens/pokemons/screens/favoriteScreen.dart';
import 'package:frontend/Screens/pokemons/screens/pokemonDetailScreen.dart';
import 'package:frontend/Screens/pokemons/screens/pokemonsHomeScreen.dart';
import 'package:frontend/Screens/pokemons/screens/searchScreen.dart';
import 'package:frontend/Screens/pokemons/screens/settings_screen.dart';
import 'package:frontend/Screens/quiz/quizscreens/resultScreen.dart';
import 'package:frontend/Screens/quiz/quizscreens/testOverviewScreen.dart';
import 'package:frontend/Screens/quiz/quizscreens/testScreen.dart';
import 'package:frontend/Screens/watchCourseScreen.dart';
import 'package:frontend/controllers/pokemons/pokemon_about_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_basic_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_favorite_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_more_info_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_stat_controller.dart';
import 'package:frontend/controllers/pokemons/search_controller.dart';
import 'package:frontend/controllers/pokemons/theme_controller.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:get/get.dart';

import '../Screens/quiz/quizscreens/answerCheckScreen.dart';


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
          page: () => const TestOverviewScreen(),
          binding: BindingsBuilder(() {
            Get.put<QuestionsController>(QuestionsController());
          }),
        ),
        GetPage(
          name: ResultScreen.routeName,
          page: () => const ResultScreen(),
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
