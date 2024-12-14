import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:viagens/widgets/cores.dart';
import 'package:viagens/widgets/inputDec.dart';

class DetalhesScreen extends StatefulWidget {
  final String tripId;

  const DetalhesScreen({Key? key, required this.tripId}) : super(key: key);

  @override
  _DetalhesScreenState createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _tituloController = TextEditingController();
  final _veiculoController = TextEditingController();
  final _dataController = TextEditingController();

  @override
  void dispose() {
    _descricaoController.dispose();
    _tituloController.dispose();
    _veiculoController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('travels').doc(widget.tripId).update({
          'titulo': _tituloController.text,
          'descricao': _descricaoController.text,
          'veiculo': _veiculoController.text,
          'data': _dataController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alterações salvas com sucesso!'),
            backgroundColor: corPrimaria(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar alterações: $e'),
            backgroundColor: corDestaque(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Viagem', style: TextStyle(color: corTitulo())),
        backgroundColor: corPrimaria(),
        iconTheme: IconThemeData(color: corBranca()),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('travels').doc(widget.tripId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: corPrimaria()));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'Viagem não encontrada.',
                style: TextStyle(fontSize: 18, color: corDestaque()),
              ),
            );
          }

          final tripData = snapshot.data!.data() as Map<String, dynamic>;

          _descricaoController.text = tripData['descricao'] ?? '';
          _tituloController.text = (tripData['titulo'] ?? '').toString();
          _veiculoController.text = (tripData['veiculo'] ?? '').toString();
          _dataController.text = tripData['data'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    tripData['titulo'] ?? 'Destino não especificado',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: corPrimaria()),
                  ),
                  // _buildTextField(
                  //   controller: _tituloController,
                  //   label: 'Título',
                  //   icon: Icons.title,
                  // ),
                  // SizedBox(height: 10),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _dataController,
                    label: 'Data',
                    icon: Icons.calendar_today,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: _descricaoController,
                    label: 'Descrição',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: _veiculoController,
                    label: 'Veículo',
                    icon: Icons.directions_car,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corPrimaria(),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Salvar Alterações',
                      style: TextStyle(fontSize: 16, color: corBranca()),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: inputDec(label, icon),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha o campo $label';
        }
        return null;
      },
    );
  }
}
