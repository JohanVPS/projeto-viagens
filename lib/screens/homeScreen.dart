import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:viagens/screens/loginScreen.dart';
import 'package:viagens/widgets/cores.dart';

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
        primaryColor: const Color.fromARGB(255, 39, 52, 63),
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 39, 52, 63),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
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
              color: Colors.white,
            ),
            onPressed: () => logout(context),
          ),
        ],
        title: Text(
          "Minhas Viagens",
          style: TextStyle(
            color: Colors.white,
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
                  color: Colors.white,
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
                // Fechar o Drawer
                Navigator.pop(context);
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
        child: Icon(Icons.add, color: Colors.white),
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
  final TextEditingController dataController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController veiculoController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void enviarPlano() async {
    final titulo = tituloController.text;
    final data = dataController.text;
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: tituloController,
            decoration: InputDecoration(labelText: "Destino"),
          ),
          TextField(
            controller: dataController,
            decoration: InputDecoration(labelText: "Data"),
            keyboardType: TextInputType.datetime,
          ),
          TextField(
            controller: descricaoController,
            decoration: InputDecoration(labelText: "Descrição"),
          ),
          TextField(
            controller: veiculoController,
            decoration: InputDecoration(labelText: "Meio de transporte"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: enviarPlano,
            style: ElevatedButton.styleFrom(
              backgroundColor: corPrimaria(),
            ),
            child: Text(
              "Adicionar Plano",
              style: TextStyle(color: corBranca()),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancelar",
              style: TextStyle(
                color: corDestaque(),
              ),
            ),
          ),
        ],
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