import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_button/screens/login/login_screen.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    DatabaseReference referenceDatabase = FirebaseDatabase.instance.reference();
    var mAuth = FirebaseAuth.instance;
    var uid = mAuth.currentUser!.uid.toString();
    _getNameUser(referenceDatabase, uid);
  }

  var nameUser = "";

  _getNameUser(DatabaseReference ref, String uid) async {
    await ref.child("Users").child(uid).child("name").onValue.listen((event) {
      setState(() {
        nameUser = event.snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Container(
              child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tên hiển thị: "),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          nameUser,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ))
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      )
                    ]),
              )
            ],
          )),
        ),
      ),
    );
  }
}
