//Jamile de Oliveira Franquilim e Geovanna Kaori Shimada
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroPersonagemPage extends StatefulWidget {
  const CadastroPersonagemPage({super.key});

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

  Future<void> cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => carregando = true);

    try {
      await supabase.from('personagens').insert({
        'nome': nomeController.text.trim(),
        'serie': serie,
        'localizacao': localizacaoController.text.trim(),
        'carisma': carisma.toInt(),
        'observacoes': observacoesController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Personagem cadastrado com sucesso!"),
        ),
      );

      nomeController.clear();
      localizacaoController.clear();
      observacoesController.clear();

      setState(() {
        serie = null;
        carisma = 5;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }

    setState(() => carregando = false);
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
        title: const Text("Cadastrar Personagem"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  const Icon(
                    Icons.movie_creation_outlined,
                    size: 70,
                    color: Colors.deepPurple,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Personagem Perdido",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Informe o nome";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: serie,
                    decoration: const InputDecoration(
                      labelText: "Gênero da série",
                      prefixIcon: Icon(Icons.tv),
                    ),
                    items: series
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        serie = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Selecione um gênero" : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: localizacaoController,
                    decoration: const InputDecoration(
                      labelText: "Local encontrado",
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Informe o local";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Carisma: ${carisma.toInt()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Slider(
                    min: 0,
                    max: 10,
                    divisions: 10,
                    value: carisma,
                    label: carisma.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        carisma = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: observacoesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: "Observações",
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: carregando ? null : cadastrar,
                      icon: carregando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        carregando
                            ? "Salvando..."
                            : "Cadastrar Personagem",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
