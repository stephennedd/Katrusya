import 'package:flutter/material.dart';
import 'package:frontend/Screens/homeScreen.dart';
import 'package:frontend/Screens/homescreens/Featured.dart';
import 'package:frontend/Screens/homescreens/MyCourses.dart';
import 'package:frontend/Screens/landingPage.dart';
import 'package:frontend/Screens/pokemons/screens/favoriteScreen.dart';
import 'package:frontend/Screens/pokemons/screens/pokemonDetailScreen.dart';
import 'package:frontend/Screens/pokemons/screens/pokemonsHomeScreen.dart';
import 'package:frontend/Screens/pokemons/screens/searchScreen.dart';
import 'package:frontend/Screens/pokemons/screens/settings_screen.dart';
import 'package:frontend/Screens/quiz/quizscreens/answerCheckScreen.dart';
import 'package:frontend/Screens/quiz/quizscreens/resultScreen.dart';
import 'package:frontend/Screens/quiz/quizscreens/testOverviewScreen.dart';
import 'package:frontend/Screens/splashScreen.dart';
import 'package:frontend/Screens/quiz/quizscreens/testScreen.dart';
import 'package:frontend/Screens/watchCourseScreen.dart';
import 'package:frontend/bindings/initial_bindings.dart';
import 'package:frontend/controllers/pokemons/pokemon_about_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_basic_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_favorite_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_more_info_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_stat_controller.dart';
import 'package:frontend/controllers/pokemons/search_controller.dart';
import 'package:frontend/controllers/pokemons/theme_controller.dart';
import 'package:frontend/controllers/question_paper/data_uploader.dart';
import 'package:frontend/controllers/question_paper/questions_controller.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(GetMaterialApp(
    getPages: AppRoutes.routes(),
    home: const MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PokemonBasicDataController()),
        ChangeNotifierProvider(create: (_) => PokemonAboutDataController()),
        ChangeNotifierProvider(create: (_) => PokemonMoreInfoController()),
        ChangeNotifierProvider(create: (_) => PokemonStatsController()),
        ChangeNotifierProvider(create: (_) => PokemonFavoritesController()),
        ChangeNotifierProvider(create: (_) => SearchPokemonsController()),
        ChangeNotifierProvider(create: (_) => ThemeController(false)),
      ],
      child: Consumer<ThemeController>(builder: (context, provider, ch) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: provider.themeData,
          title: 'Flutter Demo',
          initialRoute: PokemonHomeScreen.routeName,
          routes: {
            PokemonHomeScreen.routeName: (context) => const PokemonHomeScreen(),
            PokemonDetailScreen.routeName: (context) =>
                const PokemonDetailScreen(),
            SettingsScreen.routeName: (context) => const SettingsScreen(),
            FavoriteScreen.routeName: (context) => const FavoriteScreen(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            WatchCourse.routeName: (context) => const WatchCourse(),
          },
        );
      }),
    );
  }
}

// void main() {
//   runApp(MyApp());
// }

// class InitialBindings extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(PokemonBasicDataController());
//     Get.put(PokemonAboutDataController());
//     Get.put(PokemonMoreInfoController());
//     Get.put(PokemonStatsController());
//     Get.put(PokemonFavoritesController());
//     Get.put(SearchPokemonsController());
//     Get.put(ThemeController(false));
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const PokemonHomeScreen(),
//       initialBinding: InitialBindings(),
//       title: 'Flutter Demo',
//       // theme: ThemeController.to.themeData,
//       getPages: [
//         GetPage(name: '/', page: () => const PokemonHomeScreen()),
//         GetPage(
//             name: PokemonDetailScreen.routeName,
//             page: () => const PokemonDetailScreen()),
//         GetPage(
//             name: SettingsScreen.routeName, page: () => const SettingsScreen()),
//         GetPage(
//             name: FavoriteScreen.routeName, page: () => const FavoriteScreen()),
//         GetPage(name: SearchScreen.routeName, page: () => const SearchScreen()),
//         GetPage(name: Feautured.routeName, page: () => const Feautured()),
//         GetPage(name: WatchCourse.routeName, page: () => const WatchCourse()),
//         GetPage(
//             name: TestScreen.routeName,
//             page: () => const TestScreen(),
//             binding: BindingsBuilder(() {
//               Get.put(QuestionsController());
//             })),
//         GetPage(
//             name: TestOverviewScreen.routeName,
//             page: () => const TestOverviewScreen(),
//             binding: BindingsBuilder(() {
//               Get.put(QuestionsController());
//             })),
//         GetPage(
//             name: AnswerCheckScreen.routeName,
//             page: () => const AnswerCheckScreen()),
//         GetPage(name: ResultScreen.routeName, page: () => const ResultScreen()),
//       ],
//     );
//   }
//}
