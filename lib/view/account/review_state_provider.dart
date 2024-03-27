import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

// Tạo một enum để đại diện cho trạng thái đã đánh giá
enum ReviewState { notReviewed, reviewed }

// Tạo một Provider để quản lý trạng thái đã đánh giá của từng sản phẩm
class ReviewStateProvider extends ChangeNotifier {
  Map<int, ReviewState> _reviewStates = {};

  // Getter để lấy trạng thái đã đánh giá của một sản phẩm
  ReviewState getReviewState(int? productId) {
    return _reviewStates[productId] ?? ReviewState.notReviewed;
  }

  // Setter để cập nhật trạng thái đã đánh giá của một sản phẩm
  void setReviewState(int? productId, ReviewState state) {
    _reviewStates[productId!] = state;
    notifyListeners();
  }
}
