//Jamile de Oliveira Franquilim e Geovanna Kaori Shimada

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/personagens.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CharacterCard({
    Key? key,
    required this.character,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              _buildAvatar(),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            character.nome,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusBadge(),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.tv, size: 14, color: Colors.grey.shade600),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            character.serie,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            character.localizacao,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy').format(character.dataRegistro),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (character.popularidade != null)
                          _buildTag(
                            '⭐ ${character.popularidade}/10',
                            Colors.amber.shade100,
                            Colors.amber.shade800,
                          ),
                        if (character.carisma != null)
                          _buildTag(
                            '🎯 ${character.carisma}/10',
                            Colors.blue.shade100,
                            Colors.blue.shade800,
                          ),
                        if (character.habilidade != null)
                          _buildTag(
                            '⚡ ${character.habilidade!}',
                            Colors.purple.shade100,
                            Colors.purple.shade800,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue.shade700),
                      onPressed: onEdit,
                      tooltip: 'Editar',
                      iconSize: 20,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade700),
                      onPressed: onDelete,
                      tooltip: 'Excluir',
                      iconSize: 20,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (character.foto != null && character.foto!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.green.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(character.foto!),
          onBackgroundImageError: (_, __) {},
          child: Icon(Icons.person, size: 32, color: Colors.grey.shade400),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.green.shade200,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.green.shade100,
        child: Text(
          character.nome.isNotEmpty ? character.nome[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    if (character.popularidade != null && character.popularidade! >= 8) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade400, Colors.amber.shade600],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.white, size: 12),
            SizedBox(width: 2),
            Text(
              'Destaque',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    if (character.popularidade != null && character.popularidade! >= 5) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Popular',
          style: TextStyle(
            color: Colors.green.shade700,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}