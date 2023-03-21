import 'package:flutter/material.dart';
import '../../models/pokemons/pokemon_basic_data.dart';
import '../../Services/pokemons/pokemon_stats_service.dart';

import '../../models/pokemons/pokemon_stats_data.dart';

class PokemonStatsController with ChangeNotifier {
  final pokemonStatsService = PokemonStatsService();

  Future<void> getPokemonStats(PokemonBasicData pokemon) async {
    final response = await pokemonStatsService.fetchPokemonStats(pokemon);
    // add pokemon detail model to pokemon basic info model
    final PokemonStatsData pokemonStatsData = PokemonStatsData(
      hp: response['hp'],
      attack: response['attack'],
      defense: response['defence'],
      specialAttack: response['specialAttack'],
      specialDefence: response['specialDefence'],
      speed: response['speed'],
    );
    pokemon.pokemonStatsData = pokemonStatsData;
  }
}
