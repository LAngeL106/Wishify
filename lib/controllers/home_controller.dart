import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wishlify_app/models/wish_model.dart';
import 'package:wishlify_app/utils.dart';

class HomeController extends GetxController {
  RxString tab = "Wishes".obs;
  RxString selectedPicture = "".obs;
  ImagePicker imagePicker = ImagePicker();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  RxList<Wish> wishes = <Wish>[].obs;
  RxList<Wish> fulfilledwishes = <Wish>[].obs;

  @override
  void onInit() {
    super.onInit();
    getwishes();
  }

  getwishes() {
    wishes.bindStream(userCollection
        .doc(uid)
        .collection('wishes')
        .where('fulfilled', isEqualTo: false)
        .snapshots()
        .map((query) {
      List<Wish> wishes = [];
      List<QueryDocumentSnapshot<Object?>> doclist = query.docs;
      for (var element in doclist) {
        wishes.add(Wish.fromDocumentSnapshot(element));
      }
      return wishes;
    }));
  }

  getfulfilledwishes() {
    fulfilledwishes.bindStream(userCollection
        .doc(uid)
        .collection('wishes')
        .where('fulfilled', isEqualTo: true)
        .snapshots()
        .map((query) {
      List<Wish> wishes = [];
      List<QueryDocumentSnapshot<Object?>> doclist = query.docs;
      for (var element in doclist) {
        wishes.add(Wish.fromDocumentSnapshot(element));
      }
      return wishes;
    }));
  }

  Stream<QuerySnapshot<Object?>> getNumWishesStream(wishStatus) {
    return userCollection
        .doc(uid)
        .collection('wishes')
        .where('fulfilled', isEqualTo: wishStatus)
        .snapshots();
  }

  changetab(value) {
    tab.value = value;
    if (value == "Fulfilled" && fulfilledwishes.firstRebuild) {
      getfulfilledwishes();
    }
  }

  fulfillWish(wishStatus, wishId) async {
    await userCollection
        .doc(uid)
        .collection('wishes')
        .doc(wishId)
        .update({'fulfilled': wishStatus});
  }

  selectPicture() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedPicture.value = pickedFile.path;
    }
  }

  Future addWish(wish, price) async {
//длина списка желаний
    int length = await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('wishes')
        .get()
        .then((value) => value.docs.length);

//загрузка в бд картинок
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('File $length')
        .putFile(File(selectedPicture.value));
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await snapshot.ref.getDownloadURL();

//данные в бд
    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('wishes')
        .add({
      "wish": wish,
      "price": price,
      "image": imageUrl,
      "fulfilled": false,
      "wishedOn": DateTime.now()
    });
  }

  deleteWish(wishId) async {
    await userCollection.doc(uid).collection('wishes').doc(wishId).delete();
  }

  signout() {
    FirebaseAuth.instance.signOut();
    Get.delete<HomeController>();
  }
}
