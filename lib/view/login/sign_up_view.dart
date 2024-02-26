import 'package:email_auth/email_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../../common/color_extension.dart';
import '../../common_widget/line_textfield.dart';
import '../../common_widget/round_button.dart';
import '../../view_model/sign_up_view_model.dart';
import 'dart:convert';
import 'dart:math';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  final signUpVM = Get.put(SignUpViewModel());

  // late EmailAuth emailAuth;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize the package
  //   emailAuth = EmailAuth(
  //     sessionName: "Sample session",
  //   );
  //
  //   Map<String, String> remoteServerConfiguration = {
  //     'server': "smtp.gmail.com",
  //     'serverKey': "squypgyvjborbato"
  //   };
  //
  //   /// Configuring the remote server
  //   emailAuth.config(remoteServerConfiguration);
  // }
  // Future<void> sendOTP() async {
  //   try {
  //     bool result = await emailAuth.sendOtp(
  //       recipientMail: signUpVM.txtEmail.value.text,
  //       otpLength: 5,
  //     );
  //     if (result) {
  //       print('OTP sent successfully');
  //     } else {
  //       print('Failed to send OTP');
  //     }
  //   } catch (e) {
  //     print('Error sending OTP: $e');
  //   }
  // }
  //
  // void verifyOTP() async {
  //   var res = await emailAuth.validateOtp(recipientMail: signUpVM.txtEmail.value.text, userOtp: signUpVM.txtOTP.value.text);
  //   if(res) {
  //     signUpVM.serviceCallSignUp();
  //   } else {
  //     Get.snackbar(Globs.appName, "Invalid OPT");
  //   }
  // }

  String generateOTP() {
    // Sử dụng package crypto để tạo mã OTP ngẫu nhiên
    List<int> randomNumbers = List.generate(6, (index) => Random.secure().nextInt(10));

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
      ..recipients.add(signUpVM.txtEmail.value.text)
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
    String userEnteredOTP = signUpVM.txtOTP.value.text; // Get the user-entered OTP
    String generatedOTP = otp; // Retrieve the previously generated OTP

    if (userEnteredOTP == generatedOTP && generatedOTP != "") {
      // OTP is correct, proceed with sign-up logic
      print('OTP verified successfully');

      signUpVM.serviceCallSignUp();

      // Optionally, you may want to clear the OTP field after verification
      signUpVM.txtOTP.value.clear();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img/color_logo.png",
                        width: 40,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.15,
                  ),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 26,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: media.width * 0.03,
                  ),
                  Text(
                    "Enter your credentials to continue",
                    style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  LineTextField(
                    title: "Username",
                    placeholder: "Enter your username",
                    controller: signUpVM.txtUsername.value,
                  ),
                  SizedBox(
                    height: media.width * 0.07,
                  ),
                  LineTextField(
                    title: "Email",
                    placeholder: "Enter your email address",
                    controller: signUpVM.txtEmail.value,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16), // Khoảng cách giữa LineTextField và nút "Send OTP"
                  Row(
                    children: [
                      Expanded(
                        child: LineTextField(
                          title: "OTP",
                          placeholder: "Enter OTP",
                          controller: signUpVM.txtOTP.value,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 16), // Khoảng cách giữa LineTextField và nút "Send OTP"
                      ElevatedButton(
                        onPressed: () {
                          sendOTP();
                        },
                        child: Text("Send OTP"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.07,
                  ),
                  Obx(() => 
                  LineTextField(
                    title: "Password",
                    placeholder: "Enter your password",
                    controller: signUpVM.txtPassword.value,
                    obscureText: !signUpVM.isShowPassword.value,
                    right: IconButton(
                        onPressed: () {
                          signUpVM.showPassword();
                        },
                        icon: Icon(
                           !signUpVM.isShowPassword.value ? Icons.visibility_off : Icons.visibility,
                          color: TColor.textTittle,
                        )),
                  )),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      children: [
                        const TextSpan(text: "By continuing you agree to our "),
                        TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("Terms of Service Click");
                              }),
                        const TextSpan(text: " and "),
                        TextSpan(
                            text: "Privacy Policy.",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("Privacy Policy Click");
                              })
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  RoundButton(
                    title: "Sign Up",
                    onPressed: () {
                      verifyOTP();
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Sign In",
                                style: TextStyle(
                                    color: TColor.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
