import 'package:flutter/material.dart';
import '../widgets/search_widgets/search_widget.dart';
import '../../../utils/pokemons/constants.dart' as constants;
import 'package:provider/provider.dart';

import '../../../controllers/pokemons/theme_controller.dart';

class SearchScreen extends StatelessWidget {
  static const String routeName = '/searchScreen';
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Provider.of<ThemeController>(context).themeData;
    bool isDark = themeData == ThemeData.dark();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? constants.appBarDarkThemeColor
            : constants.appBarLightThemeColor,
        title: const Text('Search Pokemons'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(constants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Search Pokemons By:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isDark
                          ? constants.chooseFilterTextDarkThemeColor
                          : constants.chooseFilterTextLightThemeColor,
                    )),
            const SizedBox(height: constants.mediumPadding),
            const SearchWidget(),
          ],
        ),
      ),
    );
  }
}
