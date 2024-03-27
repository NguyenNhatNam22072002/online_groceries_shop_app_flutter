import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_groceries/common/color_extension.dart';
import 'package:online_groceries/common/globs.dart';
import 'package:online_groceries/model/product_detail_model.dart';
import 'package:online_groceries/view/account/review_state_provider.dart';
import 'package:online_groceries/view_model/review_view_model.dart';
import 'package:provider/provider.dart';

class ProductReviewScreen extends StatefulWidget {

  final ProductDetailModel pObj;

  ProductReviewScreen({required this.pObj});

  @override
  _ProductReviewScreenState createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  int _rating = 0;
  final reviewVM = Get.put(ReviewViewModel());
  final TextEditingController _commentController = TextEditingController();

  Widget _buildStar(int index) {
    if (_rating >= index) {
      return IconButton(
        onPressed: () {
          setState(() {
            _rating = index;
          });
        },
        icon: Icon(Icons.star, color: Colors.amber),
      );
    } else {
      return IconButton(
        onPressed: () {
          setState(() {
            _rating = index;
          });
        },
        icon: Icon(Icons.star_border),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 20,
            height: 20,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Product Reviews",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {

              int userId = await Globs.getUserId() ?? 0; // Sử dụng await và kiểm tra giá trị trước khi gán cho userId
              // Lấy productId từ đâu đó
              int productId = widget.pObj.prodId!;
              String comment = _commentController.text;
              int rating = _rating;
              String? userName = await Globs.getUsername();

              // Gọi hàm addProductReview từ ReviewViewModel
              if (userName != null) {
                reviewVM.addProductReview(userId, productId, comment, rating, userName);
              }

              // Thông báo cho ReviewStateProvider về trạng thái đã đánh giá
              Provider.of<ReviewStateProvider>(context, listen: false)
                  .setReviewState(productId, ReviewState.reviewed);

              Get.back();
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your rating:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(5, (index) => _buildStar(index + 1)),
            ),
            SizedBox(height: 20),
            Text(
              'Your comments:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _commentController, // Sử dụng controller để lấy giá trị từ TextField
                maxLines: null, // Cho phép nhiều dòng
                decoration: InputDecoration(
                  hintText: 'Enter your comments:',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
