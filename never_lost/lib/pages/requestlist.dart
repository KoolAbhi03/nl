import 'package:flutter/material.dart';
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/components/loading.dart';

class RequestList extends StatefulWidget {
  final List requestList;
  final currentUserUid;
  const RequestList(
      {Key? key, required this.requestList, required this.currentUserUid})
      : super(key: key);

  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  late Stream userStream;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getUserStream().then((v) {
      setState(() {
        isLoading = false;
      });
    });
  }

  getUserStream() async {
    userStream =
        await DatabaseMethods().getUserSnapshots(widget.currentUserUid);
    return userStream;
  }

  Widget requestListView() {
    return StreamBuilder(
        stream: userStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading();
          List requestList = snapshot.data['pendingRequestList'];
          return Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: requestList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.black,
                    child: ListTile(
                      leading: InkWell(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(requestList[index]['photoURL']),
                        ),
                      ),
                      title: Text(requestList[index]['name'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(requestList[index]['email'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: InkWell(
                              onTap: () {
                                DatabaseMethods().acceptFriendRequest(
                                    widget.currentUserUid, requestList[index]);
                              },
                              child: Icon(
                                Icons.done,
                                color: Colors.green[700],
                                size: 35,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: InkWell(
                              onTap: () {
                                DatabaseMethods().rejectFriendRequest(
                                    widget.currentUserUid, requestList[index]);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.red[700],
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor1,
          title: Text('Friend Request'),
        ),
        body: Column(
          children: [
            isLoading
                ? Expanded(child: Loading())
                : Expanded(child: requestListView()),
          ],
        ));
  }
}
