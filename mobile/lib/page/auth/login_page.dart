import 'package:flutter/material.dart';
import 'package:mobile/auth/auth_storage.dart';
import 'package:mobile/page/tabs/main_tabs_page.dart';
import '../../auth/google_auth_service.dart';
import '../../grpc_client.dart';
import '../../generated/auth.pb.dart';
import '../../generated/auth.pbgrpc.dart';
import '../../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _client = GrpcClient();
  final _auth = GoogleAuthService();
  final _storage = AuthStorage();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      debugPrint('Iniciando login com Google...');

      final googleResult = await _auth.signIn();
      if (googleResult == null) {
        debugPrint('Login cancelado');
        return;
      }

      final response = await _client.auth.login(
        LoginRequest()..idToken = googleResult.idToken,
      );

      debugPrint('LOGIN OK: ${response.email}');
      await _storage.saveUser(response, photoUrl: googleResult.photoUrl);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainTabsPage()),
      );
    } catch (e, s) {
      debugPrint('Erro no login: $e');
      debugPrintStack(stackTrace: s);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao realizar login')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              _Logo(),
              const SizedBox(height: 24),
              const Text(
                'STRIDECLASH',
                style: TextStyle(
                  color: kNeonGreen,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Cada passo é território.\nCaminhe e capture o mapa.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
              ),
              const Spacer(flex: 4),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(_loading ? 'Entrando...' : 'Entrar com Google'),
                  onPressed: _loading ? null : _login,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

/// O mesmo alvo neon usado no ícone do app e no marcador de localização —
/// repetir esse símbolo aqui reforça a identidade visual logo na entrada.
class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      padding: const EdgeInsets.all(8),
      child: Image.asset('assets/icon/icon_foreground.png'),
    );
  }
}
