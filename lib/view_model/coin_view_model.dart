import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:online_groceries/common/globs.dart';
import 'package:online_groceries/common/service_call.dart';

class CoinViewModel extends GetxController {
  void addCoin(int userId) {
    Globs.showHUD();
    ServiceCall.post({"user_id": userId.toString()}, SVKey.svAddCoin, isToken: true,
        withSuccess: (resObj) async {
          Globs.hideHUD();

          if (resObj["status"] == "1") {
            Get.snackbar(Globs.appName, resObj["message"]);
          } else {
            Get.snackbar(Globs.appName, "Failed to add coin");
          }
        }, failure: (err) async {
          Globs.hideHUD();
          Get.snackbar(Globs.appName, err.toString());
        });
  }

  void useCoin(int userId) {
    Globs.showHUD();
    ServiceCall.post({"user_id": userId.toString()}, SVKey.svUseCoin, isToken: true,
        withSuccess: (resObj) async {
          Globs.hideHUD();

          if (resObj["status"] == "1") {
            Get.snackbar(Globs.appName, resObj["message"]);
          } else {
            Get.snackbar(Globs.appName, "Failed to use coin for this order");
          }
        }, failure: (err) async {
          Globs.hideHUD();
          Get.snackbar(Globs.appName, err.toString());
        });
  }
}
