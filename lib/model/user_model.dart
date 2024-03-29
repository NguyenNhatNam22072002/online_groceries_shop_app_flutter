import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final int userId;
  final String username;
  final int userType;
  final String name;
  final String email;
  final String mobile;
  final String mobileCode;
  final String password;
  final int areaId;
  final String authToken;
  final String deviceToken;
  final String resetCode;
  final int status;
  final DateTime createdDate;
  final DateTime modifyDate;
  final int coin;

  UserModel({
    required this.userId,
    required this.username,
    required this.userType,
    required this.name,
    required this.email,
    required this.mobile,
    required this.mobileCode,
    required this.password,
    required this.areaId,
    required this.authToken,
    required this.deviceToken,
    required this.resetCode,
    required this.status,
    required this.createdDate,
    required this.modifyDate,
    required this.coin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      userType: json['user_type'] ?? 1,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      mobileCode: json['mobile_code'] ?? '',
      password: json['password'] ?? '',
      areaId: json['area_id'] ?? 0,
      authToken: json['auth_token'] ?? '',
      deviceToken: json['device_token'] ?? '',
      resetCode: json['reset_code'] ?? '0000',
      status: json['status'] ?? 1,
      createdDate: DateTime.parse(json['created_date'] ?? DateTime.now().toString()),
      modifyDate: DateTime.parse(json['modify_date'] ?? DateTime.now().toString()),
      coin: json['coin'] ?? 0,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'user_type': userType,
      'name': name,
      'email': email,
      'mobile': mobile,
      'mobile_code': mobileCode,
      'password': password,
      'area_id': areaId,
      'auth_token': authToken,
      'device_token': deviceToken,
      'reset_code': resetCode,
      'status': status,
      'created_date': createdDate.toIso8601String(),
      'modify_date': modifyDate.toIso8601String(),
      'coin': coin,
    };
  }

  // Chuyển đổi UserModel thành chuỗi JSON
  String toJsonString() {
    return json.encode({
      'user_id': userId,
      'username': username,
      'user_type': userType,
      'name': name,
      'email': email,
      'mobile': mobile,
      'mobile_code': mobileCode,
      'password': password,
      'area_id': areaId,
      'auth_token': authToken,
      'device_token': deviceToken,
      'reset_code': resetCode,
      'status': status,
      'created_date': createdDate.toIso8601String(),
      'modify_date': modifyDate.toIso8601String(),
      'coin': coin,
    });
  }

  // Tạo UserModel từ chuỗi JSON
  static UserModel fromJsonString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return UserModel(
      userId: json['user_id'],
      username: json['username'],
      userType: json['user_type'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'] ?? '',
      mobileCode: json['mobile_code'] ?? '',
      password: json['password'] ?? '',
      areaId: json['area_id'] ?? 0,
      authToken: json['auth_token'] ?? '',
      deviceToken: json['device_token'] ?? '',
      resetCode: json['reset_code'] ?? '0000',
      status: json['status'] ?? 1,
      createdDate: DateTime.parse(json['created_date'] ?? DateTime.now().toString()),
      modifyDate: DateTime.parse(json['modify_date'] ?? DateTime.now().toString()),
      coin: json['coin'] ?? 0,
    );
  }
}
