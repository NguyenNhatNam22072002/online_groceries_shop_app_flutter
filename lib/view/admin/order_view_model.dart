import 'dart:convert'; // Import dart:convert library

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:online_groceries/common/globs.dart';
import 'package:online_groceries/model/my_order_model.dart';
import 'package:http/http.dart' as http;

class OrdersViewModel extends GetxController {
  final RxList<MyOrderModel> newOrders = <MyOrderModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print("MyOrdersViewModel Init ");
    }
    newOrdersList();
  }

  // ServiceCall
  void newOrdersList() async {
    Globs.showHUD();

    // Lấy auth_token từ nơi bạn đã lưu trữ sau khi đăng nhập thành công
    String? authToken = await Globs.getAuthToken();

    if (authToken == null) {
      // Xử lý trường hợp auth_token không tồn tại
      return;
    }

    Map<String, String> headers = {
      'Authorization': 'Bearer $authToken', // Include the token in the header
    };

    try {
      var response = await http.post(
        Uri.parse(SVKey.newOrdersList), // Replace with your API endpoint
        headers: headers,
        body: {}, // Add your request body here
      );

      Globs.hideHUD();

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        if (responseBody[KKey.status] == "1") {
          var listDataArr = (responseBody[KKey.payload] as List? ?? []).map((oObj) {
            return MyOrderModel.fromJson(oObj);
          }).toList();
          newOrders.value = listDataArr;
        } else {
          // Handle error response
        }
      } else {
        // Handle HTTP error
      }
    } catch (error) {
      Globs.hideHUD();
      Get.snackbar(Globs.appName, error.toString());
    }
  }

}
