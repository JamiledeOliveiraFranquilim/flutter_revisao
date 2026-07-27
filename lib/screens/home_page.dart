//Jamile de Oliveira Franquilim e Geovanna Kaori Shimada

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'lista_personagens.dart';
import 'cadastro_personagem.dart';
import 'estatistica.dart';

class HomeScreen extends StatelessWidget {
  final SupabaseService _supabaseService = SupabaseService(Supabase.instance.client);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personagens Perdidos de Caçapava'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 80,
                  color: Colors.blue.shade700,
                ),
                SizedBox(height: 16),
                Text(
                  'Bem-vindo ao Sistema de Registro de Personagens Perdidos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ajude os cidadãos de Caçapava a encontrar esses personagens misteriosos!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 40),
                _buildOptionCard(
                  context,
                  '📋 Listar Personagens',
                  'Veja todos os personagens encontrados',
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PersonagemLista()),
                  ),
                ),
                SizedBox(height: 16),
                _buildOptionCard(
                  context,
                  '➕ Novo Cadastro',
                  'Registre um novo personagem encontrado',
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroPersonagemPage()),
                  ),
                ),
                SizedBox(height: 16),
                _buildOptionCard(
                  context,
                  '📊 Estatísticas',
                  'Veja análise dos personagens encontrados',
                  Colors.purple,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatisticsScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  title.split(' ')[0],
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}