import 'package:flutter/material.dart';
import 'package:lista_de_tarefas_2/cadastro.dart';
import 'package:lista_de_tarefas_2/login.dart';
// import 'listaDeTarefas.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // conectando a tela principal a tela de login     
      debugShowCheckedModeBanner: false,
      home: TelaPrincipal()
    );
  }
}

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                //Navegando para a tela de login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TelaLogin()),
                  );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //Navegando para tela de cadastro
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) =>
                  TelaDeCadastro())
                  );
              },
              child: Text('Cadastro'),
            )
          ],
        )
         ),
    );
  }
}
