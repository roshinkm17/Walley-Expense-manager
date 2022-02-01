import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CustomUser extends GetxController {
  var email = '';
  var password = '';

  setEmail(email) {
    this.email =email;
    update();
  }

  setPassword(password) {
    this.password = password;
    update();
  }

  Future registerWithEmail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "Weak password provided";
      } else if (e.code == 'email-already-in-use') {
        return "This email is already in use";
      } else {
        print(e.message);
        return "Something went wrong";
      }
    } catch (e) {
      print(e);
      return "Something went wrong";
    }
  }

  Future loginWithEmail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email, password: password);
      print(userCredential.user);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "User not found. Try signing up";
      } else if (e.code == 'wrong-password') {
        return "Invalid email or password";
      } else {
        print(e.message);
        return "Something went wrong";
      }
    } catch (e) {
      print(e);
      return "Something went wrong";
    }
  }
}
