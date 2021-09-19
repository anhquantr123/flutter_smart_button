import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_button/screens/home/home_screen.dart';
import 'package:smart_button/screens/login/widget_login/input.dart';
import 'package:smart_button/screens/login/widget_login/round_button.dart';

class BodyLogin extends StatefulWidget {
  const BodyLogin({Key? key}) : super(key: key);

  @override
  _BodyLoginState createState() => _BodyLoginState();
}

class _BodyLoginState extends State<BodyLogin> {
  bool isDangNhap = true;
  bool isTouch = false;
  String email = "";
  String pass = "";
  String hoten = "";

  //
  final firebaseStore = FirebaseFirestore.instance;
  final referenceDatabase = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference().child("Users");
    _loginAndSingUp() async {
      if (isDangNhap) {
        try {
          if (email.isEmpty || pass.isEmpty) {
            EasyLoading.showInfo('Vui lòng nhập đầy đủ thông tin!');
          } else {
            EasyLoading.show(status: 'Đang đăng nhập...');
            setState(() {
              isTouch = true;
            });
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: pass);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
            setState(() {
              isTouch = false;
              EasyLoading.dismiss();
            });
          }
        } on FirebaseAuthException catch (e) {
          EasyLoading.showError("Không thể đăng nhập!");
          setState(() {
            isTouch = false;
            EasyLoading.dismiss();
          });
        }
      } else {
        if (email.isEmpty || pass.isEmpty || hoten.isEmpty) {
          EasyLoading.showInfo('Vui lòng nhập đầy đủ thông tin!');
        } else {
          try {
            EasyLoading.show(status: 'Đang đăng kí tài khoản...');
            setState(() {
              isTouch = true;
            });
            UserCredential userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(email: email, password: pass);
            var mAuth = FirebaseAuth.instance;
            var mUser = mAuth.currentUser;
            var uid = mUser!.uid;
            ref.child(uid).set(
                <String, String>{"name": hoten, "email": email, "admin": "0"});
            EasyLoading.showInfo("Đăng kí tài khoản thành công!");

            setState(() {
              isTouch = false;
              EasyLoading.dismiss();
            });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'email-already-in-use') {
              EasyLoading.showInfo("Email đã được dùng!");
            } else if (e.code == "weak-password") {
              EasyLoading.showInfo("Mật khẩu yếu!");
            } else {
              EasyLoading.showInfo("Lỗi đăng kí tài khoản!");
            }
            setState(() {
              isTouch = false;
            });
          }
        }
      }
    }

    return AbsorbPointer(
      absorbing: isTouch,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDangNhap = true;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "Đăng Nhập",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDangNhap
                                ? Colors.blue
                                : Colors.black.withOpacity(0.4)),
                      ),
                      if (isDangNhap)
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            width: 80,
                            height: 2,
                            color: Colors.orange.shade900)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDangNhap = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "  Đăng Kí  ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: !isDangNhap
                                ? Colors.blue
                                : Colors.black.withOpacity(0.4)),
                      ),
                      if (!isDangNhap)
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            width: 60,
                            height: 2,
                            color: Colors.orange.shade900)
                    ],
                  ),
                )
              ],
            ),
          ),
          InputLogin(
            hintText: "Email",
            onChanged: (value) {
              setState(() {
                email = value.toString().trim();
              });
            },
          ),
          InputLogin(
            isPassword: true,
            hintText: "Password",
            onChanged: (value) {
              setState(() {
                pass = value.toString().trim();
              });
            },
            icon: Icons.lock,
          ),
          if (!isDangNhap)
            InputLogin(
                icon: Icons.person,
                hintText: "Họ và Tên",
                onChanged: (value) {
                  setState(() {
                    hoten = value.toString().trim();
                  });
                }),
          RoundedButton(text: "Đăng Nhập", press: _loginAndSingUp)
        ],
      ),
    );
  }
}
