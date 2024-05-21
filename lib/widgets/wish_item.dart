import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wishlify_app/controllers/home_controller.dart';
import 'package:wishlify_app/models/wish_model.dart';
import 'package:wishlify_app/utils.dart';

class WishItem extends StatelessWidget {
  final Wish wish;
  WishItem(this.wish);

  @override
  Widget build(BuildContext context) {
    HomeController homeController =
        Get.find<HomeController>(); // Инициализация контроллера здесь
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onDoubleTap: () => homeController.deleteWish(wish.id),
        child: ListTile(
          leading: Image(
              width: 64, fit: BoxFit.fill, image: NetworkImage(wish.image)),
          title: Text(
            wish.wish,
            style: textStyle(18, Colors.black, FontWeight.w700),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              "\$ ${wish.price}",
              style: textStyle(16, Colors.black, FontWeight.w600),
            ),
          ),
          trailing: Checkbox(
            value: wish.fulfilled,
            onChanged: (value) => homeController.fulfillWish(value, wish.id),
          ),
        ),
      ),
    );
  }
}
