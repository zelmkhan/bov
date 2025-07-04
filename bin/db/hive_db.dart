import 'package:hive/hive.dart';
import '../models/message.dart';

class HiveDb {
  
  static late LazyBox _busstopBox;

  static Future<void> init() async {
    Hive
    ..init('database')
    ..registerAdapter(MessageAdapter());

    _busstopBox = await Hive.openLazyBox<Message>("busstop_box");
  }

  static Future<void> sendMessageToBusstop({required String recepient, required List<int> message}) async {
    Message? messages = await _busstopBox.get(recepient);
    if (messages == null) {
      await _busstopBox.put(recepient, Message(
        base58X25519RecepientPubkey: recepient,
        message: [message]));
    }
    messages?.message.add(message);
    await _busstopBox.put(recepient, messages);
  }

  static Future<List<List<int>>> getMessagesFromBusstop({required String recepient}) async {
    Message? messages = await _busstopBox.get(recepient);
    if (messages == null) {
      return [];
    }
    return messages.message;
  }

  static Future<void> deleteMessagesFromBusstop({required String recepient}) async {
    Message? messages = await _busstopBox.get(recepient);
    if (messages == null) return;
    await _busstopBox.delete(recepient);
  }

}