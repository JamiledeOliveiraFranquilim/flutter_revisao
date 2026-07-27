//Jamile de Oliveira Franquilim e Geovanna Kaori Shimada
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PesquisaPersonagensPage extends StatefulWidget {
  const PesquisaPersonagensPage({super.key});

  @override
  State<PesquisaPersonagensPage> createState() =>
      _PesquisaPersonagensPageState();
}

class _PesquisaPersonagensPageState
    extends State<PesquisaPersonagensPage> {
  final supabase = Supabase.instance.client;
  final pesquisaController = TextEditingController();

  List personagens = [];
  bool carregando = false;

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  Future<void> pesquisar() async {
    final texto = pesquisaController.text.trim();

    setState(() {
      carregando = true;
    });

    if (texto.isEmpty) {
      setState(() {
        personagens = [];
        carregando = false;
      });
      return;
    }

    final response = await supabase
        .from('personagens')
        .select()
        .ilike('nome', '%$texto%')
        .order('nome');

    setState(() {
      personagens = response;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesquisar Personagem"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: pesquisaController,
              decoration: InputDecoration(
                hintText: "Digite o nome...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    pesquisaController.clear();

                    setState(() {
                      personagens = [];
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (_) => pesquisar(),
            ),

            const SizedBox(height: 20),

            if (carregando)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (!carregando)
              Expanded(
                child: personagens.isEmpty
                    ? const Center(
                        child: Text(
                          "Nenhum personagem encontrado.",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: personagens.length,
                        itemBuilder: (context, index) {

                          final personagem = personagens[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 15),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.deepPurple,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),

                              title: Text(
                                personagem['nome'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              subtitle: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                      "Série: ${personagem['serie']}"),

                                  Text(
                                      "Local: ${personagem['localizacao']}"),

                                  Text(
                                      "Carisma: ${personagem['carisma']}"),

                                  if (personagem['observacoes'] != null &&
                                      personagem['observacoes']
                                          .toString()
                                          .isNotEmpty)
                                    Text(
                                      "${personagem['observacoes']}",
                                    ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
