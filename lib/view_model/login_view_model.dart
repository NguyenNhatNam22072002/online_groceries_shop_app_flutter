import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_groceries/common/globs.dart';
import 'package:online_groceries/common/service_call.dart';
import 'package:online_groceries/view/main_tabview/main_tabview.dart';
import 'package:online_groceries/view_model/splash_view_model.dart';

class LoginViewModel extends GetxController {
  final txtEmail = TextEditingController().obs;
  final txtPassword = TextEditingController().obs;
  final isShowPassword = false.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    if (kDebugMode) {
      print("LoginViewModel Init ");
    }
    txtEmail.value.text = "test@gmail.com";
    txtPassword.value.text = "123456";
  }

  //ServiceCall
  void serviceCallLogin() {

     if (!GetUtils.isEmail(txtEmail.value.text)) {
      Get.snackbar(Globs.appName, "Pleaser enter valid email address");
      return;
    }

    if (txtPassword.value.text.length < 6) {
      Get.snackbar(
          Globs.appName, "Pleaser enter valid password min 6 character");
      return;
    }

      Globs.showHUD();

      ServiceCall.post({
        "email": txtEmail.value.text,
        "password": txtPassword.value.text,
        "dervice_token": ""
      }, SVKey.svLogin, withSuccess: (resObj) async {
        Globs.hideHUD();

        if( resObj[KKey.status] == "1"  ) {
          var payload = resObj[KKey.payload] as Map? ?? {};

          // Sau khi đăng nhập thành công và nhận được auth_token từ phản hồi
          String authToken = payload['auth_token']; // Thay 'your_auth_token_here' bằng auth_token nhận được từ phản hồi
          int userId = payload['user_id'];
          String userName = payload['username'];

          // In ra auth_token
          print('user ID: $userName');

          // Lưu trữ auth_token
          Globs.saveAuthToken(authToken);
          Globs.saveUsername(userName);
          Globs.saveUserId(userId);

          Globs.udSet(payload, Globs.userPayload);
          Globs.udBoolSet(true, Globs.userLogin);
          
          Get.delete<LoginViewModel>();
          Get.find<SplashViewModel>().goAfterLoginMainTab();
          
        }else{

        }

        Get.snackbar(Globs.appName, resObj["message"].toString());
      }, failure: (err) async {
         Globs.hideHUD();
          Get.snackbar(Globs.appName, err.toString());
      } );
    

  }

  void showPassword() {
    isShowPassword.value = !isShowPassword.value;
  }
}
