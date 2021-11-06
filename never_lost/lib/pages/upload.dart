import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:never_lost/auth/database.dart';

class Uploader extends StatefulWidget {
  final file, currentUser, friendUser, chatRoomID;
  const Uploader(
      {Key? key,
      required this.file,
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

  /// Starts an upload task
  _startUpload() async {
    print(widget.file);

    /// Unique file name for the file
    File file = File(widget.file);
    print(file);
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
      'isImage':true,
      'timestamp': DateTime.now()
    };
    Map<String, dynamic> lastMessageInfo = {
      'lastMessage': link,
      'sender': widget.currentUser['email'],
      'receiver': widget.friendUser['email'],
      'seen': false,
      'isImage':true,
      'timestamp': DateTime.now(),
    };
    DatabaseMethods()
        .addMessage(widget.chatRoomID, messageInfo, lastMessageInfo);
  }

  @override
  Widget build(BuildContext context) {
    // if (_uploadTask == '') {
    //   /// Manage the task state and event subscription with a StreamBuilder
    //   return StreamBuilder(
    //       stream: _uploadTask.events,
    //       builder: (_, snapshot) {

    //         double progressPercent = event != null
    //             ? event.bytesTransferred / event.totalByteCount
    //             : 0;

    //         return Column(
    //           children: [
    //             if (_uploadTask.isComplete) Text('🎉🎉🎉'),

    //             if (_uploadTask.isPaused)
    //               MaterialButton(
    //                 child: Icon(Icons.play_arrow),
    //                 onPressed: _uploadTask.resume,
    //               ),

    //             if (_uploadTask.isInProgress)
    //               MaterialButton(
    //                 child: Icon(Icons.pause),
    //                 onPressed: _uploadTask.pause,
    //               ),

    //             // Progress bar
    //             LinearProgressIndicator(value: progressPercent),
    //             Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
    //           ],
    //         );
    //       });
    // } else {
    // Allows user to decide when to start the upload
    return TextButton.icon(
      label: Text('Upload to Firebase'),
      icon: Icon(Icons.cloud_upload),
      onPressed: () async {
        _startUpload();
        Navigator.pop(context);
      },
    );
    //}
  }
}
