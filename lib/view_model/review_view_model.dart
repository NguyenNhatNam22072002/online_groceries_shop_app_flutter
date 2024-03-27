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


  void addProductReview(int uid, int prodid, String cmt, int rating, String uName) async {
    // Kiểm tra xem các giá trị có null không
    if (prodid == null || uid == null || cmt == null || rating == null || uName == null) {
      Get.snackbar(Globs.appName, "Please provide all necessary information");
      return; // Dừng hàm nếu có bất kỳ giá trị nào là null
    }

    Globs.showHUD();
    // Tạo dữ liệu gửi đi
    Map<String, dynamic> requestData = {
      "user_id": uid.toString(),
      "product_id": prodid.toString(),
      "comment": cmt.toString(),
      "rating": rating.toString(),
      "user_name": uName.toString(),
    };

    ServiceCall.post(requestData, SVKey.svAddReview, isToken: true,
        withSuccess: (resObj) async {
          Globs.hideHUD();

          if (resObj[KKey.status] == "1") {
            Get.snackbar(Globs.appName, resObj[KKey.message]);
          } else {
            // Xử lý trường hợp không thành công nếu cần
          }
        }, failure: (err) async {
          Globs.hideHUD();
          Get.snackbar(Globs.appName, err.toString());
        });
  }

}
