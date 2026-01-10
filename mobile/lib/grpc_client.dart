import 'package:grpc/grpc.dart';
import 'generated/championship.pbgrpc.dart';


class GrpcClient {
  late ChampionshipServiceClient championship;

  GrpcClient() {
    final channel = ClientChannel(
      '192.168.18.49',
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    championship = ChampionshipServiceClient(channel);
  }
}