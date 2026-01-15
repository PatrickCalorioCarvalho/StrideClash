import 'package:flutter/material.dart';
import 'package:mobile/auth/auth_storage.dart';
import 'package:mobile/page/tabs/main_tabs_page.dart';
import '../../auth/google_auth_service.dart';
import '../../grpc_client.dart';
import '../../generated/auth.pb.dart';
import '../../generated/auth.pbgrpc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _client = GrpcClient();
  final _auth = GoogleAuthService();
  final _storage = AuthStorage();

  Future<void> login(BuildContext context) async {
    try {
      debugPrint('Iniciando login com Google...');

      final idToken = await _auth.signIn();

      if (idToken == null) {
        debugPrint('Login cancelado');
        return;
      }

      final response = await _client.auth.login(
        LoginRequest()..idToken = idToken,
      );

      debugPrint('LOGIN OK: ${response.email}');
      
      await _storage.saveUser(response);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainTabsPage(),
        ),
      );
    } catch (e, s) {
      debugPrint('Erro no login: $e');
      debugPrintStack(stackTrace: s);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao realizar login'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Entrar com Google'),
          onPressed: () => login(context),
        ),
      ),
    );
  }
}
