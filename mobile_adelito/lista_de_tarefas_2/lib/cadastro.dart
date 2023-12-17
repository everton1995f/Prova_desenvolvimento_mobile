import 'package:flutter/material.dart';
import 'package:lista_de_tarefas_2/main.dart';
import 'package:lista_de_tarefas_2/database/db.dart';

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
  TextEditingController confirmacaoSenhaController = TextEditingController();

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
                //Campo nome
                TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(label: Text('Nome')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: confirmacaoSenhaController,
                  decoration:
                      InputDecoration(label: Text('Confirmação de senha')),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    } else if (value != senhaController.text) {
                      return 'Senhas direfentes';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Botão para Cadastrar
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Validar o formulário antes de prosseguir
                      if (_formKey.currentState?.validate() ?? false) {
                        // Lógica para cadastrar usuário
                        await cadastrarUsuario(
                          nomeController.text,
                          emailController.text,
                          senhaController.text,
                        );
                        print('Cadastro bem-sucedido!');
                        // Limpar os campos após o cadastro
                        nomeController.clear();
                        emailController.clear();
                        senhaController.clear();
                        confirmacaoSenhaController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Cadastro Realizado. Volte e faça o login'),
                          ),
                        );
                      }
                    } catch (e) {
                      print('Erro durante o cadastro: $e');
                      // Verificar se o erro é de e-mail já existente
                      if (e
                          .toString()
                          .contains('Já existe um usuário com esse email')) {
                        // Exibir SnackBar ao usuário
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'E-mail já cadastrado. Faça login ou use outro e-mail.'),
                          ),
                        );
                      }
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
      ),
    );
  }

  // Função para cadastrar os ususarios no Banco
  // Função para cadastrar usuário no banco de dados
  Future<void> cadastrarUsuario(String nome, String email, String senha) async {
    final database = await DB.instance.database;

    // Verificar se o usuário já existe com o mesmo email
    final existingUsers = await database.query(
      'usuarios',
      where: 'email_usuario = ?',
      whereArgs: [email],
    );

    if (existingUsers.isNotEmpty) {
      // Usuário já existe, lançar exceção
      throw Exception('Já existe um usuário com esse email');
    }

    // Usuário não existe, pode prosseguir com o cadastro
    await database.insert(
      'usuarios',
      {'nome': nome, 'email_usuario': email, 'senha_usuario': senha},
    );
  }
}
