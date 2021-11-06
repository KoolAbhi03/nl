import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/components/loading.dart';
import 'package:never_lost/components/mymessage.dart';
import 'package:never_lost/components/userprofile.dart';
import 'package:never_lost/pages/chats.dart';
import 'package:never_lost/pages/location.dart';
import 'package:never_lost/pages/search.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatRoom extends StatefulWidget {
  final Map currentUser, friendUser;
  const ChatRoom(
      {Key? key, required this.currentUser, required this.friendUser})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final messageController = TextEditingController();
  late Stream messageStream;
  late String chatRoomID;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              toolbarHeight: 80,
              backgroundColor: backgroundColor1,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(15))),
              automaticallyImplyLeading: false,
              title: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfile(
                              currentUser: widget.currentUser,
                              searchedUser: widget.friendUser)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            widget.friendUser['photoURL'],
                            height: 60,
                            width: 60,
                          )),
                    ),
                    Text(widget.friendUser['name']),
                  ],
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      if (widget.friendUser['phone'].length == 10)
                        _makePhoneCall('tel:${widget.friendUser['phone']}');
                    },
                    icon: const Icon(Icons.call)),
                PopupMenuButton(
                    itemBuilder: (context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            onTap: () {},
                            child: const Text('Invite a friend'),
                          ),
                          PopupMenuItem(
                            onTap: () {},
                            child: const Text('Refresh'),
                          ),
                        ])
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      labelColor: backgroundColor1,
                      unselectedLabelColor: backgroundColor2,
                      padding: const EdgeInsets.all(8),
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 5),
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
                              'Chat',
                            )),
                        Container(
                            alignment: Alignment.center,
                            height: 30,
                            child: const Text(
                              'Location',
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                Chats(
                  currentUser: widget.currentUser,
                  friendUser: widget.friendUser,
                ),
                LocationPage(
                  currentUser: widget.currentUser,
                  friendUser: widget.friendUser,
                )
              ],
            ),
          );
  }
}
