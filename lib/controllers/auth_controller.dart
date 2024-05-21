import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wishlify_app/utils.dart';

class AuthController extends GetxController {
  RxString tab = "Login".obs;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(FirebaseAuth.instance.currentUser);

  changeTab(value) {
    tab.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    user.bindStream(firebaseAuth.authStateChanges());
  }

  registeruser(String email, String password, String username) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    if (user != null) {
      userCollection.doc(user.uid).set({"email": email, "username": username});
    }
  }

  loginuser(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print("Logged in user");
    } catch (e) {
      print("Failed to login user");
    }
  }
}
