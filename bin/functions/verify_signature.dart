import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

verifySignature({required List<int> message, required List<int> publicKey, required List<int> signature}) async {
  final algorithm = Ed25519();
  return algorithm.verify(message, signature: Signature(signature, publicKey: SimplePublicKey(publicKey, type: KeyPairType.ed25519)));
}

genNonce() {
  final Uint8List nonce = Uint8List.fromList(List.generate(32, (_) => Random.secure().nextInt(256)));
  return nonce;
}