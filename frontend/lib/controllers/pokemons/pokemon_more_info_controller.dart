import 'package:flutter/material.dart';
import '../../models/pokemons/pokemon_basic_data.dart';
import '../../Services/pokemons/pokemon_more_info_service.dart';

import '../../models/pokemons/pokemon_more_info_data.dart';

class PokemonMoreInfoController with ChangeNotifier {
  // create an instance of the pokemonMoreInfo class
  final pokemonAboutDataService = PokemonMoreInfoService();

  Future<void> getPokemonMoreInfoData(PokemonBasicData pokemon) async {
    final response =
        await pokemonAboutDataService.fetchPokemonMoreIndoData(pokemon);

    PokemonMoreInfoData pokemonDetailedInfo = PokemonMoreInfoData(
      height: response['height'],
      weight: response['weight'],
      abilities: response['abilities'],
      types: response['types'],
      moves: response['moves'],
    );
    // add pokemon detail model to pokemon basic info model
    pokemon.pokemonMoreInfoData = pokemonDetailedInfo;
  }
}
