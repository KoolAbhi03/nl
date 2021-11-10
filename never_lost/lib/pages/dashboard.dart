import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:never_lost/auth/auth.dart';
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/auth/hive.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/components/loading.dart';
import 'package:never_lost/components/pendingrequestbutton.dart';
import 'package:never_lost/pages/group.dart';
import 'package:never_lost/pages/chat_list.dart';
import 'package:never_lost/pages/search.dart';
import 'package:never_lost/pages/profile.dart';
import 'package:never_lost/pages/settings.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  Map<String, dynamic> user = {};
  bool isloading = true;
  late Stream userStream;
  String uid = '';
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  Location location = Location();
  late double lat;
  late double long;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
    getUser();
  }

  void getUser() async {
    await HiveDB().getUserData().then((value) {
      setState(() {
        uid = value['uid'];
      });
      getUserData();
    });
  }

  void getUserData() async {
    await DatabaseMethods().getUserSnapshots(uid).listen((event) {
      setState(() {
        user = event.data()!;
        isloading = false;
      });
    });
    getlocation();
  }

  void getlocation() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    location.onLocationChanged.listen((event) async {
      setState(() {
        lat = event.latitude!;
        long = event.longitude!;
      });
      await DatabaseMethods().updateUserLocation(user['uid'], lat, long);
    });
    setState(() {
      lat = _locationData.latitude!;
      long = _locationData.longitude!;
    });

    await DatabaseMethods().updateUserLocation(user['uid'], lat, long);
  }

  Widget notificationButton() {
    return StreamBuilder(
        stream: DatabaseMethods().getUserSnapshots(uid),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return NotificationBell(
              num: 0,
              requestList: [],
              currentUserUid: user['uid'],
            );
          return NotificationBell(
            num: snapshot.data['pendingRequestList'].length,
            requestList: snapshot.data['pendingRequestList'],
            currentUserUid: user['uid'],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return isloading
        ? const Loading()
        : GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              appBar: AppBar(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                backgroundColor: backgroundColor1,
                elevation: 0,
                title: const Text(
                  'NeverLost',
                  style: TextStyle(fontSize: 24),
                ),
                actions: [
                  notificationButton(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(user: user)));
                      },
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: ValueListenableBuilder(
                            valueListenable:
                                Hive.box('IMAGEBOXKEY').listenable(),
                            builder: (context, Box box, widget) {
                              return box.get('IMAGEDATAKEY') != null
                                  ? Image.file(File(box.get('IMAGEDATAKEY')))
                                  : Image.network(user['photoURL']);
                            }),
                      ))
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(80),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        labelColor: backgroundColor1,
                        unselectedLabelColor: backgroundColor2,
                        padding: const EdgeInsets.all(8),
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: backgroundColor2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tabs: [
                          Container(
                              alignment: Alignment.center,
                              height: 30,
                              child: const Text(
                                'Friends',
                              )),
                          Container(
                              alignment: Alignment.center,
                              height: 30,
                              child: const Text(
                                'Groups',
                              )),
                          Container(
                              alignment: Alignment.center,
                              height: 30,
                              child: const Text(
                                'Add',
                              )),
                          Container(
                              alignment: Alignment.center,
                              height: 30,
                              child: const Text(
                                'Settings',
                              )),
                          // Text('Friends', style: TextStyle(color: backgroundColor),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  ChatList(
                    currentUser: user,
                  ),
                  Group(
                    user: user,
                  ),
                  Search(
                    user: user,
                  ),
                  Settings(
                    user: user['uid'],
                  )
                ],
              ),
            ),
          );
  }
}
