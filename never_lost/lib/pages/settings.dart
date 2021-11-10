import 'package:flutter/material.dart';
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/components/loading.dart';

class Settings extends StatefulWidget {
  final user;
  const Settings({Key? key, required this.user}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool masterShare;
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    getUserStream();
  }

  getUserStream() {
    DatabaseMethods().getUserSnapshots(widget.user).listen((event) {
      if (mounted) {
        setState(() {
          masterShare = event.data()!['isShare'];
          isloading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Loading()
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                minLeadingWidth: 0,
                title: Text('Location Sharing'),
                subtitle:
                    Text('This will turn OFF location sharing from all chats'),
                trailing: Switch(
                    value: masterShare,
                    onChanged: (newvalue) {
                      DatabaseMethods().updateMasterLocationSharing(
                          masterShare, widget.user);
                    }),
              ),
            ),
          );
  }
}
