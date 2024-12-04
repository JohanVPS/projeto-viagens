import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:viagens/screens/homeScreen.dart';
import 'package:viagens/screens/loginScreen.dart';

class Verificaloginscreen extends StatelessWidget {

  const Verificaloginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // vê se o usuário está autenticado
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // vê se a conta está ativa
          return FutureBuilder<void>(
            future: _checkUserAccess(context),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (futureSnapshot.hasError) {
                // Se tiver um erro, redireciona para a página de login
                return const Center(child: Text('Sua conta foi desativada.'));
              }
              return HomeScreen();
            },
          );
        } else if (snapshot.hasError) {
          // Se houver erro, exibe a mensagem de erro
          return Text('Error: ${snapshot.error}');
        }
        // Mostra indicador de carregamento ou LoginPage
        return snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : LoginScreen();
      },
    );
  }

  Future<void> _checkUserAccess(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não encontrado.');
      }
      // Simula uma chamada para verificar o status da conta
      // Aqui, verificamos se a conta está ativa
      final idTokenResult = await user.getIdTokenResult(true);
      if (idTokenResult.claims?['accountDisabled'] == true) {
        throw Exception('Sua conta foi desativada.');
      }
    } catch (e) {
      // Em caso de erro (como conta desativada), realiza o logout e redireciona para a LoginPage
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}