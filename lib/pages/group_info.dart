// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:groupchat_app/helper/helper_function.dart';
import 'package:groupchat_app/pages/home_page.dart';
import 'package:groupchat_app/service/database_service.dart';
import 'package:groupchat_app/widgets/widget.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.adminName,
  }) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  String userName = "";
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    // TODO: implement initState
    getMembers();
    getUsername();
    super.initState();
  }

  getUsername() async {
    await helper_function.getUserName().then((value) {
      if (value != null) {
        setState(() {
          userName = value;
        });
      }
    });
  }

  getMembers() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Group Info"),
        backgroundColor: Color.fromRGBO(238, 122, 101, 1),
        actions: [
          IconButton(
              onPressed: () async {
                await DatabaseService(
                        uid: FirebaseAuth.instance.currentUser!.uid)
                    .toggleGroupJoin(
                        widget.groupId, userName, widget.groupName);
                showSnackbar(context, Colors.red, "You left the group");
                Future.delayed(Duration(seconds: 5));
                nextScreenReplace(context, HomePage());
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromRGBO(238, 122, 101, 1).withOpacity(0.5),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color.fromRGBO(238, 122, 101, 1),
                    radius: 30,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  title: Text("Group: ${widget.groupName}"),
                  subtitle: Text("Admin name: ${getName(widget.adminName)}"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              memberList(),
            ],
          ),
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null) {
              if (snapshot.data["members"].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data["members"].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color.fromRGBO(238, 122, 101, 1),
                            radius: 30,
                            child: Text(
                              getName(snapshot.data["members"][index])
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          title: Text(
                              "${getName(snapshot.data["members"][index])}"),
                          subtitle:
                              Text("${getId(snapshot.data["members"][index])}"),
                        ),
                      );
                    });
              } else {
                return Center(child: Text("No members"));
              }
            } else {
              return Center(child: Text("No members"));
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                  color: Color.fromRGBO(238, 122, 101, 1)),
            );
          }
        });
  }
}
