import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:never_lost/auth/auth.dart';
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/auth/hive.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/components/loading.dart';
import 'package:never_lost/components/pendingrequestbutton.dart';
import 'package:never_lost/pages/group.dart';
import 'package:never_lost/pages/chat_list.dart';
import 'package:never_lost/pages/search.dart';
import 'package:never_lost/pages/settings.dart';

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
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
    getUser();
  }

  void getUser() async {
    await HiveDB().getUserData().then((value) {
      setState(() {
        user = value;
        isloading = false;
        print(user);
      });
      getUserStream();
    });
  }

  void getUserStream() async {
    userStream = await DatabaseMethods().getUserSnapshots(user['uid']);
  }

  Widget notificationButton() {
    return StreamBuilder(
        stream: userStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return NotificationBell(
              num: 0,
              requestList: [],
              currentUserUid: user['uid'],
            );
          print(snapshot.data['pendingRequestList']);
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
                  // IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(
                  //       Icons.notifications,
                  //       color: iconColor2,
                  //     )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings(user: user)));
                      },
                      icon: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(user['photoURL']))),
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
                  Loading()
                ],
              ),
            ),
          );
  }
}
