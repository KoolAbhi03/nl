import 'package:flutter/material.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/components/groupcard.dart';

class Group extends StatefulWidget {
  final user;
  const Group({Key? key, required this.user}) : super(key: key);

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor2,
          child: Column(
            children: [GroupCard(people: 0)],
          ),
        ),
      ),
    );
  }
}
