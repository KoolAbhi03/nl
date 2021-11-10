import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  late bool masterShare;
  bool isLoading = true;
  late List isShare;
  int index = 0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
    createChatRoomID();
    getUserStream();
  }

  createChatRoomID() async {
    List tempList = [
      widget.currentUser['email'].split('@')[0],
      widget.friendUser['email'].split('@')[0]
    ];
    tempList.sort((a, b) => a.compareTo(b));
    setState(() {
      chatRoomID = tempList.join('_');
    });
    return chatRoomID;
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getUserStream() {
    DatabaseMethods()
        .getUserSnapshots(widget.currentUser['uid'])
        .listen((event) {
      if (mounted) {
        setState(() {
          masterShare = event.data()!['isShare'];
        });
      }
    });
    DatabaseMethods().chatRoomDetail(chatRoomID).listen((event) async {
      isShare = await event.data()!['isSharing'];
      isLoading = false;
      if (event.data()!['users'][0] == widget.currentUser['email']) {
        index = 0;
      } else {
        index = 1;
      }
      if (mounted) {
        setState(() {});
      }
    });
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
                  child: Row(
                    children: [
                      Align(
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
                      InkWell(
                        onTap: () {
                          if (masterShare == true) {
                            DatabaseMethods().updatechatLocShare(
                                chatRoomID,
                                index == 0
                                    ? [!isShare[0], isShare[1]]
                                    : [isShare[0], !isShare[1]]);
                            Fluttertoast.showToast(
                                msg: isShare[index]
                                    ? 'Location Sharing OFF'
                                    : 'Location Sharing ON');
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Turn ON Location Sharing from Settings');
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              'Share your Location',
                              style: TextStyle(color: textColor2),
                            ),
                            Switch(
                                value: isShare[index] && masterShare,
                                onChanged: (newvalue) {
                                  if (masterShare == true) {
                                    DatabaseMethods().updatechatLocShare(
                                        chatRoomID,
                                        index == 0
                                            ? [!isShare[0], isShare[1]]
                                            : [isShare[0], !isShare[1]]);
                                    Fluttertoast.showToast(
                                        msg: isShare[index]
                                            ? 'Location Sharing OFF'
                                            : 'Location Sharing ON');
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Turn ON Location Sharing from Settings');
                                  }
                                }),
                          ],
                        ),
                      )
                    ],
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
                  chatRoomID: chatRoomID,
                ),
                LocationPage(
                  currentUser: widget.currentUser,
                  friendUser: widget.friendUser,
                  chatRoomID: chatRoomID,
                )
              ],
            ),
          );
  }
}
