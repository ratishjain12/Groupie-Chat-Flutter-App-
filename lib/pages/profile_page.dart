import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:groupchat_app/pages/home_page.dart';
import 'package:groupchat_app/service/auth_service.dart';
import 'package:groupchat_app/widgets/widget.dart';

import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  const ProfilePage({super.key, required this.username, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(238, 122, 101, 1),
          title: Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
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
                  widget.username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  height: 2,
                ),
                ListTile(
                  onTap: () {
                    nextScreenReplace(context, HomePage());
                  },
                  title: Text(
                    'Groups',
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: Icon(Icons.group),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  selectedColor: Color.fromRGBO(238, 122, 101, 1),
                ),
                ListTile(
                  onTap: () {},
                  selected: true,
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
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 170, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.account_circle,
                  size: 200,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Username:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(widget.username,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Divider(
                height: 20,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(widget.email,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              Divider(
                height: 20,
                thickness: 1,
              ),
            ],
          ),
        ));
  }
}
