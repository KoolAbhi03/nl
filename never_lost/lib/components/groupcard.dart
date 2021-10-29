import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/components/notificationdot.dart';
import 'package:never_lost/pages/chatroom.dart';
import 'package:never_lost/pages/groupchatroom.dart';

class GroupCard extends StatefulWidget {
  final people;
  const GroupCard({Key? key, required this.people}) : super(key: key);

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  double cardHeight = 85;
  bool isexpanded = false;
  var time = DateTime.now().weekday;
  List<String> weekdays = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];
  String displaymessge = '9999999999999999999999999999999999999999999';
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      height: cardHeight,
      child: InkWell(
        onLongPress: () {
          setState(() {
            cardHeight = cardHeight == 85 ? 110 : 85;
            isexpanded = !isexpanded;
          });
        },
        child: Column(
          children: [
            Card(
              shadowColor: Colors.transparent,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GroupChatRoom(name: 'Friends')));
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                leading: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return SimpleDialog(
                              backgroundColor: Colors.transparent,
                              children: [
                                Container(
                                  width: width,
                                  height: width,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/background1.png'),
                                          fit: BoxFit.fitWidth)),
                                ),
                              ]);
                        });
                  },
                  child: CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.groups,
                    ),
                  ),
                ),
                title: Text(
                  'Friends',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: displaymessge.length > 22
                    ? Text(
                        '${displaymessge.substring(0, 20)}......',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        displaymessge,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weekdays[time - 1],
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const NotifationDot(dotNumer: 2)
                  ],
                ),
              ),
            ),
            if (cardHeight == 110)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isexpanded = !isexpanded;
                        cardHeight = cardHeight == 85 ? 110 : 85;
                      });
                    },
                    child: Icon(Icons.close),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
