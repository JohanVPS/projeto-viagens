import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:viagens/screens/loginScreen.dart';
import 'package:viagens/screens/settingsScreen.dart';
import 'package:viagens/widgets/cores.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: corPrimaria(),
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: AppBarTheme(
          backgroundColor: corPrimaria(),
          titleTextStyle: TextStyle(
            color: corBranca(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: corPreta(),
          titleTextStyle: TextStyle(
            color: corBranca(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: TelaPlanosDeViagem(),
    );
  }
}

class TelaPlanosDeViagem extends StatefulWidget {
  @override
  _TelaPlanosDeViagemState createState() => _TelaPlanosDeViagemState();
}

class _TelaPlanosDeViagemState extends State<TelaPlanosDeViagem> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  void abrirFormularioCadastro() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FormularioPlano(
        usuarioId: _auth.currentUser?.uid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corPrimaria(),
        elevation: 0,
        iconTheme: IconThemeData(
          color: corBranca(), // Define a cor do ícone do Drawer
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: corBranca(),
            ),
            onPressed: () => logout(context),
          ),
        ],
        title: Text(
          "Minhas Viagens",
          style: TextStyle(
            color: corBranca(),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Remove padding padrão do Drawer
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: corPrimaria(),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: corBranca(),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Página Inicial'),
              onTap: () {
                // Fechar o Drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle_rounded),
              title: Text('Conta'),
              onTap: () {
                // Fechar o Drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('travels')
            .where('userId', isEqualTo: _auth.currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "Nenhuma viagem registrada.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return CartaoPlanoDeViagem(
                titulo: data['titulo'] ?? '',
                data: data['data'] ?? '',
                descricao: data['descricao'] ?? '',
                veiculo: data['veiculo'] ?? '',
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: corDestaque(),
        child: Icon(Icons.add, color: corBranca()),
        onPressed: abrirFormularioCadastro,
      ),
    );
  }
}

class FormularioPlano extends StatefulWidget {
  final String? usuarioId;

  FormularioPlano({required this.usuarioId});

  @override
  _FormularioPlanoState createState() => _FormularioPlanoState();
}

class _FormularioPlanoState extends State<FormularioPlano> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController veiculoController = TextEditingController();

  DateTime? dataSelecionada;
  bool camposPreenchidos = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void enviarPlano() async {
    final titulo = tituloController.text;
    final data = dataSelecionada != null ? dataSelecionada.toString().split(' ')[0] : '';
    final descricao = descricaoController.text;
    final veiculo = veiculoController.text;

    if (titulo.isNotEmpty &&
        data.isNotEmpty &&
        descricao.isNotEmpty &&
        veiculo.isNotEmpty &&
        widget.usuarioId != null) {
      try {
        await _firestore.collection('travels').add({
          'titulo': titulo,
          'data': data,
          'descricao': descricao,
          'veiculo': veiculo,
          'userId': widget.usuarioId,
        });
        Navigator.of(context).pop();
      } catch (e) {
        print('Erro ao salvar viagem: $e');
      }
    }
  }

  void verificarCamposPreenchidos() {
    setState(() {
      camposPreenchidos = tituloController.text.isNotEmpty &&
          descricaoController.text.isNotEmpty &&
          veiculoController.text.isNotEmpty &&
          dataSelecionada != null;
    });
  }

  Future<void> selecionarData() async {
    DateTime? novaData = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (novaData != null) {
      setState(() {
        dataSelecionada = novaData;
        verificarCamposPreenchidos();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tituloController.addListener(verificarCamposPreenchidos);
    descricaoController.addListener(verificarCamposPreenchidos);
    veiculoController.addListener(verificarCamposPreenchidos);
  }

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    veiculoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Novo Plano de Viagem",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: corPrimaria(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: tituloController,
              decoration: InputDecoration(
                labelText: "Destino",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(
                labelText: "Descrição",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: veiculoController,
              decoration: InputDecoration(
                labelText: "Meio de transporte",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today, color: corPrimaria()),
                  onPressed: selecionarData,
                ),
                SizedBox(width: 8),
                Text(
                  dataSelecionada != null
                      ? dataSelecionada!.toLocal().toString().split(' ')[0]
                      : "Selecione uma data",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: camposPreenchidos ? enviarPlano : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: camposPreenchidos
                          ? corPrimaria()
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Adicionar",
                      style: TextStyle(color: corBranca()),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: corDestaque()),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: corDestaque()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartaoPlanoDeViagem extends StatelessWidget {
  final String titulo;
  final String data;
  final String descricao;
  final String veiculo;

  CartaoPlanoDeViagem({
    required this.titulo,
    required this.data,
    required this.descricao,
    required this.veiculo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: corPrimaria(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: corTitulo(),
              ),
            ),
            Divider(
              color: corDestaque(),
              thickness: 1,
              height: 20,
            ),
            Text(
              "Data: $data",
              style: TextStyle(
                fontSize: 14,
                color: corCinzaClaro(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Descrição:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: corBranca(),
              ),
            ),
            Text(
              descricao,
              style: TextStyle(
                fontSize: 14,
                color: corBranca(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Veículo:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: corBranca(),
              ),
            ),
            Text(
              veiculo,
              style: TextStyle(
                fontSize: 14,
                color: corBranca(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}