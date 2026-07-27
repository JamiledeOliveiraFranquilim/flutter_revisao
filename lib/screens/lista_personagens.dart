import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/personagens.dart';
import '../services/supabase_service.dart';
import '../widgets/personagem_card.dart';
import 'pesquisa_personagem.dart';
import 'detalhes_personagens.dart';
import 'cadastro_personagem.dart';

class PersonagemLista extends StatefulWidget {
  @override
  _PersonagemListaState createState() => _PersonagemListaState();
}

class _PersonagemListaState extends State<PersonagemLista> {
  final SupabaseService _supabaseService = SupabaseService(Supabase.instance.client);
  List<Character> _characters = [];
  List<Character> _filteredCharacters = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  // Carregar todos os personagens
  Future<void> _loadCharacters() async {
    setState(() {
      _isLoading = true;
      _isSearching = false;
    });
    
    try {
      final characters = await _supabaseService.getAllCharacters();
      setState(() {
        _characters = characters;
        _filteredCharacters = characters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Erro ao carregar personagens: $e', Colors.red);
    }
  }

  // Pesquisar personagens
  void _searchCharacters(String query) async {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });

    try {
      final results = await _supabaseService.searchCharacters(query);
      setState(() {
        _filteredCharacters = results;
      });
    } catch (e) {
      _showSnackBar('Erro ao pesquisar: $e', Colors.red);
    }
  }

  // Método para editar personagem
  void _editarPersonagem(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroPersonagemPage(
          character: character, // Passa o personagem para edição
        ),
      ),
    ).then((_) => _loadCharacters()); // Recarrega após editar
  }

  // Excluir personagem
  Future<void> _deleteCharacter(Character character) async {
    if (character.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tem certeza que deseja excluir o personagem:'),
            SizedBox(height: 8),
            Text(
              '"${character.nome}"',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Esta ação não pode ser desfeita!',
              style: TextStyle(color: Colors.red.shade700, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _supabaseService.deleteCharacter(character.id!);
        await _loadCharacters();
        _showSnackBar('Personagem excluído com sucesso!', Colors.green);
      } catch (e) {
        _showSnackBar('Erro ao excluir: $e', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personagens Encontrados',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          // Botão de recarregar
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadCharacters,
            tooltip: 'Recarregar',
          ),
          // Contador de personagens
          if (!_isLoading)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Chip(
                  label: Text(
                    '${_filteredCharacters.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          _buildSearchBar(),
          // Conteúdo principal
          Expanded(child: _buildContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroPersonagemPage(), // Cadastro novo
            ),
          ).then((_) => _loadCharacters());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green.shade700,
        tooltip: 'Adicionar novo personagem',
      ),
    );
  }

  // Barra de pesquisa personalizada
  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: '🔍 Pesquisar por nome do personagem...',
          prefixIcon: Icon(Icons.search, color: Colors.green.shade700),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchCharacters('');
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: _searchCharacters,
        controller: TextEditingController(text: _searchQuery),
      ),
    );
  }

  // Conteúdo principal da lista
  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_filteredCharacters.isEmpty) {
      return _buildEmptyState();
    }

    return _buildCharacterList();
  }

  // Estado de carregamento
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
          ),
          SizedBox(height: 16),
          Text(
            'Carregando personagens...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Estado vazio
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty ? Icons.search_off : Icons.people_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'Nenhum personagem encontrado para "$_searchQuery"'
                : 'Nenhum personagem cadastrado ainda',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          if (_searchQuery.isNotEmpty)
            TextButton(
              onPressed: () => _searchCharacters(''),
              child: Text('Limpar pesquisa'),
            ),
          if (!_searchQuery.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastroPersonagemPage(),
                  ),
                ).then((_) => _loadCharacters());
              },
              icon: Icon(Icons.add),
              label: Text('Cadastrar primeiro personagem'),
            ),
        ],
      ),
    );
  }

  // Lista de personagens
  Widget _buildCharacterList() {
    return RefreshIndicator(
      onRefresh: _loadCharacters,
      color: Colors.green.shade700,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _filteredCharacters.length,
        itemBuilder: (context, index) {
          final character = _filteredCharacters[index];
          return PersonagemCard(
            character: character,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesPersonagens(character: character),
                ),
              );
            },
            onDelete: () => _deleteCharacter(character),
            onEdit: () => _editarPersonagem(character), // <-- ADICIONE ESTA LINHA
          );
        },
      ),
    );
  }
}