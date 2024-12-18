import 'package:flutter/material.dart';
import 'package:viagens/classes/users.dart';
import 'package:viagens/screens/SignupScreen.dart';
import 'package:viagens/screens/homeScreen.dart';
import 'package:viagens/screens/trocaSenha.dart';
import '../widgets/cores.dart';
import '../widgets/inputDec.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const LoginScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);
  
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<String> fetchUid(String email) async {
    print(email);

    try {
      var cliente = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (cliente.docs.isNotEmpty) {
        String uid = cliente.docs.first.id; // Acessa o ID do primeiro documento
        print(uid);
        return uid;
      } else {
        throw Exception('Usuário não encontrado');
      }
    } catch (e) {
      throw Exception('usuario n encontrado $e');
    }
  }

  Future<Users> _getUsers(String email) async {
    print(email + ' getusers');
    try {
      var users = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (users.docs.isEmpty) {
        throw Exception('EMAIL NÃO ENCONTRADO');
      }
      var user = users.docs.first;
      print(user);
      return Users(
        name: user['name'],
        email: user['email'],
      );
    } catch (e) {
      print(e);
      throw Exception('deu ruim: $e');
    }
  }

  void verifyLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final currentContext = context; // Captura o contexto atual

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        Users users = await _getUsers(_emailController.text);

        print(users);

        // Usando o contexto capturado
        if (mounted) {
          Navigator.pushReplacement(
            currentContext,
            MaterialPageRoute(
              builder: (context) => HomeScreen(isDarkMode: widget.isDarkMode,
              onThemeChanged: widget.onThemeChanged,),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        print(e);
        if (mounted) {
          showDialog(
            context: currentContext,
            builder: (context) => AlertDialog(
              title: const Text('Falha no login'),
              content: const Text('Email ou senha incorretos'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(currentContext).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corPrimaria(),
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
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Campo de e-mail
                        TextField(
                          style: TextStyle(color: corBranca()),
                          decoration: inputDec("E-mail", Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),

                        SizedBox(height: 20),

                        // Campo de senha
                        TextField(
                          style: TextStyle(color: corBranca()),
                          controller: _passwordController,
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
                      ],
                    )),
                SizedBox(height: 15),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrocaSenha()),
                      );
                    },
                    child: Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(
                        color: corBranca(),
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

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
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                            color: corBranca(),
                          ))
                        : Text(
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