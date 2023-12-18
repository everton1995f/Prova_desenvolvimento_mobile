import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas_2/listaDeTarefas.dart';
import 'package:lista_de_tarefas_2/database/db.dart';

class GerenciarTarefas extends StatefulWidget {
  const GerenciarTarefas({super.key});

  @override
  State<GerenciarTarefas> createState() => _GerenciarTarefasState();
}

class _GerenciarTarefasState extends State<GerenciarTarefas> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeDaTarefaController = TextEditingController();
  TextEditingController descricaoDaTarefaController = TextEditingController();
  TextEditingController prazoDaTarefaController = TextEditingController();
  TextEditingController prioridadeDaTarefaController = TextEditingController();
  TextEditingController cateoriaDaTarefaController = TextEditingController();

    DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    )) ?? DateTime.now();

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        prazoDaTarefaController.text = DateFormat('yyyy/MM/dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                ),
                Text(
                  'Nova Tarefa',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30,),
                //Campos de atribuição das tarefas
                Card(
                  child: TextFormField(
                    controller: nomeDaTarefaController,
                    decoration: InputDecoration(
                        labelText: 'Nome da Terefa', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o nome da tarefa';
                          }
                          return null;
                        },
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  child: TextFormField(
                    controller: descricaoDaTarefaController,
                    decoration: InputDecoration(
                        labelText: 'Descrição', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite a descrição da tarefa';
                          }
                          return null;
                        },
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  child: TextFormField(
                    controller: prazoDaTarefaController,
                    decoration: InputDecoration(
                        labelText: 'Prazo', border: OutlineInputBorder()),
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o prazo para teminar a terefa';
                          }
                          return null;
                        },
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  child: TextFormField(
                    controller: prioridadeDaTarefaController,
                    decoration: InputDecoration(
                        labelText: 'Prioridade', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite prioridade da tarefa';
                          }
                          return null;
                        },
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  child: TextFormField(
                    controller: cateoriaDaTarefaController,
                    decoration: InputDecoration(
                        labelText: 'Categoria', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite a categoria da tarefa';
                          }
                          return null;
                        },
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async {
                    try{
                      //Validando o formuario
                      if (_formKey.currentState?.validate() ?? false){
                        // Lógica da adição de tarefas
                        await adicionarTarefa(
                          nomeDaTarefaController.text,
                          descricaoDaTarefaController.text,
                          DateFormat('yyyy/MM/dd').format(_selectedDate!),
                          prioridadeDaTarefaController.text,
                          cateoriaDaTarefaController.text, 
                        );
                        print('Adicionado com sucesso');
                        //Limpando campos após adição
                        nomeDaTarefaController.clear();
                        descricaoDaTarefaController.clear();
                        prazoDaTarefaController.clear();
                        prioridadeDaTarefaController.clear();
                        cateoriaDaTarefaController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Nova atividade adicionada')
                          ),
                        );
                      }
                    }catch (e) {
                      print('Erro ao adicionar mova task: $e');
                      // Verificar se a uma tarefa com o mesmo nome
                      if (e.toString().contains('Atividade já adicionada anteriormente')){
                        //exibindo a msg ao usuario
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Essa atividade já consta na lista'
                            ),
                          ),
                          );
                      }
                    }
                  },
                  child: Text('Add Tarefa'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    //Navegando para a tela de login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ListaDeTarefas()),
                    );
                  },
                  child: Text('Votar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Função pra adicionar as atividades no bando de dacos
  Future<void> adicionarTarefa(String nome, String descricao, String prazo, String prioridade, String categoria) async {
    final database = await DB.instance.database;

    //Verificar se a tarefa já existe no banco
    final tarefaExisteNoBanco = await database.query(
      'tarefas',
      where: 'nome_tarefa = ?',
      whereArgs: [nome],
    );
    if (tarefaExisteNoBanco.isNotEmpty) {
      //Atividade já catalogada
      throw Exception('Essa atividade já consta no banco');
    }
    
    // Inserindo a tarefa na tabela tarefas
    await database.insert(
      'tarefas',
      {'nome_tarefa': nome, 'descricao_tarefa': descricao, 'prazo': prazo, 'prioridade': prioridade, 'categria': categoria},
    );
  }
}
