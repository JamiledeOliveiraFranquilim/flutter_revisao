//Jamile de Oliveira Franquilim e Geovanna Kaori Shimada

import 'package:flutter/material.dart';
import '../models/personagens.dart';

class DetalhesPersonagens extends StatelessWidget {
  final Character character;

  DetalhesPersonagens({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.nome),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhoto(),
                SizedBox(height: 20),
                _buildInfoRow(Icons.person, 'Nome', character.nome),
                _buildInfoRow(Icons.tv, 'Série', character.serie),
                _buildInfoRow(Icons.location_on, 'Localização', character.localizacao),
                _buildInfoRow(
                  Icons.calendar_today,
                  'Data do Registro',
                  character.dataRegistro.toString(),
                ),
                if (character.carisma != null)
                  _buildInfoRow(
                    Icons.emoji_events,
                    'Carisma',
                    '${character.carisma}/10',
                  ),
                if (character.popularidade != null)
                  _buildInfoRow(
                    Icons.star,
                    'Popularidade',
                    '${character.popularidade}/10',
                  ),
                if (character.habilidade != null)
                  _buildInfoRow(
                    Icons.flash_on,
                    'Habilidade Especial',
                    character.habilidade!,
                  ),
                if (character.observacoes != null)
                  _buildInfoRow(
                    Icons.note,
                    'Observações',
                    character.observacoes!,
                  ),
                if (character.foto != null)
                  _buildInfoRow(
                    Icons.link,
                    'Foto',
                    character.foto!,
                    isLink: true,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    if (character.foto == null) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.person,
          size: 80,
          color: Colors.grey.shade400,
        ),
      );
    }

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(character.foto!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade700),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: isLink ? Colors.blue.shade700 : Colors.black87,
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}