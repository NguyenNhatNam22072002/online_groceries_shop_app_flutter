import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:online_groceries/common/globs.dart';
import 'package:online_groceries/common/service_call.dart';
import 'package:online_groceries/model/product_detail_model.dart';
import 'package:online_groceries/view/search/filter_parameters.dart';

import '../model/offer_product_model.dart';
import '../model/type_model.dart';

class HomeViewModel extends GetxController {

  final RxList<OfferProductModel> offerArr = <OfferProductModel>[].obs; 
  final RxList<OfferProductModel> bestSellingArr = <OfferProductModel>[].obs;
  final RxList<TypeModel> groceriesArr = <TypeModel>[].obs;
  final RxList<OfferProductModel> listArr = <OfferProductModel>[].obs;

  final RxList<OfferProductModel> listArrSearch = <OfferProductModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    if (kDebugMode) {
      print("HomeViewModel Init ");
    }

    serviceCallHomeExlusiveOffer();
    serviceCallHomeBestSelling();
    serviceCallHomeGroceries();
    serviceCallHomeAllProducts();

  }

  int _currentExlusiveOfferPage = 0;
  //ServiceCall
  void serviceCallHomeExlusiveOffer() {

    _currentExlusiveOfferPage++;

    Globs.showHUD();
    ServiceCall.post({
      'page': _currentExlusiveOfferPage.toString(),
    }, SVKey.svHomeExlusiveOffer, isToken: true, withSuccess: (resObj) async {
      Globs.hideHUD();

      if (resObj[KKey.status] == "1") {
        var payload = resObj[KKey.payload] as Map? ?? {};

        var offerDataArr = (payload["offer_list"] as List? ?? []).map((oObj) {
            return OfferProductModel.fromJson(oObj);
        }).toList();
        offerArr.value = offerDataArr;
      } else {}
      
    }, failure: (err) async {
      Globs.hideHUD();
      Get.snackbar(Globs.appName, err.toString());
    });
  }

  int _currentBestSellingPage = 0;

  void serviceCallHomeBestSelling() {

    _currentBestSellingPage++;

    Globs.showHUD();
    ServiceCall.post({
      'page': _currentBestSellingPage.toString(),
    }, SVKey.svHomeBestSelling, isToken: true, withSuccess: (resObj) async {
      Globs.hideHUD();

      if (resObj[KKey.status] == "1") {
        var payload = resObj[KKey.payload] as Map? ?? {};

        var bestSellingDataArr = (payload["best_sell_list"] as List? ?? []).map((oObj) {
          return OfferProductModel.fromJson(oObj);
        }).toList();

        bestSellingArr.addAll(bestSellingDataArr);

      } else {}

    }, failure: (err) async {
      Globs.hideHUD();
      Get.snackbar(Globs.appName, err.toString());
    });
  }

  void serviceCallHomeGroceries() {

    Globs.showHUD();
    ServiceCall.post({

    }, SVKey.svHomeGroceries, isToken: true, withSuccess: (resObj) async {
      Globs.hideHUD();

      if (resObj[KKey.status] == "1") {
        var payload = resObj[KKey.payload] as Map? ?? {};

        var typeDataArr =
        (payload["type_list"] as List? ?? []).map((oObj) {
          return TypeModel.fromJson(oObj);
        }).toList();

        groceriesArr.value = typeDataArr;

      } else {}


    }, failure: (err) async {
      Globs.hideHUD();
      Get.snackbar(Globs.appName, err.toString());
    });
  }

  int _currentAllPage = 0;

  void serviceCallHomeAllProducts() {
    // Increment the current page
    _currentAllPage++;

    // Perform the service call to fetch more items using the updated page number
    Globs.showHUD();
    ServiceCall.post({
      'page': _currentAllPage.toString(),
    }, SVKey.svHomeAllProducts, isToken: true, withSuccess: (resObj) async {
      Globs.hideHUD();

      if (resObj[KKey.status] == '1') {
        var payload = resObj[KKey.payload] as Map? ?? {};

        var moreItems = (payload['list'] as List? ?? []).map((oObj) {
          return OfferProductModel.fromJson(oObj);
        }).toList();

        // Append the new items to the existing list
        listArr.addAll(moreItems);
      } else {
        // Handle other cases if needed
      }
    }, failure: (err) async {
      Globs.hideHUD();
      Get.snackbar(Globs.appName, err.toString());
    });
  }

  void serviceCallListSearch(String keyword) {
    Globs.showHUD();
    ServiceCall.post(
      {
        "keyword": keyword,
        "minPrice": FilterParameters.minPrice,
        "maxPrice": FilterParameters.maxPrice,
      }, // Pass the keyword to the API
      SVKey.svSearchProduct,
      isToken: true,
      withSuccess: (resObj) async {
        Globs.hideHUD();

        if (resObj[KKey.status] == "1") {
          var listDataArr = (resObj[KKey.payload] as List? ?? []).map((oObj) {
            return OfferProductModel.fromJson(oObj);
          }).toList();
          print("Before update: ${listArrSearch.length}");
          listArrSearch.value = listDataArr;
          print("After update: ${listArrSearch.length}");
        } else {
          // Handle other cases if needed
        }
      },
      failure: (err) async {
        Globs.hideHUD();
        Get.snackbar(Globs.appName, err.toString());
      },
    );
  }

}
