// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wishlify_app/controllers/auth_controller.dart';
import 'package:wishlify_app/utils.dart';
import 'package:wishlify_app/widgets/login_widget.dart';
import 'package:wishlify_app/widgets/register_widget.dart';

class AuthScreen extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();

  AuthScreen({super.key});

  buildTab(text, selected, context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: 40,
      child: Center(
        child: Text(text,
            style: selected
                ? textStyle(
                    22, Color.fromARGB(255, 0, 255, 140), FontWeight.bold)
                : textStyle(22, Colors.black38, FontWeight.w500)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Text(
            "Wishify",
            style: textStyle(
                35, Color.fromARGB(255, 0, 255, 140), FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => authController.changeTab("Login"),
                  child: buildTab(
                      "Login", authController.tab.value == "Login", context),
                ),
                InkWell(
                  onTap: () => authController.changeTab("Register"),
                  child: buildTab("Register",
                      authController.tab.value == "Register", context),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() => authController.tab.value == "Login"
              ? LoginWidget()
              : RegisterWidget())
        ],
      )),
    ));
  }
}
