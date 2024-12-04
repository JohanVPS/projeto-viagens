import 'package:flutter/material.dart';
import '../widgets/cores.dart';
import '../widgets/inputDec.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: corBranca(),
                        child: Image.asset('lib/assets/bussola-logo.png', width: 70,)
                        // Icon(
                        //   Icons.airplane_ticket_rounded,
                        //   color: corDestaque(),
                        //   size: 55,
                        // ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Tri",
                              style: TextStyle(
                                color: Colors.white, // Cor branca para "Tri"
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Ocupado",
                              style: TextStyle(
                                color: Color(0xFFFF474F), // Cor vermelha #FF474F para "Ocupado"
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                // Campo de e-mail
                TextField(
                  style: TextStyle(color: corBranca()),
                  decoration: inputDec("E-mail", Icons.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),

                // Campo de senha
                TextField(
                  style: TextStyle(color: corBranca()),
                  obscureText: !isPasswordVisible,
                  decoration: inputDec(
                    "Senha",
                    Icons.lock,
                    isPassword: true,
                    isPasswordVisible: isPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Botão de login
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implementar lógica de login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corDestaque(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        color: corBranca(),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Link de cadastro
                GestureDetector(
                  onTap: () {
                    // Navegar para a tela de cadastro
                  },
                  child: Text(
                    "Não tem conta? cadastre-se!",
                    style: TextStyle(
                      color: corBranca(),
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
