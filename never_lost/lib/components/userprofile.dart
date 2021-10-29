import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'color.dart';

class UserProfile extends StatefulWidget {
  final Map<String, dynamic> user;
  const UserProfile({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor2,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        shadowColor: Colors.transparent,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: backgroundColor1,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              width: width,
              height: 220,
              child: Column(
                children: [
                  InkWell(
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
                                            image: NetworkImage(
                                                widget.user['photoURL']),
                                            fit: BoxFit.fitWidth)),
                                  ),
                                ]);
                          });
                    },
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.user['photoURL']),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 8),
                    child: Text(
                      widget.user['name'],
                      style: const TextStyle(color: textColor2, fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.person_add_alt_outlined,
                            size: 35,
                            color: iconColor2,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.message,
                            size: 35,
                            color: iconColor2,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.call,
                            size: 35,
                            color: iconColor2,
                          ))
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ListTile(
              leading: const Padding(
                padding: EdgeInsets.all(2),
                child: Icon(
                  Icons.email_outlined,
                  color: iconcolor1,
                ),
              ),
              title: const Text(
                'Email',
                style: TextStyle(color: iconcolor1),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  widget.user['email'],
                  style: const TextStyle(color: textColor1),
                ),
              ),
            ),
            const Divider(
              endIndent: 10,
              indent: 70,
              color: textColor1,
            ),
            ListTile(
              leading: const Icon(
                Icons.phone_android_sharp,
                color: iconcolor1,
              ),
              title: const Text(
                'Phone',
                style: TextStyle(color: iconcolor1),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  widget.user['phone'],
                  style: const TextStyle(color: textColor1),
                ),
              ),
            ),
            const Divider(
              endIndent: 10,
              indent: 70,
              color: textColor1,
            ),
            ListTile(
              leading: const Icon(
                Icons.insert_emoticon,
                color: iconcolor1,
              ),
              title: const Text(
                'Status',
                style: TextStyle(color: iconcolor1),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  widget.user['status'],
                  style: const TextStyle(color: textColor1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
