import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grpc/grpc.dart';
import 'generated/championship.pbgrpc.dart';
import 'generated/auth.pbgrpc.dart';
import 'generated/walk.pbgrpc.dart';


class GrpcClient {
  late ChampionshipServiceClient championship;
  late AuthServiceClient auth;
  late WalkServiceClient walk;
  GrpcClient() {
    final host = dotenv.env['GRPC_HOST'];
    final port = dotenv.env['GRPC_PORT'];
    if (host == null || host.isEmpty || port == null || port.isEmpty) {
      throw StateError(
        'mobile/.env sem GRPC_HOST/GRPC_PORT — esse build foi gerado sem '
        'as variáveis de ambiente configuradas (secrets do CI ausentes).',
      );
    }

    // GRPC_USE_TLS=true quando o destino é o túnel ngrok (que termina TLS
    // na borda e expõe https://...) — pro backend direto (dev local/LAN,
    // sem TLS nenhum), deixe em branco/false pra usar o canal insecure.
    final useTls = dotenv.env['GRPC_USE_TLS']?.toLowerCase() == 'true';

    final channel = ClientChannel(
      host,
      port: int.parse(port),
      options: ChannelOptions(
        credentials: useTls
            ? const ChannelCredentials.secure()
            : const ChannelCredentials.insecure(),
      ),
    );
    championship = ChampionshipServiceClient(channel);
    auth = AuthServiceClient(channel);
    walk = WalkServiceClient(channel);
  }
}