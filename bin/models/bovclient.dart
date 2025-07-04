import 'package:web_socket_channel/web_socket_channel.dart';

class Bovclient {
  final List<int> x25519pubkey;
  final WebSocketChannel channel;

  Bovclient({required this.x25519pubkey, required this.channel});
}