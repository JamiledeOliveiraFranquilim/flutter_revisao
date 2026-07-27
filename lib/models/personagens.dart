//Jamile de Oliveira Franquilim e Geovanna Kaori Shimada

class Character {
  final int? id;
  final String nome;
  final String serie;
  final String localizacao;
  final DateTime dataRegistro;
  final int? carisma;
  final int? popularidade;
  final String? habilidade;
  final String? observacoes;
  final String? foto;

  Character({
    this.id,
    required this.nome,
    required this.serie,
    required this.localizacao,
    required this.dataRegistro,
    this.carisma,
    this.popularidade,
    this.habilidade,
    this.observacoes,
    this.foto,
  });

  // Criar a partir de JSON do Supabase
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int?,
      nome: json['nome'] as String,
      serie: json['serie'] as String,
      localizacao: json['localizacao'] as String,
      dataRegistro: DateTime.parse(json['data_registro'] as String),
      carisma: json['carisma'] as int?,
      popularidade: json['popularidade'] as int?,
      habilidade: json['habilidade'] as String?,
      observacoes: json['observacoes'] as String?,
      foto: json['foto'] as String?,
    );
  }

  // Converter para JSON para enviar ao Supabase
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'serie': serie,
      'localizacao': localizacao,
      'data_registro': dataRegistro.toIso8601String().split('T')[0], // Formato YYYY-MM-DD
      'carisma': carisma,
      'popularidade': popularidade,
      'habilidade': habilidade,
      'observacoes': observacoes,
      'foto': foto,
    };
  }
}