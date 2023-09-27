import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  final String nome;
  final String email;
  final String tipoAcesso;

  User(this.nome, this.email, this.tipoAcesso);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Acesso',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccessScreen(),
    );
  }
}

class AccessScreen extends StatefulWidget {
  @override
  _AccessScreenState createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tipoAcessoController = TextEditingController();

  bool isValidEmail(String email) {
    return email.contains('@');
  }

  void redirectToSecondScreen(BuildContext context) {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final tipoAcesso = tipoAcessoController.text.trim();

    if (nome.isEmpty || email.isEmpty || tipoAcesso.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, preencha todos os campos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (!isValidEmail(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, insira um email válido.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final user = User(nome, email, tipoAcesso);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SecondScreen(user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acesso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: tipoAcessoController,
              decoration: InputDecoration(labelText: 'Tipo de Acesso'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                redirectToSecondScreen(context);
              },
              child: Text('Acessar'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final User user;

  SecondScreen(this.user);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool showInfo = true;

  void toggleInfoVisibility() {
    setState(() {
      showInfo = !showInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.nome),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showInfo) ...[
                Text('Nome: ${widget.user.nome}'),
                Text('Email: ${widget.user.email}'),
                Text('Tipo de Acesso: ${widget.user.tipoAcesso}'),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmação'),
                        content: Text('Deseja ocultar as informações?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              toggleInfoVisibility(); // Oculta as informações
                              Navigator.of(context).pop();
                            },
                            child: Text('Confirmar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(showInfo ? 'Ocultar Informações' : 'Exibir Informações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}