import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message {
  @HiveField(0)
  final String base58X25519RecepientPubkey;
  @HiveField(1)
  List<List<int>> message;

  Message({required this.base58X25519RecepientPubkey, required this.message});
}