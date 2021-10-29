import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:never_lost/auth/hive.dart';

class DatabaseMethods {
  final firestore = FirebaseFirestore.instance;

  createUserDatabase(String name, String email, uid, photoURL, phone) async {
    Map<String, dynamic> user = {
      "name": name,
      "email": email.toLowerCase(),
      "uid": uid,
      "photoURL": photoURL,
      "status": "I was a TRACTOR!",
      "phone": phone ?? '-'
    };
    await findUserWithEmail(email).then((value) async {
      if (value.isEmpty) {
        await firestore.collection('users').doc(uid).set(user);
      } else {
        user = value;
      }
    });

    return user;
  }

  findUserWithEmail(email) async {
    var user = {};
    await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        user = value.docs[0].data();
      }
    });
    print(user);
    return user;
  }

  updateUserDatabase(userData) async {
    await firestore.collection('users').doc(userData['uid']).update(userData);
  }
}
