import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/login.dart';
import 'package:lista_de_tarefas/main.dart';
import 'package:lista_de_tarefas/database/db.dart';

class TelaDeCadastro extends StatefulWidget {
  const TelaDeCadastro({super.key});

  @override
  State<TelaDeCadastro> createState() => _TelaDeCadastroState();
}

class _TelaDeCadastroState extends State<TelaDeCadastro> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Campo nome
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(label: Text('Nome')),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              //Campo de Email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(label: Text('E-mail')),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Por favor, insira um email vaido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              //Campo de Senha
                            TextFormField(
                controller: senhaController,
                decoration: InputDecoration(label: Text('Senha')),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Por favor, insira uma senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Botão para Cadastrar
              ElevatedButton(
                onPressed: () async {
                  //Validação de Formulario
                  if (_formKey.currentState?.validate() ?? false){
                    //Lógica de cadastro
                    await cadastrarUsuario(
                      nomeController.text,
                      emailController.text,
                      senhaController.text,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaLogin()),
                    );
                    //Limpando os campos após o cadastro
                    nomeController.clear();
                    emailController.clear();
                    senhaController.clear();
                  }
                },
                child: Text('Cadastrar'),
              ),
              ElevatedButton(
              onPressed: () {
                //Navegando para a tela de login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaPrincipal()),
                  );
              },
              child: Text('Votar'),
              )
            ],
          ),
        ),
           ),
    );
  }
  // Função para cadastrar os ususarios no Banco
  Future<void> cadastrarUsuario(String nome, String email, String senha) async {
    final database = await DB.instance.database;
    // Inserindo os dados no bando
    await database.insert(
      'usuarios',
      {'nome': nome, 'email_usuario': email, 'senha_usuario': senha},
    );
  }
}
