import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_groceries/common/color_extension.dart';
import 'package:online_groceries/model/product_detail_model.dart';
import 'package:online_groceries/view/account/review_state_provider.dart';
import 'package:online_groceries/view/account/review_view.dart';
import 'package:provider/provider.dart';

class OrderItemRow extends StatelessWidget {
  final ProductDetailModel pObj;
  final bool allowReview; // Tham số boolean cho phép kiểm tra trạng thái đơn hàng

  const OrderItemRow({super.key, required this.pObj, required this.allowReview});

  @override
  Widget build(BuildContext context) {

    final reviewStateProvider = Provider.of<ReviewStateProvider>(context);
    final reviewState = reviewStateProvider.getReviewState(pObj.prodId);

    return InkWell(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: pObj.image ?? "",
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 80,
                  height: 65,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pObj.name ?? "",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${pObj.unitValue}${pObj.unitName} Price",
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "QTY :",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            (pObj.qty ?? 0).toString(),
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "×",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "\$${(pObj.itemPrice ?? 0).toStringAsFixed(2)}",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Text(
                            "\$${(pObj.totalPrice ?? 0).toStringAsFixed(2)}",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: reviewState == ReviewState.reviewed
                  ? Padding(
                padding: const EdgeInsets.all(0.5),
                child: ElevatedButton(
                  onPressed: null,
                  child: Text(
                    'Reviewed',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.all(0.5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductReviewScreen(pObj: pObj)),
                    ).then((_) {
                      // Sau khi quay lại từ trang đánh giá, cập nhật trạng thái đã đánh giá và thông báo cho Provider
                      reviewStateProvider.setReviewState(pObj.prodId, ReviewState.reviewed);
                    });
                  },
                  child: Text(
                    'Review',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),


    );
  }
}
