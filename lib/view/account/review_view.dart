import 'package:flutter/material.dart';
import 'package:online_groceries/common/color_extension.dart';

class ProductReviewScreen extends StatefulWidget {
  @override
  _ProductReviewScreenState createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  int _rating = 0;

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
            onPressed: () {
              // Xử lý sự kiện khi nhấn nút "Submit"
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

