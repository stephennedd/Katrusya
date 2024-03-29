import 'package:flutter/material.dart';
import 'package:frontend/Screens/start.dart';
import 'package:frontend/screens/account.dart';
import 'package:frontend/screens/favorites.dart';
import 'package:frontend/screens/forgot_password.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/my_courses.dart';
import 'package:frontend/screens/pokemons/screens/favoriteScreen.dart';
import 'package:frontend/screens/pokemons/screens/pokemonDetailScreen.dart';
import 'package:frontend/screens/pokemons/screens/pokemonsHomeScreen.dart';
import 'package:frontend/screens/pokemons/screens/searchScreen.dart';
import 'package:frontend/screens/pokemons/screens/settings_screen.dart';
import 'package:frontend/screens/quiz/quizscreens/resultScreen.dart';
import 'package:frontend/screens/root_app.dart';
import 'package:frontend/screens/section.dart';
import 'package:frontend/screens/signup.dart';
import 'package:frontend/screens/quiz/quizscreens/testScreen.dart';
import 'package:frontend/screens/teacher_dashboard.dart';
import 'package:frontend/screens/watchCourseScreen.dart';
import 'package:frontend/controllers/pokemons/pokemon_about_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_basic_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_favorite_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_more_info_controller.dart';
import 'package:frontend/controllers/pokemons/pokemon_stat_controller.dart';
import 'package:frontend/controllers/pokemons/search_controller.dart';
import 'package:frontend/controllers/pokemons/theme_controller.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/services/bottom_bar_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  runApp(GetMaterialApp(
    getPages: AppRoutes.routes(),
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final bottomBarProvider = BottomBarProvider();

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
        return ChangeNotifierProvider.value(
          value: bottomBarProvider,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: provider.themeData,
            title: 'Katrusya App',
            initialRoute: StartPage.routeName,
            //RootApp.routeName,
            home: const RootApp(),
            routes: {
              PokemonHomeScreen.routeName: (context) =>
                  const PokemonHomeScreen(),
              PokemonDetailScreen.routeName: (context) =>
                  const PokemonDetailScreen(),
              SettingsScreen.routeName: (context) => const SettingsScreen(),
              FavoriteScreen.routeName: (context) => const FavoriteScreen(),
              SearchScreen.routeName: (context) => const SearchScreen(),
              WatchCourse.routeName: (context) => const WatchCourse(),
              RootApp.routeName: (context) => const RootApp(),
              HomePage.routeName: (context) => const HomePage(),
              LoginPage.routeName: (context) => const LoginPage(),
              StartPage.routeName: (context) => const StartPage(),
              SignupPage.routeName: (context) => const SignupPage(),
              ForgotPage.routeName: (context) => const ForgotPage(),
              SectionPage.routeName: (context) => const SectionPage(),
              TestScreen.routeName: (context) => const TestScreen(),
              ResultScreen.routeName: (context) => ResultScreen(),
              MyCoursesPage.routeName: (context) => const MyCoursesPage(),
              FavoritesPage.routeName: (context) => const FavoritesPage(),
              AccountPage.routeName: (context) => const AccountPage(),
              DashboardPage.routeName: (context) => const DashboardPage()
            },
          ),
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
