import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:online_groceries/common/globs.dart';
import 'package:online_groceries/common/service_call.dart';
import 'package:online_groceries/model/review_model.dart';

class ReviewViewModel extends GetxController {
  final RxList<ReviewDetailModel> reviewList = <ReviewDetailModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print("ReviewViewModel Init ");
    }

  }

  void fetchProductReviews(String productId) async {
    Globs.showHUD();
    // Tạo dữ liệu gửi đi
    Map<String, dynamic> requestData = {
      'product_id': productId,
    };

    ServiceCall.post(requestData, SVKey.svReviewsList, isToken: true,
        withSuccess: (resObj) async {
          Globs.hideHUD();

          if (resObj[KKey.status] == "1") {
            var listDataArr = (resObj[KKey.payload] as List? ?? []).map((oObj) {
              return ReviewDetailModel.fromJson(oObj);
            }).toList();

            reviewList.value = listDataArr;
            print(reviewList);
          } else {
            // Xử lý trường hợp không thành công nếu cần
          }
        }, failure: (err) async {
          Globs.hideHUD();
          Get.snackbar(Globs.appName, err.toString());
        });
  }


// void addProductReview(Map<String, dynamic> reviewData) async {
  //   try {
  //     isLoading.value = true;
  //     var url = Uri.parse('http://your_api_base_url/api/app/add_product_review');
  //     var response = await http.post(url, body: reviewData);
  //
  //     if (response.statusCode == 200) {
  //       var jsonResponse = json.decode(response.body);
  //       if (jsonResponse['status'] == '1') {
  //         // Refresh reviews after adding a new one
  //         fetchProductReviews(reviewData['product_id']);
  //       } else {
  //         // Handle error message
  //         print(jsonResponse['message']);
  //       }
  //     } else {
  //       print('Request failed with status: ${response.statusCode}.');
  //     }
  //   } catch (e) {
  //     print('Exception occurred while adding review: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
