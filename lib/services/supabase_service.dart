import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/personagens.dart';

class SupabaseService {
  final SupabaseClient _supabaseClient;

  SupabaseService(this._supabaseClient);

  // Cadastrar novo personagem
  Future<Character> createCharacter(Character character) async {
    try {
      final response = await _supabaseClient
          .from('personagens')
          .insert(character.toJson())
          .select()
          .single();

      return Character.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao cadastrar personagem: $e');
    }
  }

  // Listar todos os personagens
  Future<List<Character>> getAllCharacters() async {
    try {
      final response = await _supabaseClient
          .from('personagens')
          .select('*')
          .order('data_registro', ascending: false);

      return (response as List)
          .map((item) => Character.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar personagens: $e');
    }
  }

  // Pesquisar personagens por nome
  Future<List<Character>> searchCharacters(String searchTerm) async {
    try {
      if (searchTerm.isEmpty) {
        return await getAllCharacters();
      }

      final response = await _supabaseClient
          .from('personagens')
          .select('*')
          .ilike('nome', '%$searchTerm%')
          .order('data_registro', ascending: false);

      return (response as List)
          .map((item) => Character.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Erro ao pesquisar personagens: $e');
    }
  }

  // Atualizar personagem
  Future<Character> updateCharacter(Character character) async {
    try {
      if (character.id == null) {
        throw Exception('ID do personagem não pode ser nulo');
      }

      final response = await _supabaseClient
          .from('personagens')
          .update(character.toJson())
          .eq('id', character.id!)
          .select()
          .single();

      return Character.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao atualizar personagem: $e');
    }
  }

  // Excluir personagem
  Future<void> deleteCharacter(int id) async {
    try {
      await _supabaseClient
          .from('personagens')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Erro ao excluir personagem: $e');
    }
  }

  // Estatísticas por série
  Future<Map<String, int>> getStatsBySeries() async {
    try {
      final response = await _supabaseClient
          .from('personagens')
          .select('serie');

      final seriesList = (response as List)
          .map((item) => item['serie'] as String)
          .toList();

      final Map<String, int> stats = {};
      for (String serie in seriesList) {
        stats[serie] = (stats[serie] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      throw Exception('Erro ao obter estatísticas: $e');
    }
  }

  // Total de personagens
  Future<int> getTotalCharacters() async {
    try {
      final response = await _supabaseClient
          .from('personagens')
          .select('id');

      return (response as List).length;
    } catch (e) {
      throw Exception('Erro ao contar personagens: $e');
    }
  }

  // Personagens por popularidade
  Future<List<Character>> getCharactersByPopularity() async {
    try {
      final response = await _supabaseClient
          .from('personagens')
          .select('*')
          .order('popularidade', ascending: false)
          .limit(10);

      return (response as List)
          .map((item) => Character.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar personagens por popularidade: $e');
    }
  }
}