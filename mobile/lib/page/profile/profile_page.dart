import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Bem-vindo 👋',
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 16),
            Text('Última caminhada: —'),
            Text('Campeonato ativo: —'),
          ],
        ),
      ),
    );
  }
}
