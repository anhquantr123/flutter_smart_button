import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_button/screens/setting/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late var nameUser;
  late DatabaseReference referenceDatabase;
  late String uid;
  late StreamSubscription streamSubscriptionGetNamUser;
  @override
  void initState() {
    referenceDatabase = FirebaseDatabase.instance.reference();
    uid = FirebaseAuth.instance.currentUser!.uid.toString();
    super.initState();
    nameUser = "";
    _getNameUser(referenceDatabase, uid);
  }

  _getNameUser(DatabaseReference ref, String uid) async {
    streamSubscriptionGetNamUser = await ref
        .child("Users")
        .child(uid)
        .child("name")
        .onValue
        .listen((event) {
      setState(() {
        nameUser = event.snapshot.value;
      });
    });
  }

  int indexRoom = 0;
  String roomSelect = "";
  int indexDevice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHome(),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        spreadRadius: 2)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome"),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        nameUser.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        spreadRadius: 2)
                  ]),
              padding: EdgeInsets.symmetric(vertical: 9),
              height: 60,
              child: StreamBuilder(
                  stream:
                      referenceDatabase.child("Control").orderByKey().onValue,
                  builder: (context, snapshot) {
                    final _listRoom = [];
                    try {
                      if (snapshot.hasData) {
                        final name = Map<String, dynamic>.from(
                            (snapshot.data! as Event).snapshot.value);
                        name.forEach((key, value) {
                          //final keyRoom = Map<String, dynamic>.from(value);
                          _listRoom.add(key);
                        });
                      }
                    } catch (e) {}
                    return ListView.builder(
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _listRoom.length,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  roomSelect = _listRoom[index] as String;
                                  indexRoom = index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_listRoom[index],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: indexRoom == index
                                                ? Colors.red
                                                : Colors.black
                                                    .withOpacity(0.5))),
                                  ],
                                ),
                              ),
                            ));
                  }),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 286,
              margin: EdgeInsets.all(5),
              child: StreamBuilder(
                  stream: referenceDatabase
                      .child("Control")
                      .child(roomSelect)
                      .orderByKey()
                      .onValue,
                  builder: (context, snapshot) {
                    final _listDeviceName = [];
                    final _listDeviceStatus = [];
                    final _listDeviceKey = [];
                    try {
                      if (snapshot.hasData) {
                        final name = Map<String, dynamic>.from(
                            (snapshot.data! as Event).snapshot.value);
                        name.forEach((key, value) {
                          final keyDevice = Map<String, dynamic>.from(value);
                          _listDeviceKey.add(key);
                          _listDeviceName.add(keyDevice['name']);
                          _listDeviceStatus.add(keyDevice['status']);
                        });
                      }
                    } catch (e) {}
                    return ListView.builder(
                        itemCount: _listDeviceName.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  indexDevice = index;
                                  int status = 0;
                                  if (_listDeviceStatus[index] == 0) {
                                    status = 1;
                                  }
                                  referenceDatabase
                                      .child("Control")
                                      .child(roomSelect)
                                      .child(_listDeviceKey[index])
                                      .update({"status": status});
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: _listDeviceStatus[index] == 1
                                          ? Colors.green
                                          : Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 2,
                                            spreadRadius: 2)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _listDeviceName[index].toString(),
                                        style: TextStyle(
                                            color: _listDeviceStatus[index] == 1
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _listDeviceStatus[index] == 1
                                            ? "Bật"
                                            : "Tắt",
                                        style: TextStyle(
                                            color: _listDeviceStatus[index] == 1
                                                ? Colors.white
                                                : Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            ));
                  }),
            )
          ],
        ),
      ),
    );
  }

  /// get app bar home
  AppBar AppBarHome() => AppBar(actions: [
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingScreen()));
            },
            icon: Icon(Icons.settings))
      ], title: Text("Smart Button"));

  @override
  void deactivate() {
    streamSubscriptionGetNamUser.cancel();
    super.deactivate();
  }
}
