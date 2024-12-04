import 'package:flutter/material.dart';
import 'package:viagens/classes/users.dart';
import 'package:viagens/screens/SignupScreen.dart';
import '../widgets/cores.dart';
import '../widgets/inputDec.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<String> fetchUid(String email) async {
    var cliente = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (cliente.docs.isNotEmpty) {
      String uid = cliente.docs.first.id; // Acessa o ID do primeiro documento
      return uid;
    } else {
      throw Exception('Usuário não encontrado');
    }
  }

  Future<Users> _getUsers(String email) async {
    var users = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    var user = users.docs.first;

    return Users(
      name: user['name'],
      email: user['email'],
    );
  }

  void verifyLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        Users users = await _getUsers(_emailController.text);

        print(users);

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MainMenuScreen(), // Passando toggleTheme se não for nulo
        //   ),
        // );
      } on FirebaseAuthException catch (e) {
        print(e);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Falha no login'),
                  content: const Text('Email ou senha incorretos'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                          child: Image.asset(
                            'lib/assets/bussola-logo.png',
                            width: 70,
                          )
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
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Ocupado",
                              style: TextStyle(
                                color: Color(0xFFFF474F),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corDestaque(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isLoading ? Center(
                      child: CircularProgressIndicator(
                        color: corDestaque(),
                      )
                    ) : Text(
                      "Entrar",
                      style: TextStyle(
                        color: corBranca(),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      verifyLogin();
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Link de cadastro
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Ainda não tem uma conta? ',
                        style: TextStyle(color: corBranca()),
                        children: [
                          TextSpan(
                            text: 'Cadastre-se',
                            style: TextStyle(
                              color: corDestaque(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
