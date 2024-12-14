import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:viagens/widgets/cores.dart';

class ContaScreen extends StatefulWidget {
  @override
  _ContaScreenState createState() => _ContaScreenState();
}

class _ContaScreenState extends State<ContaScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  Map<String, dynamic>? userData;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user!.uid).get();
      setState(() {
        userData = userDoc.data();
        _nameController.text = userData?['name'] ?? '';
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate() && user != null) {
      await _firestore.collection('users').doc(user!.uid).update({
        'name': _nameController.text.trim(),
      });
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Informações atualizadas com sucesso!'),
          backgroundColor: corDestaque(),
        ),
      );
    }
  }

  Future<void> _deactivateAccount() async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).update({'status': 'inativo'});
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha Conta',
          style: TextStyle(color: corTitulo()),
        ),
        centerTitle: true,
        backgroundColor: corPrimaria(),
        iconTheme: IconThemeData(color: corBranca()),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator(color: corDestaque()))
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: corPrimaria(),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: corBranca(),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Email: ${user!.email}',
                          style: TextStyle(
                            fontSize: 18,
                            color: corLetra(),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            labelText: 'Nome',
                            labelStyle: TextStyle(color: corCinzaClaro()),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: corCinzaClaro()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: corDestaque()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabled: _isEditing,
                          ),
                          style: TextStyle(color: corLetra()),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um nome';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        if (_isEditing)
                          ElevatedButton(
                            onPressed: _updateUserData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: corPrimaria(),
                              foregroundColor: corBranca(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Salvar Alterações'),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: corPrimaria(),
                              foregroundColor: corBranca(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: Icon(Icons.edit),
                            label: Text('Editar Informações'),
                          ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _deactivateAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: corDestaque(),
                            foregroundColor: corBranca(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(Icons.delete),
                          label: Text('Excluir Conta'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      // backgroundColor: corCinzaEscuro(),
    );
  }
}