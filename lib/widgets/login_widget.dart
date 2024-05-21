// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wishlify_app/controllers/auth_controller.dart';
import 'package:wishlify_app/utils.dart';

class LoginWidget extends StatelessWidget {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: TextFormField(
            controller: emailcontroller,
            style: textStyle(16, Colors.black, FontWeight.w500),
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(153, 158, 158, 158),
                hintText: "Email",
                hintStyle: textStyle(
                    16, Color.fromARGB(255, 42, 42, 42), FontWeight.w500),
                border: InputBorder.none),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: TextFormField(
            controller: passwordcontroller,
            style: textStyle(16, Colors.black, FontWeight.w500),
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(153, 158, 158, 158),
                hintText: "Password",
                hintStyle: textStyle(
                    16, Color.fromARGB(255, 42, 42, 42), FontWeight.w500),
                border: InputBorder.none),
          ),
        ),
        const SizedBox(height: 23),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 45,
          child: TextButton(
            onPressed: () => authController.loginuser(
                emailcontroller.text, passwordcontroller.text),
            style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 0, 255, 140)),
            child: Text(
              "Login",
              style: textStyle(20, Colors.white, FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
