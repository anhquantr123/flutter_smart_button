import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_button/screens/login/widget_login/body_login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final Future<FirebaseApp> _initailization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/background.jpg"))),
              child: Container(
                padding: EdgeInsets.only(top: 90, left: 20),
                color: Colors.blue.withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: const TextSpan(
                            text: "Welcome to",
                            style: TextStyle(
                                fontSize: 22, color: Colors.yellowAccent),
                            children: [
                          TextSpan(
                              text: " Smart Button",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26))
                        ])),
                    const Text(
                      "Đăng nhập để tiếp tục",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                clipBehavior: Clip.antiAlias,
                width: MediaQuery.of(context).size.width,
                // margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.0),
                          blurRadius: 15,
                          spreadRadius: 5)
                    ]),
                child: BodyLogin()),
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                children: const [
                  Image(
                      height: 85,
                      width: 85,
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/smart_home.png")),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Create App By AnhQuanTr123"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
