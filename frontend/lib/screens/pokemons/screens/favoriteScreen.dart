import 'package:flutter/material.dart';
import '../../../controllers/pokemons/pokemon_favorite_controller.dart';
import '../widgets/custom_sliver_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/pokemons/theme_controller.dart';
import '../../../utils/pokemons/constants.dart' as constants;

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favoriteScreen';

  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Future<void> getFavPokemons() async {
    await Provider.of<PokemonFavoritesController>(context, listen: false)
        .getFavoritePokemonsData();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Provider.of<ThemeController>(context).themeData;
    bool isDark = themeData == ThemeData.dark();
    return Scaffold(
      backgroundColor: isDark
          ? constants.scaffoldDarkThemeColor
          : constants.scaffoldLightThemeColor,
      body: FutureBuilder(
        future: getFavPokemons(),
        builder: (_, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    color: constants.circularProgressIndicatorColor));
          } else {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('Favorite Pokemons'),
                  backgroundColor: isDark
                      ? constants.appBarDarkThemeColor
                      : constants.appBarLightThemeColor,
                ),
                const SliverPadding(
                  padding: EdgeInsets.all(constants.mediumPadding),
                  sliver: CustomSliverGridView(showFavorites: true),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
