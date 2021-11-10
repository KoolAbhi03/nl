import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/components/color.dart';

class Uploader extends StatefulWidget {
  final image, currentUser, friendUser, chatRoomID;
  const Uploader(
      {Key? key,
      required this.image,
      required this.currentUser,
      required this.friendUser,
      required this.chatRoomID})
      : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'gs://never-lost-643e9.appspot.com');
  _startUpload() async {
    File file = File(widget.image.path);
    try {
      String filepath = 'chats/${DateTime.now()}.png';
      await firebase_storage.FirebaseStorage.instance
          .ref(filepath)
          .putFile(file);
      dynamic image = await firebase_storage.FirebaseStorage.instance
          .ref(filepath)
          .getDownloadURL();

      sendMessage(image.toString());
    } on firebase_core.FirebaseException catch (e) {
      print('chat gaya');
      return false;
    }
  }

  void sendMessage(String link) async {
    Map<String, dynamic> messageInfo = {
      'message': link,
      'sender': widget.currentUser['email'],
      'receiver': widget.friendUser['email'],
      'seen': false,
      'isImage': true,
      'timestamp': DateTime.now()
    };
    Map<String, dynamic> lastMessageInfo = {
      'lastMessage': link,
      'sender': widget.currentUser['email'],
      'receiver': widget.friendUser['email'],
      'seen': false,
      'isImage': true,
      'timestamp': DateTime.now(),
    };
    DatabaseMethods()
        .addMessage(widget.chatRoomID, messageInfo, lastMessageInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              child: Image.file(widget.image),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: backgroundColor1,
        onPressed: () {
          _startUpload();
          Navigator.pop(context);
        },
        child: Icon(
          Icons.send,
          color: iconColor2,
        ),
      ),
    );
    //}
  }
}
