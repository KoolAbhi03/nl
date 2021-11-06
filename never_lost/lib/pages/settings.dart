import 'package:flutter/material.dart';
import 'package:never_lost/auth/auth.dart';
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/auth/hive.dart';
import 'package:never_lost/auth/userauth.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/pages/signin.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends StatefulWidget {
  final Map<String, dynamic> user;
  const Settings({Key? key, required this.user}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final phoneController = TextEditingController();
  final statusController = TextEditingController();
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image =
        await _picker.pickImage(source: source, imageQuality: 20);

    String _imageFile = image!.path;
    var val =
        await UserAuth().changeProfilePhoto(_imageFile, widget.user['uid']);

    return val;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor2,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        shadowColor: Colors.transparent,
        actions: [
          TextButton.icon(
              label: const Text(
                'Sign Out',
                style: TextStyle(color: backgroundColor2),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return Builder(builder: (context) {
                        return SimpleDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          contentPadding: EdgeInsets.zero,
                          children: [
                            Container(
                              height: 150,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          'Are you sure, you want to',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text('SIGNOUT!',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red[700])),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.red[700],
                                                child: Icon(
                                                  Icons.close,
                                                  color: iconColor2,
                                                ))),
                                        InkWell(
                                            onTap: () {
                                              AuthMethods()
                                                  .signout()
                                                  .then((value) {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SignIn()),
                                                );
                                              });
                                            },
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.green[700],
                                                child: Icon(
                                                  Icons.done,
                                                  color: iconColor2,
                                                ))),
                                      ],
                                    )
                                  ]),
                            ),
                          ],
                        );
                      });
                    });
              },
              icon: const Icon(
                Icons.logout,
                color: backgroundColor2,
              ))
        ],
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
              height: 180,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: backgroundColor1,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
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
                                                      image: NetworkImage(widget
                                                          .user['photoURL']),
                                                      fit: BoxFit.fitWidth)),
                                            ),
                                          ]);
                                    });
                              },
                              icon: Icon(
                                Icons.photo,
                              ),
                              label: Text(
                                'View',
                                style: TextStyle(color: textColor2),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                _pickImage(ImageSource.gallery)
                                    .then((value) {});
                              },
                              icon: Icon(
                                Icons.photo_library,
                              ),
                              label: Text(
                                'Gallery',
                                style: TextStyle(color: textColor2),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.camera,
                              ),
                              label: Text(
                                'Camera',
                                style: TextStyle(color: textColor2),
                              ),
                            ),
                          ],
                        ),
                      ));
                      // showDialog(
                      //     context: context,
                      //     barrierDismissible: true,
                      //     builder: (context) {
                      //       return SimpleDialog(
                      //           backgroundColor: Colors.transparent,
                      //           children: [
                      //             Container(
                      //               width: width,
                      //               height: width,
                      //               decoration: BoxDecoration(
                      //                   image: DecorationImage(
                      //                       image: NetworkImage(
                      //                           widget.user['photoURL']),
                      //                       fit: BoxFit.fitWidth)),
                      //             ),
                      //           ]);
                      //     });
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
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 25),
                    child: Text(
                      widget.user['name'],
                      style: const TextStyle(color: textColor2, fontSize: 20),
                    ),
                  ),
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
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: backgroundColor2,
                          title: const Text('Phone Number',
                              style: TextStyle(color: textColor1)),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel',
                                    style: TextStyle(color: textColor1))),
                            TextButton(
                                onPressed: () async {
                                  var userData = widget.user;
                                  userData['phone'] = phoneController.text;
                                  HiveDB().updateUserData(userData);
                                  await DatabaseMethods()
                                      .updateUserDatabase(userData)
                                      .then((v) {
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text('Save',
                                    style: TextStyle(color: textColor1))),
                          ],
                          content: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2, color: textColor1))),
                            child: TextField(
                              maxLength: 10,
                              controller: phoneController,
                              style: const TextStyle(color: textColor1),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  helperStyle: TextStyle(color: textColor1)),
                            ),
                          ),
                        );
                      });
                },
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
                trailing: const Icon(
                  Icons.edit,
                  color: iconcolor1,
                )),
            const Divider(
              endIndent: 10,
              indent: 70,
              color: textColor1,
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: backgroundColor2,
                        title: const Text('Status',
                            style: TextStyle(color: textColor1)),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel',
                                  style: TextStyle(color: textColor1))),
                          TextButton(
                              onPressed: () async {
                                var userData = widget.user;
                                userData['status'] = statusController.text;
                                HiveDB().updateUserData(userData);
                                await DatabaseMethods()
                                    .updateUserDatabase(userData)
                                    .then((v) {
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text('Save',
                                  style: TextStyle(color: textColor1))),
                        ],
                        content: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(width: 2, color: textColor1))),
                          child: TextField(
                            maxLength: 139,
                            minLines: 1,
                            maxLines: 5,
                            controller: statusController,
                            style: const TextStyle(color: textColor1),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                helperStyle: TextStyle(color: textColor1)),
                          ),
                        ),
                      );
                    });
              },
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
              trailing: const Icon(
                Icons.edit,
                color: iconcolor1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
