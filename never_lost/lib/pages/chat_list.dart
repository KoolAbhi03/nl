import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/components/loading.dart';
import 'package:never_lost/components/notificationdot.dart';
import 'package:never_lost/pages/chatroom.dart';
import 'package:never_lost/pages/friendslist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class ChatList extends StatefulWidget {
  final currentUser;

  const ChatList({Key? key, required this.currentUser}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool isloading = true;
  late Stream chatsStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChats().then((v) {
      setState(() {
        isloading = false;
      });
    });
  }

  getChats() async {
    chatsStream = await DatabaseMethods().getChats(widget.currentUser['email']);
    return chatsStream;
  }

  void showPhoto(height, width, photoURL) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return InteractiveViewer(
            child: SimpleDialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                children: [
                  Container(
                    height: width,
                    width: width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(photoURL),
                            fit: BoxFit.fitWidth)),
                  ),
                ]),
          );
        });
  }

  Widget time(Timestamp timestamp) {
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    DateTime targetTime = timestamp.toDate();
    int currentYear = currentPhoneDate.year;
    int currentMonth = currentPhoneDate.month;
    int currentDay = currentPhoneDate.day;
    int currentHour = currentPhoneDate.hour;
    int currentMinute = currentPhoneDate.minute;

    int targetYear = targetTime.year;
    int targetMonth = targetTime.month;
    int targetDay = targetTime.day;
    int targetHour = targetTime.hour;
    int targetMinute = targetTime.minute;
    String tf = targetHour >= 12 ? 'pm' : 'am';
    targetHour = targetHour > 12 ? targetHour - 12 : targetHour;
    if ((currentYear - targetYear == 0) &&
        (currentDay - targetDay == 0) &&
        (currentMonth - targetMonth == 0)) {
      return Text('${targetHour}:${targetMinute} ${tf}');
    }
    if (((currentYear - targetYear == 0) &&
            (currentDay - targetDay == 1) &&
            (currentMonth - targetMonth == 0)) ||
        (currentYear - targetYear == 0) &&
            (currentDay == 1) &&
            (currentMonth - targetMonth == 1) ||
        (currentYear - targetYear == 1) &&
            (currentDay == 1) &&
            (currentMonth - targetMonth == -11)) {
      return Text('Yesterday');
    }

    return Text('${targetDay}/${targetMonth}/${targetYear}');
  }

  Widget messageCount(chatRoomId, email) {
    return StreamBuilder(
      stream: DatabaseMethods().getUnseenMessages(chatRoomId, email),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData && snapshot.data.docs.length > 0
            ? Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: backgroundColor1, shape: BoxShape.circle),
                child: Text(
                  '${snapshot.data.docs.length}',
                  style: TextStyle(
                      color: backgroundColor2, fontWeight: FontWeight.bold),
                ),
              )
            : Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  ' ',
                  style: TextStyle(
                      color: backgroundColor2, fontWeight: FontWeight.bold),
                ),
              );
      },
    );
  }

  Widget chatList(height, width) {
    return StreamBuilder(
      stream: chatsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  String friendEmail =
                      ds['users'][0] != widget.currentUser['email']
                          ? ds['users'][0]
                          : ds['users'][1];

                  return StreamBuilder(
                    stream: DatabaseMethods().searchByEmail(friendEmail),
                    builder: (context, AsyncSnapshot snap) {
                      Map<String, dynamic> friendUser =
                          snap.hasData ? snap.data.docs[0].data() : {};
                      return snap.hasData
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatRoom(
                                                  currentUser:
                                                      widget.currentUser,
                                                  friendUser: friendUser)));
                                    },
                                    title: Text(
                                      friendUser['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: ds['isImage']
                                        ? Row(
                                            children: [
                                              Icon(Icons.camera_alt_rounded),
                                              Text('Photo')
                                            ],
                                          )
                                        : Text(
                                            ds['lastMessage'],
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                    leading: GestureDetector(
                                      onTap: () {
                                        showPhoto(height, width,
                                            friendUser['photoURL']);
                                      },
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.network(
                                              friendUser['photoURL'])),
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        time(ds['timestamp']),
                                        messageCount(
                                            ds.id, widget.currentUser['email'])
                                      ],
                                    )),
                              ),
                            )
                          : Container();
                    },
                  );
                },
              )
            : SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor2,
      body: isloading ? Loading() : chatList(height, width),
      floatingActionButton: FloatingActionButton(
        backgroundColor: backgroundColor1,
        elevation: 10,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FriendsList(currentUser: widget.currentUser)));
        },
        child: Icon(CupertinoIcons.chat_bubble_2),
      ),
    );
  }
}
