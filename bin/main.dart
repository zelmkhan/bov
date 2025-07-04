import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import 'package:collection/collection.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:cryptography/cryptography.dart';
import './models/bovclient.dart';
import './db/hive_db.dart';
import './functions/verify_signature.dart';

List<Bovclient> connectedClients = [];

Future<void> main() async {
  await HiveDb.init();

  final x25519 = X25519();
  final serverPublicKey = [50, 94, 144, 211, 230, 117, 118, 37, 126, 181, 52, 158, 152, 224, 24, 217, 245, 241, 245, 54, 204, 34, 184, 232, 166, 223, 217, 52, 75, 169, 232, 99];
  final serverPrivateKey = [216, 148, 95, 189, 69, 24, 198, 51, 254, 191, 122, 130, 136, 123, 232, 218, 90, 65, 200, 95, 14, 74, 46, 216, 75, 211, 221, 95, 78, 107, 67, 108];

  var handler = webSocketHandler((WebSocketChannel webSocket, _) async {
    final Uint8List nonce = genNonce();

    webSocket.sink.add([9, ...nonce, ...serverPublicKey]);

    final StreamSubscription subscription = webSocket.stream.listen((message) async {

      final messageBytes = message as List<int>;

      // Auth
      if (messageBytes.first == 0) {
        final List<int> ed25519pubkey = messageBytes.getRange(1, 33).toList();
        final List<int> x25519pubkey = messageBytes.getRange(33, 65).toList();
        final List<int> sharedSecret = messageBytes.getRange(65, 97).toList();
        final List<int> signature = messageBytes.getRange(97, 161).toList();

        final List<int> signedMessage = [
          ...nonce,
          ...x25519pubkey,
          ...sharedSecret,
        ];

        final isValidSignature = await verifySignature(
          message: signedMessage,
          publicKey: ed25519pubkey,
          signature: signature,
        );
        
        if (!isValidSignature) {
          webSocket.sink.add([4, 0]); // ошибка подписи
          webSocket.sink.close();
          return;
        }

        // вычисляем наш shared secret
        final sharedServerSecret = await x25519.sharedSecretKey(
          keyPair: SimpleKeyPairData(serverPrivateKey, publicKey: SimplePublicKey(serverPublicKey, type: KeyPairType.x25519), type: KeyPairType.x25519),
          remotePublicKey: SimplePublicKey(
            x25519pubkey,
            type: KeyPairType.x25519,
          ),
        );

        final computedSharedSecret = await sharedServerSecret.extractBytes();
        const eq = ListEquality<int>();

        if (!eq.equals(sharedSecret, computedSharedSecret)) {
          webSocket.sink.add([4, 0]); // sharedSecretHash не совпадает
          webSocket.sink.close();
          return;
        }

        // успех — добавляем клиента
        connectedClients.add(Bovclient(
          channel: webSocket,
          x25519pubkey: x25519pubkey,
        ));

        final messagesFromBusstop = await HiveDb.getMessagesFromBusstop(
          recepient: base58.encode(Uint8List.fromList(x25519pubkey)),
        );

        webSocket.sink.add([2, 0]);

        if (messagesFromBusstop.isEmpty) return;
        
        webSocket.sink.add([1, ...messagesFromBusstop]);
      }

      // Message relayer
      if (messageBytes.first == 1) {
        if (messageBytes.length > 4096) {
          webSocket.sink.add([4, 1]);
          return;
        }

        final List<int> recepientX25519PublicKey =
            messageBytes.getRange(65, 97).toList();

        final eq = const ListEquality();
        final checkConnected = connectedClients.where(
            (client) => eq.equals(client.x25519pubkey, recepientX25519PublicKey));

        if (checkConnected.isEmpty) {
          final String recepientBase58Pubkey =
              base58.encode(Uint8List.fromList(recepientX25519PublicKey));
          await HiveDb.sendMessageToBusstop(
              recepient: recepientBase58Pubkey, message: messageBytes);

          webSocket.sink.add([2, 1]);
          return;
        }

        checkConnected.first.channel.sink.add(messageBytes);
        webSocket.sink.add([2, 0]);
      }

    }, onDone: () {
      final disconnected =
          connectedClients.where((client) => client.channel == webSocket).firstOrNull;
      if (disconnected != null) {
        connectedClients.remove(disconnected);
      }
    }, onError: (err) {
      print(err);
    });

    webSocket.sink.done.then((_) => subscription.cancel());
  });

  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
  print('\x1B[32m♖ Serving at ws://${server.address.host}:${server.port}\x1B[0m');
}
