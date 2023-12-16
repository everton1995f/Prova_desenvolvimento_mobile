import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/database/db.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final  _formKey = GlobalKey<FormState>();
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
              //Campo para o email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Use um e-mail válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              //Campo para a senha
              TextFormField(
                controller: senhaController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Digite uma senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              //Criando botao de Login
              ElevatedButton(
                onPressed: () async {
                  //Vaidando o formulario antes de seguir
                  if (_formKey.currentState?.validate() ?? false){
                    //Lógica para autenticação
                    if (await autenticarUsuario(emailController.text, senhaController.text)){
                      print('Login realizado com sucesso!');
                    } else {
                      print('Conta não encontrada, dados invalidos!');
                    }
                  }
                },
                child: Text('Login'),
              )
            ]
            ),
        ),
         ),
    );
  }

  // Função para autenticar usuario usando o BD

  Future<bool> autenticarUsuario(String email, String senha) async {
    final database = await DB.instance.database();

    //Verificando se o email e a senha constão no banco de dados
    final result = await database.query('usuarios',
    where: 'email = ? AND senha = ?', whereArgs: [email, senha]);

    return result.isNotEmpty;
  }
}