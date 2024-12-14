import 'package:flutter/material.dart';
import 'package:viagens/widgets/cores.dart';

// AUTOR DA TELA --------> RAFAEL GARCIA

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: (bool value) {
          setState(() {
            isDarkMode = value;
          });
        },
      );
  }
}

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  String savedEmail = "emaildousuario@gmail.com";
  String savedPassword = "senha_do_usuario";

  bool showEmail = false;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        centerTitle: true,
        iconTheme: IconThemeData(color: corBranca()),        
      ),
      body: ListView(
        children: [

          // // Privacidade

          // SettingsSection(
          //   title: 'Privacidade',
          //   children: [
          //     ListTile(
          //       leading: Icon(Icons.email),
          //       title: Text('Email'),
          //       subtitle: Text(showEmail ? savedEmail : '********'),
          //       trailing: IconButton(
          //         icon: Icon(showEmail ? Icons.visibility : Icons.visibility_off),
          //         onPressed: () {
          //           setState(() {
          //             showEmail = !showEmail;
          //           });
          //         },
          //       ),
          //     ),
          //     ListTile(
          //       leading: Icon(Icons.lock),
          //       title: Text('Senha'),
          //       subtitle: Text(showPassword ? savedPassword : '********'),
          //       trailing: IconButton(
          //         icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          //         onPressed: () {
          //           setState(() {
          //             showPassword = !showPassword;
          //           });
          //         },
          //       ),
          //     ),
          //   ],
          // ),
          // Divider(),

          // Notificações

          SettingsSection(
            title: 'Notificações',
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Ativar Notificações'),
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
          Divider(),

          // Temas

          SettingsSection(
            title: 'Tema',
            children: [
              ListTile(
                leading: Icon(Icons.brightness_6),
                title: Text('Modo Escuro'),
                trailing: Switch(
                  value: widget.isDarkMode,
                  onChanged: widget.onThemeChanged,
                ),
              ),
            ],
          ),
          Divider(),

          // Sobre

          SettingsSection(
            title: 'Outros',
            children: [
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Sobre'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Sobre o App'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TriOcupado'),
                            SizedBox(height: 10),
                            Text('Versão: 1.0.0'),
                            SizedBox(height: 10),
                            Text('© 2024 Globetrotter'),
                            SizedBox(height: 10),
                            Text(
                              'Este aplicativo foi desenvolvido para ajudar você a gerenciar, planejar e organizar as suas viagens.',
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.article),
                title: Text('Termos de Uso'),
                onTap: () {
                  _showDialog(context, 'Termos de Uso',
                      'Estes Termos de Uso regulam o uso do aplicativo (TriOcupado), fornecido pela nossa empresa (Globetrotter), para fins de planejamento e organização de viagens. Ao acessar ou usar o Aplicativo, você concorda em cumprir e estar vinculado a estes Termos. Se você não concorda com esses Termos, não utilize o Aplicativo.\n\n1. Uso do Aplicativo\n2. Conta de Usuário\n3. Privacidade e Coleta de Dados\n4. Conteúdo e Propriedade Intelectual\n5. Reservas e Transações\n6. Limitação de Responsabilidade\n7. Modificações no Aplicativo\n8. Rescisão\n9. Legislação Aplicável\n');
                },
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('Política de Privacidade'),
                onTap: () {
                  _showDialog(context, 'Política de Privacidade',
                      'Esta Política de Privacidade explica como o (TriOcupado) coleta, utiliza, armazena e compartilha suas informações pessoais quando você usa nosso aplicativo de planejamento de viagens. Ao usar nosso aplicativo, você concorda com a coleta e o uso de suas informações de acordo com esta política.\n\n'
                      'Informações que Coletamos: \n\n'
                      'Quando você utiliza o TriOcupado, coletamos diferentes tipos de informações:\n\n'
                      '• Informações Pessoais: Como nome, e-mail, número de telefone.\n\n'
                      '• Informações de Viagem: Detalhes sobre suas viagens planejadas, como destinos, datas, acomodações, atividades, meios de transporte e preferências de viagem.\n\n'
                      '• Informações de Localização: Se você permitir, podemos coletar sua localização para sugerir destinos ou serviços próximos, como hotéis ou atrações turísticas.\n\n'
                      '• Informações de Uso: Coletamos dados sobre como você interage com o aplicativo, como os recursos que você usa, tempo gasto no aplicativo e páginas acessadas.\n\n'
                      '• Informações de Dispositivo: Dados sobre seu dispositivo, como modelo, sistema operacional, identificadores únicos e endereço IP.\n\n');
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
              icon: Icon(Icons.close),
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
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          ...children,
        ],
      ),
    );
  }
}
