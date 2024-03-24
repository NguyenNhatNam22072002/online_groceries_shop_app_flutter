import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_groceries/model/my_order_model.dart';
import 'package:online_groceries/view/admin/order_view_model.dart';

class OrdersPage extends StatelessWidget {
  final OrdersViewModel ordersViewModel = Get.put(OrdersViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (ordersViewModel.newOrders.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else {
                return _buildOrdersList('New Orders', ordersViewModel.newOrders);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(String title, List<MyOrderModel> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return _buildOrderItem(orders[index]);
          },
        ),
      ],
    );
  }

  Widget _buildOrderItem(MyOrderModel order) {
    return ListTile(
      title: Text('Order ID: ${order.orderId}'),
      subtitle: Text('Total Price: ${order.totalPrice}'),
      // Add more details as needed
    );
  }
}
