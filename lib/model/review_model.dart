class ReviewDetailModel {
  int? id;
  int? userId;
  int? productId;
  String? comment;
  int? rating;
  DateTime? createdAt;
  String? username;

  ReviewDetailModel({
    this.id,
    this.userId,
    this.productId,
    this.comment,
    this.rating,
    this.createdAt,
    this.username,
  });

  ReviewDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    comment = json['comment'];
    rating = json['rating'];
    if (json['created_at'] != null) {
      // Parse string to DateTime
      createdAt = DateTime.parse(json['created_at']);
    }
    username = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['user_id'] = userId;
    data['product_id'] = productId;
    data['comment'] = comment;
    data['rating'] = rating;
    data['created_at'] = createdAt?.toIso8601String();
    data['user_name'] = username;

    return data;
  }
}
