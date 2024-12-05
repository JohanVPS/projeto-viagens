import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:viagens/screens/loginScreen.dart';

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
      home: TelaPlanosDeViagem(
        // toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class TelaPlanosDeViagem extends StatefulWidget {
  final Function? toggleTheme; 
  final bool isDarkMode; 
  TelaPlanosDeViagem({this.toggleTheme, required this.isDarkMode});

  @override
  _TelaPlanosDeViagemState createState() => _TelaPlanosDeViagemState();
}

class _TelaPlanosDeViagemState extends State<TelaPlanosDeViagem> {

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );

    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  final List<PlanoDeViagem> planos = [
    PlanoDeViagem(
      titulo: "Paris",
      data: "12-20 Dez",
      descricao: "Torre Eiffel e Louvre.",
      veiculo: "Avião",
    ),
    PlanoDeViagem(
      titulo: "Maldivas",
      data: "05-10 Jan",
      descricao: "Resorts de luxo.",
      veiculo: "Barco",
    ),
    PlanoDeViagem(
      titulo: "Montanhas",
      data: "15-22 Fev",
      descricao: "Caminhadas e trilhas.",
      veiculo: "Carro",
    ),
  ];

  void adicionarPlano(String titulo, String data, String descricao, String veiculo) {
    setState(() {
      planos.add(PlanoDeViagem(
        titulo: titulo,
        data: data,
        descricao: descricao,
        veiculo: veiculo,
      ));
    });
  }

  void abrirFormularioCadastro() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FormularioPlano(adicionarPlano: adicionarPlano),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 52, 63),
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.menu, color: Colors.white),
        //   onPressed: () {},
        // ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            onPressed: () {logout(context);}, 
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
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
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
              title: Text('Início'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Navegar para outra página ou realizar alguma ação
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Navegar para outra página ou realizar alguma ação
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Sair'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Adicionar lógica de logout aqui
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bem-vindo!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Planos recentes:",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: planos.map((plano) {
                  return CartaoPlanoDeViagem(
                    titulo: plano.titulo,
                    data: plano.data,
                    descricao: plano.descricao,
                    veiculo: plano.veiculo,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 226, 27, 27),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: abrirFormularioCadastro,
      ),
    );
  }
}

class PlanoDeViagem {
  final String titulo;
  final String data;
  final String descricao;
  final String veiculo;

  PlanoDeViagem({
    required this.titulo,
    required this.data,
    required this.descricao,
    required this.veiculo,
  });
}

class FormularioPlano extends StatefulWidget {
  final Function(String, String, String, String) adicionarPlano;

  FormularioPlano({required this.adicionarPlano});

  @override
  _FormularioPlanoState createState() => _FormularioPlanoState();
}

class _FormularioPlanoState extends State<FormularioPlano> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController veiculoController = TextEditingController();

  void enviarPlano() {
    final titulo = tituloController.text;
    final data = dataController.text;
    final descricao = descricaoController.text;
    final veiculo = veiculoController.text;

    if (titulo.isNotEmpty &&
        data.isNotEmpty &&
        descricao.isNotEmpty &&
        veiculo.isNotEmpty) {
      widget.adicionarPlano(titulo, data, descricao, veiculo);
      Navigator.of(context).pop();
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
              backgroundColor: const Color.fromARGB(255, 39, 52, 63),
            ),
            child: Text("Adicionar Plano"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancelar"),
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
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      color: const Color.fromARGB(255, 39, 52, 63),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 215, 34, 34),
              ),
            ),
            SizedBox(height: 8),
            Text(
              data,
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(255, 39, 52, 63),
              ),
            ),
            SizedBox(height: 10),
            Text(
              descricao,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Veículo: $veiculo",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
