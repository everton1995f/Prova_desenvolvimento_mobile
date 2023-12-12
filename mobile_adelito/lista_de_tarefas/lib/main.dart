import 'package:flutter/material.dart';
import 'listaDeTarefas.dart';

void main() {
  runApp(MaterialApp(
    home: (TelaPrincipal()),
  ));
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Login-Cadastro"),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Campo para email e senha
            TextField(decoration: InputDecoration(labelText: 'E-mail')),
            TextField(decoration: InputDecoration(labelText: 'Senha')),
            // Botões de Login
            ElevatedButton(
              onPressed: () {
                //Logica para login
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListaDeTarefas()));
              },
              child: Text('Login'),
            ),
            //Botão para Cadastro
            TextButton(
              onPressed: () {
                // Logica para cadastro
              },
              child: Text('Cadastre-se'),
            )
          ],
        ),
      ),
    );
  }
}
