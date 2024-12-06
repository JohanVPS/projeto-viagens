import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/cores.dart';
import '../widgets/inputDec.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String erro = '';
  bool _isLoading = false;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_password == _confirmPassword) {
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );

          String uid = userCredential.user!.uid;

          await _firestore.collection('users').doc(uid).set({
            'name': _nome,
            'email': _email,
          });

          final snackBar = SnackBar(
            content: Text('Cadastro concluído: ${userCredential.user!.email}'),
            duration: Duration(seconds: 5), // Duração da SnackBar
          );
          Navigator.pop(context);
          // Exibe a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          final snackBar = const SnackBar(
            content: Text('As senhas não correspondem'),
            duration: Duration(seconds: 5), // Duração da SnackBar
          );
          // Exibe a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            erro = 'Email já cadastrado';
          } else if (e.code == 'weak-password') {
            erro = 'Digite uma senha com mais de 6 digitos';
          } else if (e.code == 'invalid-email') {
            erro = 'Email inválido';
          } else {
            erro = 'Erro ao cadastrar';
          }
        }
        final snackBar = SnackBar(
          content: Text(erro),
          duration: Duration(seconds: 5), // Duração da SnackBar
        );
        // Exibe a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: corPrimaria(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
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
                          ),
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

                  // Nome
                  TextFormField(
                    style: TextStyle(color: corBranca()),
                    cursorColor: corBranca(),
                    decoration: inputDec('Nome', Icons.person),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _nome = value;
                    },
                  ),
                  SizedBox(height: 20),

                  // E-mail
                  TextFormField(
                    style: TextStyle(color: corBranca()),
                    cursorColor: corBranca(),
                    decoration: inputDec('Email', Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um e-mail';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                  SizedBox(height: 20),

                  // Senha
                  TextFormField(
                    style: TextStyle(color: corBranca()),
                    cursorColor: corBranca(),
                    decoration: inputDec(
                      'Senha',
                      Icons.lock,
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      toggleVisibility: _togglePasswordVisibility,
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  SizedBox(height: 20),

                  // Confirmação de senha
                  TextFormField(
                    style: TextStyle(color: corBranca()),
                    cursorColor: corBranca(),
                    decoration: inputDec(
                      'Confirme sua senha',
                      Icons.lock,
                      isPassword: true,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      toggleVisibility: _toggleConfirmPasswordVisibility,
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _confirmPassword = value;
                    },
                  ),
                  SizedBox(height: 20),

                  // Botão de cadastro
                  SizedBox(height: size.height * 0.02),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: corDestaque(),
                        ))
                      : Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _signup(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: corDestaque(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              'Inscrever-se',
                              style: TextStyle(
                                color: corBranca(),
                                fontSize: size.height * 0.022,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 20),

                  // Voltar para login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Já tem uma conta?',
                        style: TextStyle(color: corBranca()),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: corDestaque(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
