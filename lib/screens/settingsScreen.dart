import 'package:flutter/material.dart';
import 'package:viagens/widgets/cores.dart';

// AUTOR DA TELA --------> RAFAEL GARCIA

class Settings extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const Settings({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notificationsEnabled = true;
  String savedEmail = "emaildousuario@gmail.com";
  String savedPassword = "senha_do_usuario";
  bool showEmail = false;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
        iconTheme: IconThemeData(color: corBranca()),
      ),
      body: ListView(
        children: [
          // Seção de notificações
          SettingsSection(
            title: 'Notificações',
            children: [
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Ativar Notificações'),
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const Divider(),

          // Seção de temas
          SettingsSection(
            title: 'Tema',
            children: [
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Modo Escuro'),
                trailing: Switch(
                  value: widget.isDarkMode,
                  onChanged: (bool value) {
                    widget.onThemeChanged(value);
                  },
                ),
              ),
            ],
          ),
          const Divider(),

          // Seção sobre
          SettingsSection(
            title: 'Outros',
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Sobre'),
                onTap: () {
                  _showDialog(
                    context,
                    'Sobre o App',
                    'TriOcupado\n\nVersão: 1.0.0\n\n© 2024 Globetrotter\n\nEste aplicativo foi desenvolvido para ajudar você a gerenciar, planejar e organizar as suas viagens.',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text('Termos de Uso'),
                onTap: () {
                  _showDialog(
                    context,
                    'Termos de Uso',
                    'Estes Termos de Uso regulam o uso do aplicativo (TriOcupado), fornecido pela nossa empresa (Globetrotter), para fins de planejamento e organização de viagens.\n\n1. Uso do Aplicativo\n2. Conta de Usuário\n3. Privacidade e Coleta de Dados\n4. Conteúdo e Propriedade Intelectual\n5. Reservas e Transações\n6. Limitação de Responsabilidade\n7. Modificações no Aplicativo\n8. Rescisão\n9. Legislação Aplicável\n',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Política de Privacidade'),
                onTap: () {
                  _showDialog(
                    context,
                    'Política de Privacidade',
                    'Esta Política de Privacidade explica como o (TriOcupado) coleta, utiliza, armazena e compartilha suas informações pessoais quando você usa nosso aplicativo de planejamento de viagens.\n\nInformações que Coletamos:\n\n• Informações Pessoais: Como nome, e-mail, número de telefone.\n\n• Informações de Viagem: Detalhes sobre suas viagens planejadas, como destinos, datas, acomodações, atividades, meios de transporte e preferências de viagem.\n\n• Informações de Localização: Se você permitir, podemos coletar sua localização para sugerir destinos ou serviços próximos, como hotéis ou atrações turísticas.\n\n• Informações de Uso: Coletamos dados sobre como você interage com o aplicativo, como os recursos que você usa, tempo gasto no aplicativo e páginas acessadas.\n\n• Informações de Dispositivo: Dados sobre seu dispositivo, como modelo, sistema operacional, identificadores únicos e endereço IP.',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          ...children,
        ],
      ),
    );
  }
}
