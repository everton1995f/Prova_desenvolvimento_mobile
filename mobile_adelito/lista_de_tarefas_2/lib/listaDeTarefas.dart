import 'package:flutter/material.dart';
import 'package:lista_de_tarefas_2/login.dart';
import 'package:lista_de_tarefas_2/adicionarTarefas.dart';
import 'package:lista_de_tarefas_2/database/db.dart';

class ListaDeTarefas extends StatefulWidget {
  @override
  _ListaDeTarefasState createState() => _ListaDeTarefasState();
}

class _ListaDeTarefasState extends State<ListaDeTarefas> {
  List<Map<String, dynamic>> _listaTarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    final database = await DB.instance.database;
    final tarefas = await database.query('tarefas');
    setState(() {
      _listaTarefas = tarefas;
    });
  }

  Future<void> _excluirTarefa(int idTarefa) async {
    final database = await DB.instance.database;
    await database.delete('tarefas', where: 'id_tarefa = ?', whereArgs: [idTarefa]);
    _carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(77, 51, 130, 1),
        title: Text('Lista de Tarefas'),
      ),
      drawer: Drawer(
        width: 200,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            ListTile(
              title: const Text('Adicionar Tarefas'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GerenciarTarefas()),
                );
                // Atualize a lista após adicionar uma tarefa
                _carregarTarefas();
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TelaLogin()));
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _listaTarefas.length,
        itemBuilder: (context, index) {
          final tarefa = _listaTarefas[index];
          return Card(
            child: ListTile(
              title: Text(tarefa['nome_tarefa']),
              subtitle: Text('Prioridade: ${tarefa['prioridade_tarefa']}'),
              trailing: IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  _exibirDetalhes(tarefa);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _exibirDetalhes(Map<String, dynamic> tarefa) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes da Tarefa'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nome: ${tarefa['nome_tarefa']}'),
              Text('Prioridade: ${tarefa['prioridade_tarefa']}'),
              Text('Prazo: ${tarefa['prazo_tarefa']}'),
              Text('Descrição: ${tarefa['descricao_tarefa']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
            TextButton(
              onPressed: () {
                _excluirTarefa(tarefa['id_tarefa']);
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
