import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:never_lost/components/map.dart';

class UserAuth {
  final firestore = FirebaseFirestore.instance;

  search(String method, String data) {
    String empty = 'NO such user';
    if (method == 'email') {
      var output = {
        'name': '',
        'email': '',
        'photoURL': '',
      };
      firestore
          .collection('users')
          .where('email', isEqualTo: data)
          .get()
          .then((user) {
        if (user.docs.isEmpty) {
          print(empty);
          return null;
        }
        if (user.docs.isNotEmpty) {
          output['name'] = user.docs[0].data()['name'];
          output['email'] = user.docs[0].data()['email'];
          output['photoURL'] = user.docs[0].data()['photoURL'];
          print(output);
          return output;
        }
      });
    }
    if (method == 'name') {
      var output = {
        'name': '',
        'email': '',
        'photoURL': '',
      };
      firestore
          .collection('users')
          .where('name', isEqualTo: data)
          .get()
          .then((user) {
        if (user.docs.isEmpty) {
          print(empty);
          return null;
        }
        if (user.docs.isNotEmpty) {
          output['name'] = user.docs[0].data()['name'];
          output['email'] = user.docs[0].data()['email'];
          output['photoURL'] = user.docs[0].data()['photoURL'];
          print(output);
          return output;
        }
      });
    }
    if (method == 'phone') {
      var output = {'name': '', 'email': '', 'photoURL': '', 'phone': ''};
      firestore
          .collection('users')
          .where('phone', isEqualTo: data)
          .get()
          .then((user) {
        if (user.docs.isEmpty) {
          print(empty);

          return null;
        }
        if (user.docs.isNotEmpty) {
          output['name'] = user.docs[0].data()['name'];
          output['email'] = user.docs[0].data()['email'];
          output['photoURL'] = user.docs[0].data()['photoURL'];
          output['phone'] = user.docs[0].data()['phone'];
          print(output);
          return output;
        }
      });
    }
  }
}
