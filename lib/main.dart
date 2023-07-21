import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EmailScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  EmailScreenState createState() => EmailScreenState();
}

class EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      String username = 'brunofelixf@gmail.com'; // Insira seu e-mail aqui
      String password = 'xxxxxxxx'; // Insira sua senha de app gmail

      final smtpServer = gmail(username, password);

      final message = Message()
        ..from = Address(username)
        ..recipients.add(_emailController.text)
        ..subject = 'Teste de e-mail'
        ..text = _messageController.text;

      try {
        final sendReport = await send(message, smtpServer);
        print('Mensagem enviada: ${sendReport.toString()}');
      } catch (e) {
        print('Erro ao enviar e-mail: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar e-mail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Digite o endereço de e-mail',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite um endereço de e-mail válido.';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Por favor, digite um endereço de e-mail válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Mensagem',
                  hintText: 'Digite a mensagem que deseja enviar',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite uma mensagem válida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _sendEmail,
                child: const Text('Enviar e-mail'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}