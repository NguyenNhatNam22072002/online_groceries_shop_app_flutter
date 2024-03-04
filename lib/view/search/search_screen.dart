import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_groceries/common_widget/product_cell.dart';
import 'package:online_groceries/model/search_model.dart';
import 'package:online_groceries/view/home/product_details_view.dart';
import 'package:online_groceries/view_model/cart_view_model.dart';

class SearchScreen extends StatelessWidget {
  final String keyword;

  final searchM = Get.put(SearchModel(keyword: ""));

  SearchScreen({required this.keyword}) {
    searchM.updateKeyword(keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
        // ... (phần code hiển thị nút lọc, v.v.)
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min, // Set mainAxisSize to MainAxisSize.min
        children: [
          // Danh sách sản phẩm tìm kiếm
          Flexible(
            child: ListView.builder(
              itemCount: searchM.listArrSearch.length,
              itemBuilder: (context, index) {
                var pObj = searchM.listArrSearch[index];

                return Flexible( // Use Flexible instead of Expanded
                  child: ProductCell(
                    pObj: pObj,
                    onPressed: () async {
                      await Get.to(() => ProductDetails(
                        pObj: pObj,
                      ));

                      searchM.serviceCallListSearch(keyword);
                    },
                    onCart: () {
                      CartViewModel.serviceCallAddToCart(
                        pObj.prodId ?? 0,
                        1,
                            () {},
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // Bộ lọc theo giá (hoặc bất kỳ bộ lọc nào bạn muốn thêm)
          // ...
        ],
      ),
    );
  }
}
