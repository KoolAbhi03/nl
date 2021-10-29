import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/components/peoplecard.dart';

class People extends StatefulWidget {
  final user;
  const People({Key? key, required this.user}) : super(key: key);

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor2,
          child: Column(
            children: [
              PeopleCard(people: 0),
              PeopleCard(people: 0),
              PeopleCard(people: 0),
              PeopleCard(people: 0),
              PeopleCard(people: 0),
              PeopleCard(people: 0),
              PeopleCard(people: 0),
              PeopleCard(people: 0),
              PeopleCard(people: 0),
              PeopleCard(people: 0),
              PeopleCard(people: 0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: backgroundColor1,
        elevation: 10,
        onPressed: () {},
        child: Icon(CupertinoIcons.chat_bubble_2),
      ),
    );
  }
}
