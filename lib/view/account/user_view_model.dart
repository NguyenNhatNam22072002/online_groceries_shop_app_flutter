import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:online_groceries/common/globs.dart';
import 'package:online_groceries/common/service_call.dart';
import 'package:online_groceries/model/user_model.dart';

class UserViewModel extends GetxController {
  final Rx<UserModel?> userInfo = Rx<UserModel?>(null); // Thông tin người dùng
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print("UserViewModel Init ");
    }
  }

  Future<void> fetchUserInfo(int userId) async {
    Globs.showHUD();
    // Tạo dữ liệu gửi đi
    Map<String, dynamic> requestData = {
      'user_id': userId.toString(),
    };

    ServiceCall.post(requestData, SVKey.svUserInfo, isToken: true,
        withSuccess: (resObj) async {
          Globs.hideHUD();

          if (resObj[KKey.status] == "1") {
            // Nếu request thành công, chuyển đổi dữ liệu từ JSON sang đối tượng UserModel
            UserModel user = UserModel.fromJson(resObj[KKey.payload]);
            userInfo.value = user; // Cập nhật thông tin người dùng
            print(userInfo);
          } else {
            // Xử lý trường hợp không thành công nếu cần
          }
        }, failure: (err) async {
          Globs.hideHUD();
          Get.snackbar(Globs.appName, err.toString());
        });
  }
}
