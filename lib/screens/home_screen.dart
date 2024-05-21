import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wishlify_app/controllers/home_controller.dart';
import 'package:wishlify_app/utils.dart';
import 'package:wishlify_app/widgets/wish_item.dart';

class HomeScreen extends StatelessWidget {
  HomeController homeController = Get.put(HomeController());
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();

  get context => null;

  openAddwishSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return Obx(
          () => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Container(
                height: 230,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          homeController.selectedPicture.isEmpty
                              ? InkWell(
                                  onTap: () => homeController.selectPicture(),
                                  child: const Icon(Icons.add_a_photo,
                                      color: Colors.grey, size: 45),
                                )
                              : InkWell(
                                  onTap: () => homeController.selectPicture(),
                                  child: Image(
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        File(homeController
                                            .selectedPicture.value),
                                      )),
                                ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextFormField(
                              controller: pricecontroller,
                              style:
                                  textStyle(16, Colors.black, FontWeight.w500),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(153, 158, 158, 158),
                                  hintText: "Price",
                                  hintStyle: textStyle(
                                      16,
                                      Color.fromARGB(255, 42, 42, 42),
                                      FontWeight.w500),
                                  border: InputBorder.none),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: titlecontroller,
                          style: textStyle(16, Colors.black, FontWeight.w500),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(153, 158, 158, 158),
                              hintText: "Your wish",
                              hintStyle: textStyle(
                                  16,
                                  Color.fromARGB(255, 42, 42, 42),
                                  FontWeight.w500),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        child: TextButton(
                          onPressed: () => homeController
                              .addWish(titlecontroller.text,
                                  double.parse(pricecontroller.text))
                              .then((value) {
                            titlecontroller.clear();
                            pricecontroller.clear();
                            homeController.selectedPicture.value = '';
                            Get.back();
                            Get.snackbar("Success", "Wish added");
                          }),
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 0, 255, 140)),
                          child: Text(
                            "Add to my list",
                            style: textStyle(20, Colors.white, FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddwishSheet(context), //context
        child: const Icon(Icons.add, color: Colors.white, size: 40),
        backgroundColor: Color.fromARGB(255, 0, 255, 140),
      ),
      body: Obx(
        () => SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 40, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => homeController.signout(),
                      child: Text(
                        "Wish list",
                        style: textStyle(25, Color.fromARGB(255, 0, 255, 140),
                            FontWeight.w600),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: homeController.tab.value == "Wishes"
                            ? homeController.getNumWishesStream(false)
                            : homeController.getNumWishesStream(true),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 0, 255, 140),
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: textStyle(
                                        22, Colors.white, FontWeight.w700),
                                  )),
                                )
                              : const CircularProgressIndicator();
                        })
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => homeController.changetab("Wishes"),
                      child: Text(
                        "Wishes",
                        style: textStyle(
                            20,
                            homeController.tab.value == "Wishes"
                                ? Color.fromARGB(255, 0, 255, 140)
                                : Colors.grey,
                            FontWeight.w600),
                      ),
                    ),
                    InkWell(
                      onTap: () => homeController.changetab("Fulfilled"),
                      child: Text(
                        "Fulfilled",
                        style: textStyle(
                            20,
                            homeController.tab.value == "Fulfilled"
                                ? Color.fromARGB(255, 0, 255, 140)
                                : Colors.grey,
                            FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                homeController.tab.value == "Wishes"
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: homeController.wishes.length,
                        itemBuilder: (context, index) {
                          return WishItem(homeController.wishes[index]);
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: homeController.fulfilledwishes.length,
                        itemBuilder: (context, index) {
                          return WishItem(
                              homeController.fulfilledwishes[index]);
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
