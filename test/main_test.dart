import 'package:test/scaffolding.dart';

import '../bin/db/hive_db.dart';


void main() {

  test("_", () async {
      await HiveDb.init();
      await HiveDb.sendMessageToBusstop(recepient: '9QFzmzKt2bSvK9SJamwhiLmZM1hHpCiXThuhHCqEPNVr', message: [1, 111, 187, 120, 20, 122, 68, 172, 71, 17, 172, 183, 183, 113, 97, 41, 91, 150, 228, 101, 212, 132, 194, 221, 138, 20, 179, 179, 98, 11,
5, 128, 149, 124, 210, 207, 105, 71, 35, 162, 131, 172, 15, 11, 103, 12, 2, 12, 133, 135, 11, 226, 172, 76, 55, 9, 29, 70, 85, 158, 144, 84, 130, 30,
125, 124, 210, 207, 105, 71, 35, 162, 131, 172, 15, 11, 103, 12, 2, 12, 133, 135, 11, 226, 172, 76, 55, 9, 29, 70, 85, 158, 144, 84, 130, 30, 125, 49,
19, 37, 17, 85, 189, 64, 186, 130, 41, 170, 62, 151, 47, 202, 126, 227, 56, 188, 114, 238, 170, 191, 226, 61, 63, 164, 245, 246, 50, 205, 203, 216,
156, 107, 43, 134, 217, 73, 228, 71, 146, 230, 119, 145, 240, 243, 184, 213, 24, 146, 139, 69, 97, 223, 74, 198, 3, 164, 183, 227, 10, 165, 12, 5, 15,
28, 248, 141, 140, 39, 144, 177, 108, 251, 200, 125, 160, 155, 28, 156, 6, 110, 31, 50, 164, 50, 54, 177, 12, 179, 138, 159, 148, 138, 213, 151, 1, 0,
0, 23, 135, 107, 45, 54]);
  });

  test("_", () async {
      //await HiveDb.init();
      final m = await HiveDb.getMessagesFromBusstop(recepient: '9QFzmzKt2bSvK9SJamwhiLmZM1hHpCiXThuhHCqEPNVr');
      print(m);
  });
  

}