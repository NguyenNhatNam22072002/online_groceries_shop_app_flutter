import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_groceries/model/offer_product_model.dart';

class ProductCell2 extends StatelessWidget {
  final OfferProductModel pObj;
  final VoidCallback onPressed;
  final VoidCallback onCart;

  ProductCell2({super.key,
    required this.pObj,
    required this.onPressed,
    required this.onCart});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Left section with image
          Container(
            width: screenWidth / 3, // Adjust the width as needed
            height: double.infinity,
            child: CachedNetworkImage(
              imageUrl: pObj.image ?? "",
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 100,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 16.0),

          // Middle section with product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pObj.name ?? "",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  "${pObj.unitValue}${pObj.unitName}",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.0),

          // Right section with the add button
          Container(
            width: 40.0, // Adjust the width as needed
            height: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
