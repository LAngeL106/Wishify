import 'package:cloud_firestore/cloud_firestore.dart';

class Wish {
  late String id;
  late String wish;
  late double price;
  late String image;
  late bool fulfilled;
  late Timestamp wishedOn;

  Wish(this.id, this.wish, this.price, this.image, this.fulfilled,
      this.wishedOn);

  Wish.fromDocumentSnapshot(QueryDocumentSnapshot<Object?> doc) {
    id = doc.id;
    wish = doc['wish'];
    price = doc['price'];
    image = doc['image'];
    fulfilled = doc['fulfilled'];
    wishedOn = doc['wishedOn'];
  }
}
