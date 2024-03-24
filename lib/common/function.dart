import 'package:online_groceries/model/user_model.dart';
import 'package:online_groceries/view/account/user_view_model.dart';

Future<UserModel?> getUserInfo(int userId) async {
  final userViewModel = UserViewModel();
  await userViewModel.fetchUserInfo(userId);
  return userViewModel.userInfo.value;
}
