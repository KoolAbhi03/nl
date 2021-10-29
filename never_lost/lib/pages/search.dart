import 'package:flutter/material.dart';
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/auth/userauth.dart';
import 'package:never_lost/components/color.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
  List ispressed = [true, false, false];
  List<IconData> iconState = [Icons.person, Icons.email_rounded, Icons.phone];
  int currentIndex = 0;
  List<String> listState = ['name', 'email', 'phone'];
  void onpress(int index) {
    if (!ispressed[index]) {
      setState(() {
        ispressed[index] = true;
        ispressed[currentIndex] = false;
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor2,
      body: SizedBox(
        width: width,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: themeColor2.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Icon(
                          iconState[currentIndex],
                          color: themeColor2,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                            controller: searchController,
                            cursorColor: themeColor2,
                            cursorHeight: 20,
                            style: const TextStyle(
                                color: themeColor2, fontSize: 18),
                            decoration: InputDecoration(
                                hintText:
                                    'Search by ${listState[currentIndex]}',
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 16),
                                border: InputBorder.none,
                                helperStyle:
                                    const TextStyle(color: themeColor2))),
                      ),
                      InkWell(
                        onTap: () async {
                          dynamic result;
                          result = await UserAuth().search(
                              listState[currentIndex], searchController.text);
                          print(result);
                          if (result != null) {
                            print(result);
                            searchController.clear();
                          }
                        },
                        child: const CircleAvatar(
                          backgroundColor: backgroundColor1,
                          child: Icon(
                            Icons.search,
                            color: iconColor2,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: themeColor2, borderRadius: BorderRadius.circular(8)),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ispressed[0] ? themeColor1 : themeColor2,
                          borderRadius: BorderRadius.circular(6)),
                      height: 40,
                      width: 80,
                      child: TextButton(
                          onPressed: () {
                            onpress(0);
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => backgroundColor2.withOpacity(0.2)),
                          ),
                          child: Text('name',
                              style: TextStyle(
                                  color: ispressed[0]
                                      ? themeColor2
                                      : themeColor1))),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: ispressed[1] ? themeColor1 : themeColor2,
                          borderRadius: BorderRadius.circular(5)),
                      height: 40,
                      width: 80,
                      child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => backgroundColor2.withOpacity(0.2)),
                          ),
                          onPressed: () {
                            onpress(1);
                          },
                          child: Text(
                            'email',
                            style: TextStyle(
                                color:
                                    ispressed[1] ? themeColor2 : themeColor1),
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: ispressed[2] ? themeColor1 : themeColor2,
                          borderRadius: BorderRadius.circular(5)),
                      height: 40,
                      width: 80,
                      child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => backgroundColor2.withOpacity(0.2)),
                          ),
                          onPressed: () {
                            onpress(2);
                          },
                          child: Text('phone',
                              style: TextStyle(
                                  color: ispressed[2]
                                      ? themeColor2
                                      : themeColor1))),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
