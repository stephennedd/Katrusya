import 'package:flutter/material.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/homescreens/Featured.dart';
import 'package:frontend/screens/root_app.dart';
import 'package:frontend/screens/watchCourseScreen.dart';
import '../../../controllers/pokemons/pokemon_basic_controller.dart';
import '../../../controllers/pokemons/pokemon_favorite_controller.dart';
import '../../../utils/pokemons/colors_generator.dart';
import '../../../utils/pokemons/constants.dart' as constants;
import '../../../models/pokemons/pokemon_basic_data.dart';
import 'package:provider/provider.dart';
import '../../../controllers/pokemons/theme_controller.dart';
import '../widgets/white_sheet_widgets/white_sheet_widget.dart';

class PokemonDetailScreen extends StatefulWidget {
  static const String routeName = '/pokemonDetailScreen';

  const PokemonDetailScreen({Key? key}) : super(key: key);

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late PokemonBasicData pokemon;
  late Color cardColor;
  late String imageUrl;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Provider.of<ThemeController>(context).themeData;
    bool isDark = themeData == ThemeData.dark();
    bool isFavorite = false;

    Future<void> checkFavorite(String name) async {
      isFavorite = await Provider.of<PokemonFavoritesController>(context)
          .isPokemonFavorite(name);
    }

    final Map<String, dynamic> data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    cardColor = data['color'];
    pokemon = data['pokemon'];
    imageUrl = data['imageUrl'];

    // get screen height and width
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(body: Consumer<PokemonBasicDataController>(
      builder: (ctx, provider, ch) {
        return Container(
            // padding: EdgeInsets.only(top: constants.mediumPadding, right: constants.mediumPadding),
            color: cardColor,
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                // get status bar height and top screen padding
                SizedBox(
                    height: MediaQuery.of(context).viewPadding.top +
                        constants.screenTopPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new_rounded,
                            color: isDark
                                ? constants.backIconDarkThemeColor
                                : constants.backIconLightThemeColor,
                            size: constants.detailScreenIconSize)),
                    Text(pokemon.name,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? constants.pokemonNameDarkThemeColor
                                : constants.pokemonNameTitleLightThemeColor)),
                    FutureBuilder(
                        future: checkFavorite(pokemon.name),
                        builder: (context, dataSnapShot) {
                          return IconButton(
                              padding: const EdgeInsets.only(
                                  right: constants.mediumPadding),
                              onPressed: () async {
                                await Provider.of<PokemonFavoritesController>(
                                        context,
                                        listen: false)
                                    .toggleFavoritePokemon(pokemon.name);
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: isFavorite ? Colors.pink : Colors.white,
                                size: constants.detailScreenIconSize,
                              ));
                        }),
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child:
                            WhiteSheetWidget(pokemon: pokemon, isDark: isDark),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.35,
                            width: screenWidth,
                            child: Hero(
                              tag: pokemon.name,
                              child: Image(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    //  .pushNamed(WatchCourse.routeName);
                                    .pushNamed(RootApp.routeName);
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(120, 40)),
                                // You can adjust the width and height of the button by changing the values in Size
                              ),
                              child: Text('Select'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    ));
  }
}
