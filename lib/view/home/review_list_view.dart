import 'package:flutter/material.dart';
import 'package:online_groceries/model/review_model.dart';

class ReviewListView extends StatelessWidget {
  final List<ReviewDetailModel> reviewList;



  const ReviewListView({Key? key, required this.reviewList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reviewList.length,
      itemBuilder: (context, index) {
        final review = reviewList[index];
        final int? rating = review.rating;

        // Tạo danh sách các biểu tượng ngôi sao tương ứng với số sao
        List<Widget> starIcons = [];
        if (rating != null) {
          for (int i = 0; i < rating; i++) {
            starIcons.add(Icon(Icons.star, color: Colors.amber));
          }
        } else {
          starIcons.add(Text('N/A'));
        }

        return ListTile(
          leading: CircleAvatar(
            child: Image.asset(
              "assets/img/u1.png",
              width: 60,
              height: 60,
            ),
          ),
          title: Row(
            children: [
              Text(review.username.toString() ?? 'Unknown User'), // Hiển thị tên người đánh giá
              SizedBox(width: 10), // Khoảng cách giữa tên và biểu tượng sao
              ...starIcons, // In ra các biểu tượng ngôi sao
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(review.comment ?? ''),
              Text(
                'Created at: ${review.createdAt != null ? review.createdAt!.toLocal().toString() : 'N/A'}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
