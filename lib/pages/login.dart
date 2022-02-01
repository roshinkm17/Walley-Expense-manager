import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walley/pages/home.dart';
import 'package:walley/utils/auth.dart';
import 'package:walley/utils/constants.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginFormKey = GlobalKey<FormState>();
  final CustomUser customUser = Get.put(CustomUser());
  var disabled = false;

  checkIfLoggedIn() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("User signed out");
      } else {
        print("user is signed in");
        customUser.setEmail(user.email!);
        Get.to(HomePage());
      }
    });
  }

  handleLoginWithEmail() async {
    setState(() {
      disabled = true;
    });
    final res = await customUser.loginWithEmail();
    setState(() {
      disabled = false;
    });
    if (res is User) {
      Get.to(HomePage());
    } else {
      showSnackBar("Error", res);
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "Walley: Expense Budget and Savings Manager",
                  style: TextStyle(
                      color: darkRed,
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
              ),
              Form(
                key: loginFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkYellow),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: lightBlack,
                          ),
                        ),
                        fillColor: lightYellow,
                        filled: true,
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color: black, fontWeight: FontWeight.bold),
                        hintText: "johndoe@email.com",
                      ),
                      onChanged: (value) {
                        customUser.setEmail(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Cannot be empty";
                        }
                        if (!GetUtils.isEmail(value)) {
                          return "Invalid email";
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Cannot be empty";
                        }
                      },
                      onChanged: (value) {
                        customUser.setPassword(value);
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkYellow),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: lightBlack,
                          ),
                        ),
                        fillColor: lightYellow,
                        filled: true,
                        labelText: "Password",
                        labelStyle: TextStyle(
                            color: black, fontWeight: FontWeight.bold),
                        hintText: "Something strong please",
                      ),
                    ),
                    TextButton(
                        onPressed: () {}, child: Text("Forgot password?")),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: darkRed),
                        onPressed: () {
                          //login
                          if (loginFormKey.currentState!.validate() && !disabled) {
                            handleLoginWithEmail();
                          }
                        },
                        child:!disabled ? Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ) : CircularProgressIndicator(color: lightYellow) ,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: OutlinedButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      side: BorderSide(color: lightBlack),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  )),
                  onPressed: () {},
                  icon: Icon(FontAwesome5.google, color: black),
                  label: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Login with Google",
                      style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
