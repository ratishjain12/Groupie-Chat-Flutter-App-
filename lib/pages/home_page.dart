import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupchat_app/helper/helper_function.dart';
import 'package:groupchat_app/pages/auth/login_page.dart';
import 'package:groupchat_app/pages/profile_page.dart';
import 'package:groupchat_app/pages/search_page.dart';
import 'package:groupchat_app/service/auth_service.dart';
import 'package:groupchat_app/service/database_service.dart';
import 'package:groupchat_app/widgets/group_tile.dart';
import 'package:groupchat_app/widgets/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  String email = "";
  Stream? groups;
  String groupName = "";
  AuthService authService = new AuthService();
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await helper_function.getUserName().then((value) {
      if (value != null) {
        setState(() {
          username = value;
        });
      }
    });
    await helper_function.getEmail().then((value) {
      if (value != null) {
        setState(() {
          email = value;
        });
      }
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((value) {
      if (value != null) {
        groups = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 122, 101, 1),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Groupie Chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: MaterialButton(
              onPressed: () {
                nextScreen(context, SearchPage());
              },
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: ListView(
            children: [
              Icon(
                Icons.account_circle,
                size: 150,
              ),
              Center(
                  child: Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 30,
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                onTap: () {},
                title: Text(
                  'Groups',
                  style: TextStyle(color: Colors.black),
                ),
                selected: true,
                leading: Icon(Icons.group),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                selectedColor: Color.fromRGBO(238, 122, 101, 1),
              ),
              ListTile(
                onTap: () {
                  nextScreenReplace(
                      context,
                      ProfilePage(
                        username: username!,
                        email: email!,
                      ));
                },
                title: Text('Profile'),
                leading: Icon(Icons.account_circle),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                selectedColor: Color.fromRGBO(238, 122, 101, 1),
              ),
              ListTile(
                onTap: () async {
                  authService.signOut().whenComplete(() {
                    nextScreenReplace(context, LoginPage());
                  });
                },
                title: Text('Logout'),
                leading: Icon(Icons.logout),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                selectedColor: Color.fromRGBO(238, 122, 101, 1),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        backgroundColor: Color.fromRGBO(238, 122, 101, 1),
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: groupList(),
    );
  }

  popUpDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Create Group ',
                textAlign: TextAlign.left,
              ),
              content: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                color: Color.fromRGBO(238, 122, 101, 1)),
                          )
                        : TextField(
                            onChanged: (val) {
                              setState(() {
                                groupName = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Group name',
                              labelText: 'Enter name',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(238, 122, 101, 1)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1.5,
                                    color: Color.fromRGBO(238, 122, 101, 1)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(width: 1.5, color: Colors.red),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Color.fromRGBO(238, 122, 101, 1),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    if (groupName != null) {
                      setState(() {
                        _isLoading = true;
                      });
                      await DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(username,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      showSnackbar(
                          context, Colors.green, "Group successfully created");
                      Navigator.of(context).pop();
                    }
                  },
                  color: Color.fromRGBO(238, 122, 101, 1),
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          });
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        groupId: getId(snapshot.data['groups'][reverseIndex]),
                        groupName:
                            getName(snapshot.data['groups'][reverseIndex]),
                        userName: snapshot.data['username']);
                  });
            } else {
              return noGroupList();
            }
          } else {
            return noGroupList();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Color.fromRGBO(238, 122, 101, 1)),
          );
        }
      },
    );
  }

  noGroupList() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {
                  popUpDialog(context);
                },
                child: Icon(
                  Icons.add_circle,
                  size: 75,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "You have not joined a group, tap on the add icon above or \n search for groups using search icon above.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            )
          ],
        ),
      ),
    );
  }
}
