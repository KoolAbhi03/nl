import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuth {
  final firestore = FirebaseFirestore.instance;

  changeProfilePhoto(filep, userUID) async {
    final firebase_storage.FirebaseStorage _storage =
        firebase_storage.FirebaseStorage.instanceFor(
            bucket: 'gs://never-lost-643e9.appspot.com');

    File file = File(filep);
    try {
      String filepath = 'profilePhoto/$userUID/$userUID.png';
      await firebase_storage.FirebaseStorage.instance
          .ref(filepath)
          .delete()
          .catchError((onerror) {
        print('kya hi kr skte hai');
      });
      await firebase_storage.FirebaseStorage.instance
          .ref(filepath)
          .putFile(file);
      dynamic image = await firebase_storage.FirebaseStorage.instance
          .ref(filepath)
          .getDownloadURL();
      await firestore
          .collection('users')
          .doc(userUID)
          .update({'photoURL': image});
      return image;
    } on firebase_core.FirebaseException catch (e) {
      print(e);
      return false;
    }
  }
}
