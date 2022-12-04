import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:groupchat_app/helper/helper_function.dart';
import 'package:groupchat_app/pages/chat_page.dart';
import 'package:groupchat_app/service/database_service.dart';
import 'package:groupchat_app/widgets/widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController SearchController = TextEditingController();
  bool _isLoading = false;
  bool hasUserSearched = false;
  QuerySnapshot? searchSnapshot;
  String userName = "";
  User? user;
  bool isJoined = false;

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUserIdandName();
    super.initState();
  }

  getCurrentUserIdandName() async {
    await helper_function.getUserName().then((value) {
      if (value != null) {
        userName = value;
      }
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color.fromRGBO(238, 122, 101, 1),
        title: Text(
          "Search",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: Color.fromRGBO(238, 122, 101, 1),
          ),
          child: Row(children: [
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: SearchController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search groups",
                  hintStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                initiateSearch();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 10,
        ),
        _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(238, 122, 101, 1)),
              )
            : groupList()
      ]),
    );
  }

  initiateSearch() async {
    if (SearchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .getGroupByName(SearchController.text)
          .then((value) {
        if (value != null) {
          setState(() {
            _isLoading = false;
            searchSnapshot = value;
            hasUserSearched = true;
          });
        }
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]["groupId"],
                searchSnapshot!.docs[index]["groupName"],
                searchSnapshot!.docs[index]["admin"],
              );
            })
        : Container();
  }

  isJoinedOrNot(String groupId, String groupName) async {
    await DatabaseService(uid: user!.uid)
        .isJoined(groupId, groupName)
        .then((value) {
      if (value != null) {
        setState(() {
          isJoined = value;
        });
      }
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    isJoinedOrNot(groupId, groupName);
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Color.fromRGBO(238, 122, 101, 1),
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(groupName),
      subtitle: Text("admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackbar(context, Colors.red, "Left the group ${groupName}");
          } else {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackbar(context, Colors.green,
                "Successfully joined the group ${groupName}");
            Future.delayed(Duration(seconds: 5));
            nextScreen(
                context,
                ChatPage(
                    groupId: groupId,
                    groupName: groupName,
                    userName: userName));
          }
        },
        child: isJoined
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14)),
                child: Text(
                  "Joined",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 122, 101, 1),
                    borderRadius: BorderRadius.circular(14)),
                child: Text(
                  "Join +",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}
