import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TarefasView extends StatefulWidget {
  const TarefasView({super.key});

  @override
  State<TarefasView> createState() => _TarefasViewState();
}

class _TarefasViewState extends State<TarefasView> {
  final _db = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final _tarefasField = TextEditingController();

  // --- Métodos CRUD ---
  void _addTarefa() async {
    if (_tarefasField.text.trim().isEmpty) return;

    try {
      await _db
          .collection("usuarios")
          .doc(_user!.uid)
          .collection("tarefas")
          .add({
        "titulo": _tarefasField.text.trim(),
        "concluida": false,
        "dataCriacao": Timestamp.now(),
      });

      _tarefasField.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao adicionar tarefa: $e")),
      );
    }
  }

  void _updateTarefa(String tarefaID, bool statusTarefa) async {
    await _db
        .collection("usuarios")
        .doc(_user!.uid)
        .collection("tarefas")
        .doc(tarefaID)
        .update({"concluida": !statusTarefa});
  }

  void _deleteTarefa(String tarefaID) async {
    await _db
        .collection("usuarios")
        .doc(_user!.uid)
        .collection("tarefas")
        .doc(tarefaID)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text("Minhas Tarefas",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Sair",
            onPressed: () async => await FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // --- Campo de Nova Tarefa ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: TextField(
                  controller: _tarefasField,
                  decoration: InputDecoration(
                    hintText: "Digite uma nova tarefa...",
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: _addTarefa,
                      icon: const Icon(Icons.add_circle,
                          color: Colors.blue, size: 30),
                    ),
                  ),
                  onSubmitted: (_) => _addTarefa(),
                ),
              ),
              const SizedBox(height: 20),

              // --- Lista de Tarefas ---
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _db
                      .collection("usuarios")
                      .doc(_user?.uid)
                      .collection("tarefas")
                      .orderBy("dataCriacao", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nenhuma tarefa cadastrada",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      );
                    }

                    final tarefas = snapshot.data!.docs;

                    return ListView.separated(
                      itemCount: tarefas.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final tarefa = tarefas[index];
                        final tarefaMap =
                            tarefa.data() as Map<String, dynamic>;

                        final concluida = tarefaMap["concluida"] == true;

                        return Card(
                          color: concluida
                              ? Colors.blue.shade100
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Checkbox(
                              value: concluida,
                              onChanged: (value) =>
                                  _updateTarefa(tarefa.id, concluida),
                              activeColor: Colors.blue,
                            ),
                            title: Text(
                              tarefaMap["titulo"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: concluida
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: concluida
                                    ? Colors.grey.shade600
                                    : Colors.black,
                              ),
                            ),
                            trailing: IconButton(
                              tooltip: "Excluir",
                              onPressed: () => _deleteTarefa(tarefa.id),
                              icon: const Icon(Icons.delete, size: 26),
                              color: Colors.red.shade400,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
