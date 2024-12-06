import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:viagens/widgets/cores.dart';

class TrocaSenha extends StatefulWidget {
  State<TrocaSenha> createState() => _TrocaSenhaState();
}

class _TrocaSenhaState extends State<TrocaSenha> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Exibe uma SnackBar informando que o e-mail foi enviado com sucesso
      const snackBar = SnackBar(
        content: Text('Email de redefinição de senha enviado'),
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      String errorMessage = 'Erro ao enviar e-mail de redefinição de senha';

      // Verifica se a exceção é do tipo FirebaseAuthException e trata erros específicos
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage =
                'Usuário não encontrado. Verifique o e-mail digitado.';
            break;
          case 'invalid-email':
            errorMessage =
                'Formato de e-mail inválido. Por favor, tente novamente.';
            break;
          case 'network-request-failed':
            errorMessage = 'Falha na conexão de rede. Verifique sua internet.';
            break;
          default:
            errorMessage =
                'Ocorreu um erro inesperado. Tente novamente mais tarde.';
            break;
        }
      }

      // Exibe uma SnackBar com a mensagem de erro específica
      final snackBar = SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corPrimaria(),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: corBranca()),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Esqueci a senha',
          style: TextStyle(color: corBranca(), fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Informe seu e-mail para recuperar a sua conta:',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(color: corDestaque()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: corDestaque(),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: corDestaque(),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: corDestaque(),
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, insira um e-mail válido';
                  }
                  return null;
                },
              ),
            ),
            Expanded(child: Container()), // Adiciona espaço flexível
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: corDestaque(),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _sendPasswordResetEmail(_emailController.text);
                    }
                  },
                  child: const Text(
                    'ENVIAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
