import 'package:flutter/material.dart';
import 'package:lista_de_tarefas_2/login.dart';
import 'adicionarTarefas.dart';

class ListaDeTarefas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(77, 51, 130, 1),
        title: Text('Lista de tarefas'),
      ),
      drawer: Drawer(
        width: 200,
        child: Column(children: [
          SizedBox(
            height: 50,
          ),
          ListTile(
            title: const Text('Adicionar Tarefas'),
            onTap: () {
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => GerenciarTarefas()));
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TelaLogin()));
            },
          )
        ]),
      ),
    );
  }
}
