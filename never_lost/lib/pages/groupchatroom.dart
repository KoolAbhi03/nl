import 'package:flutter/material.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/components/map.dart';
import 'package:never_lost/pages/search.dart';

class GroupChatRoom extends StatefulWidget {
  final String name;
  const GroupChatRoom({Key? key, required this.name}) : super(key: key);

  @override
  _GroupChatRoomState createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  final messageController = TextEditingController();

  @override
  void initstate() {
    print('ads');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor1,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back),
                CircleAvatar(
                  radius: 16,
                  child: Icon(
                    Icons.groups,
                  ),
                )
              ],
            ),
          ),
          title: MaterialButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MAp()));
            },
            child: Text(
              widget.name,
              style: TextStyle(fontSize: 18, color: textColor2),
            ),
          ),
          actions: [
            Container(
              width: 50,
              child: InkWell(
                onTap: () {
                  // _determinePosition();
                },
                child: Icon(Icons.location_on),
              ),
            ),
            PopupMenuButton(
                itemBuilder: (context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                          child: InkWell(
                        child: Text('View Profile'),
                      )),
                      const PopupMenuItem(
                          child: InkWell(
                        child: Text('View Profile'),
                      )),
                      const PopupMenuItem(
                          child: InkWell(
                        child: Text('View Profile'),
                      )),
                      const PopupMenuItem(
                          child: InkWell(
                        child: Text('View Profile'),
                      ))
                    ])
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            color: backgroundColor1.withOpacity(0.3),
            child: Center(child: Text('Text')),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: backgroundColor2,
          child: Container(
            height: 60,
            color: backgroundColor1.withOpacity(0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: backgroundColor2,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () {},
                          child: Icon(Icons.insert_emoticon_sharp),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(width: 250, child: TextField()),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () {},
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: backgroundColor1,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    child: Icon(
                      Icons.send,
                      color: backgroundColor2,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
