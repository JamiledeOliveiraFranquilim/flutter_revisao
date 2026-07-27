// Jamile de Oliveira Franquilim e Geovanna Kaori Shimada
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/personagens.dart';

class CadastroPersonagemPage extends StatefulWidget {
  final Character? character; // Se for null, é cadastro novo

  const CadastroPersonagemPage({super.key, this.character});

  @override
  State<CadastroPersonagemPage> createState() =>
      _CadastroPersonagemPageState();
}

class _CadastroPersonagemPageState extends State<CadastroPersonagemPage> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final localizacaoController = TextEditingController();
  final observacoesController = TextEditingController();

  String? serie;
  double carisma = 5;
  bool carregando = false;
  bool isEditing = false;

  final List<String> series = [
    "Drama",
    "Comédia",
    "Fantasia",
    "Ficção Científica",
    "Ação",
    "Terror",
    "Suspense",
    "Animação"
  ];

  @override
  void initState() {
    super.initState();
    // Verifica se é edição
    if (widget.character != null) {
      isEditing = true;
      _preencherCampos();
    }
  }

  // Método para preencher os campos com os dados do personagem
  void _preencherCampos() {
    final c = widget.character!;
    nomeController.text = c.nome;
    serie = c.serie;
    localizacaoController.text = c.localizacao;
    carisma = (c.carisma ?? 5).toDouble();
    observacoesController.text = c.observacoes ?? '';
  }

  // Método para cadastrar ou atualizar
  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => carregando = true);

    try {
      final dados = {
        'nome': nomeController.text.trim(),
        'serie': serie,
        'localizacao': localizacaoController.text.trim(),
        'carisma': carisma.toInt(),
        'observacoes': observacoesController.text.trim(),
      };

      if (isEditing) {
        // Atualizar personagem existente
        await supabase
            .from('personagens')
            .update(dados);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Personagem atualizado com sucesso!"),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        // Cadastrar novo personagem
        await supabase.from('personagens').insert(dados);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Personagem cadastrado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );

        // Limpar campos após cadastro
        _limparCampos();
      }

      // Retornar para a tela anterior com sucesso
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => carregando = false);
  }

  // Método para limpar os campos
  void _limparCampos() {
    nomeController.clear();
    localizacaoController.clear();
    observacoesController.clear();
    setState(() {
      serie = null;
      carisma = 5;
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    localizacaoController.dispose();
    observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Editar Personagem" : "Cadastrar Personagem",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isEditing ? Colors.blue.shade700 : Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          if (isEditing)
            TextButton(
              onPressed: () {
                // Resetar para valores originais
                if (widget.character != null) {
                  _preencherCampos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Campos resetados!"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text(
                'Resetar',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Ícone
                  Icon(
                    isEditing
                        ? Icons.edit_note_outlined
                        : Icons.movie_creation_outlined,
                    size: 70,
                    color: isEditing ? Colors.blue.shade700 : Colors.deepPurple,
                  ),

                  const SizedBox(height: 10),

                  // Título
                  Text(
                    isEditing ? "Editando Personagem" : "Personagem Perdido",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // ID do personagem (se estiver editando)
                  if (isEditing) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        'ID: ${widget.character?.id ?? 'N/A'}',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),

                  // Campo Nome
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome do Personagem *",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Informe o nome do personagem";
                      }
                      if (value.trim().length < 2) {
                        return "Nome deve ter pelo menos 2 caracteres";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Dropdown Série
                  DropdownButtonFormField<String>(
                    value: serie,
                    decoration: const InputDecoration(
                      labelText: "Gênero da Série *",
                      prefixIcon: Icon(Icons.tv),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: series.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        serie = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Selecione um gênero" : null,
                  ),

                  const SizedBox(height: 20),

                  // Campo Localização
                  TextFormField(
                    controller: localizacaoController,
                    decoration: const InputDecoration(
                      labelText: "Local Encontrado *",
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Informe o local onde foi encontrado";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  // Slider Carisma
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Carisma:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          carisma.toInt().toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Slider(
                    min: 0,
                    max: 10,
                    divisions: 10,
                    value: carisma,
                    label: carisma.toInt().toString(),
                    activeColor: Colors.amber.shade700,
                    onChanged: (value) {
                      setState(() {
                        carisma = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Campo Observações
                  TextFormField(
                    controller: observacoesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: "Observações",
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Comportamento, condição, detalhes importantes...",
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Botões de ação
                  Row(
                    children: [
                      // Botão Cancelar
                      Expanded(
                        flex: 1,
                        child: OutlinedButton.icon(
                          onPressed: carregando
                              ? null
                              : () => Navigator.pop(context, false),
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancelar'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Botão Salvar/Cadastrar
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: carregando ? null : _salvar,
                          icon: carregando
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(isEditing ? Icons.save : Icons.add),
                          label: Text(
                            carregando
                                ? "Salvando..."
                                : isEditing
                                    ? "ATUALIZAR"
                                    : "CADASTRAR",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isEditing ? Colors.blue.shade700 : Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Informação extra para edição
                  if (isEditing) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Editando um personagem existente. '
                              'Clique em "Atualizar" para salvar as alterações.',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}