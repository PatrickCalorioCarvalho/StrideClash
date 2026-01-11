import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grpc/grpc.dart';
import 'generated/championship.pbgrpc.dart';
import 'generated/auth.pbgrpc.dart';


class GrpcClient {
  late ChampionshipServiceClient championship;
  late AuthServiceClient auth;
  GrpcClient() {
    final channel = ClientChannel(
      dotenv.env['GRPC_HOST']!,
      port: int.parse(dotenv.env['GRPC_PORT']!),
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    championship = ChampionshipServiceClient(channel);
    auth = AuthServiceClient(channel);
  }
}