import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:online_groceries/view/login/select_location_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/line_textfield.dart';
import '../../view_model/forgot_password_view_model.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final forgotVM = Get.put(ForgotPasswordViewModel());

  String generateOTP() {
    // Sử dụng package crypto để tạo mã OTP ngẫu nhiên
    List<int> randomNumbers = List.generate(4, (index) => Random.secure().nextInt(10));

    // Chuyển danh sách số thành chuỗi
    String randomOTP = randomNumbers.join();
    // Trả về mã OTP
    return randomOTP;
  }
  String otp="";

  void sendOTP() async {
    String username = 'ht25022002@gmail.com'; // Thay bằng email của bạn
    String password = 'squypgyvjborbato'; // Thay bằng mật khẩu của bạn

    otp = generateOTP();

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(forgotVM.txtEmail.value.text)
      ..subject = 'Your OTP for sign up'
      ..text = 'Your OTP is: $otp';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());

      // Hiển thị thông báo rằng OTP đã được gửi thành công
      print('OTP sent successfully');
    } on MailerException catch (e) {
      print('Message not sent. $e');

      // Hiển thị thông báo nếu gửi OTP thất bại
      print('Failed to send OTP. Please try again.');
    }
    // signUpVM.saveOTP(otp);
  }

  void verifyOTP() {
    String userEnteredOTP = forgotVM.txtOTP.value.text; // Get the user-entered OTP
    String generatedOTP = otp; // Retrieve the previously generated OTP

    if (userEnteredOTP == generatedOTP && generatedOTP != "") {
      // OTP is correct, proceed with sign-up logic
      print('OTP verified successfully');

      forgotVM.serviceCallVerify();

    } else {
      // Incorrect OTP, show an error message
      print('Incorrect OTP. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Stack(children: [
      Container(
        color: Colors.white,
        child: Image.asset("assets/img/bottom_bg.png",
            width: media.width, height: media.height, fit: BoxFit.cover),
      ),
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                "assets/img/back.png",
                width: 20,
                height: 20,
              )),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  Text(
                    "Enter your 4-digit code",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 26,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LineTextField(
                      title: "Code",
                      placeholder: " - - - -",
                      controller: forgotVM.txtOTP.value),
                  SizedBox(
                    height: media.width * 0.3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            sendOTP();
                          },
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                            // forgotVM.serviceCallVerify();
                          verifyOTP();
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: TColor.primary,
                              borderRadius: BorderRadius.circular(30)),
                          child: Image.asset(
                            "assets/img/next.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
