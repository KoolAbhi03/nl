import 'package:flutter/material.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/pages/requestlist.dart';

class NotificationBell extends StatelessWidget {
  final int num;
  final List requestList;
  final currentUserUid;
  const NotificationBell(
      {Key? key,
      required this.num,
      required this.requestList,
      required this.currentUserUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RequestList(
                        requestList: requestList,
                        currentUserUid: currentUserUid,
                      )));
        },
        radius: 18,
        child: CircleAvatar(
          backgroundColor: backgroundColor1,
          radius: 20,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      '$num',
                      style: const TextStyle(fontSize: 10, color: textColor2),
                    ),
                  ),
                ),
              ),
              const Icon(
                Icons.notifications,
                color: iconColor2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
