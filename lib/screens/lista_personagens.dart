//Jamile de Oliveira Franquilim e Geovanna Kaori Shimada
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListaPersonagensPage extends StatefulWidget {
  const ListaPersonagensPage({super.key});

  @override
  State<ListaPersonagensPage> createState() =>
      _ListaPersonagensPageState();
}

class _ListaPersonagensPageState extends State<ListaPersonagensPage> {
  final supabase = Supabase.instance.client;

  final pesquisaController = TextEditingController();

  List personagens = [];

  @override
  void initState() {
    super.initState();
    buscarPersonagens();
  }

  Future<void> buscarPersonagens() async {
    final texto = pesquisaController.text.trim();

    final response = texto.isEmpty
        ? await supabase
            .from('personagens')
            .select()
            .order('nome')
        : await supabase
            .from('personagens')
            .select()
            .ilike('nome', '%$texto%')
            .order('nome');

    setState(() {
      personagens = response;
    });
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personagens Encontrados"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: pesquisaController,
              onChanged: (_) => buscarPersonagens(),
              decoration: InputDecoration(
                hintText: "Pesquisar personagem...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    pesquisaController.clear();
                    buscarPersonagens();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

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
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: const Icon(
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

                                Text("Série: ${personagem['serie']}"),

                                Text(
                                    "Local: ${personagem['localizacao']}"),

                                Text(
                                    "Carisma: ${personagem['carisma']}"),

                                if (personagem['observacoes'] != null &&
                                    personagem['observacoes']
                                        .toString()
                                        .isNotEmpty)
                                  Text(
                                      "${personagem['observacoes']}"),
                              ],
                            ),
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
